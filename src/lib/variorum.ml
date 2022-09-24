module T = Variorum_c.C.Type
module F = Variorum_c.C.Functions

let with_error = function
  | 0 -> Ok ()
  | n -> Error (`Msg (F.get_variorum_error_message n))

let with_error_value v = function
  | 0 -> Ok v
  | n -> Error (`Msg (F.get_variorum_error_message n))

let cap_each_core_frequency_limit i =
  F.variorum_cap_each_core_frequency_limit i |> with_error

let print_power_limit () = F.variorum_print_power_limit () |> with_error
let print_thermals () = F.variorum_print_thermals () |> with_error
let print_counters () = F.variorum_print_counters () |> with_error
let print_power () = F.variorum_print_power () |> with_error
let print_hyperthreading () = F.variorum_print_hyperthreading () |> with_error
let print_topology () = F.variorum_print_topology ()
let print_energy () = F.variorum_print_energy () |> with_error
let topology_error n = if n < 0 then Error (`Msg "Topology error") else Ok n
let get_num_of_sockets () = F.variorum_get_num_sockets () |> topology_error
let get_num_cores () = F.variorum_get_num_cores () |> topology_error
let get_num_threads () = F.variorum_get_num_threads () |> topology_error

module Node_power = struct
  let ( >>= ) = Result.bind

  type t = {
    hostname : string;
    timestamp : float;
    power_node : float;
    num_sockets : int;
    power_cpu_watts_socket : float list;
    power_mem_watts_socket : float list;
    power_gpu_watts_socket : float list;
  }

  let hostname t = t.hostname
  let timestamp t = t.timestamp
  let power_node t = t.power_node
  let num_sockets t = t.num_sockets
  let power_cpu_watts_socket t = t.power_cpu_watts_socket
  let power_mem_watts_socket t = t.power_mem_watts_socket
  let power_gpu_watts_socket t = t.power_gpu_watts_socket

  let to_json t =
    `O
      [
        ("hostname", `String t.hostname);
        ("timestamp", `Float t.timestamp);
        ("power_node_watts", `Float t.power_node);
        ("num_sockets", `Float (float_of_int t.num_sockets));
        ( "power_cpu_watts_socket",
          `A (List.map Ezjsonm.float t.power_cpu_watts_socket) );
        ( "power_mem_watts_socket",
          `A (List.map Ezjsonm.float t.power_mem_watts_socket) );
        ( "power_gpu_watts_socket",
          `A (List.map Ezjsonm.float t.power_gpu_watts_socket) );
      ]

  let get_socket json n =
    let nth s = s ^ "_" ^ string_of_int n in
    try
      let power_cpu_watts_socket =
        List.assoc (nth "power_cpu_watts_socket") json |> Ezjsonm.get_float
      in
      let power_mem_watts_socket =
        List.assoc (nth "power_mem_watts_socket") json |> Ezjsonm.get_float
      in
      let power_gpu_watts_socket =
        List.assoc (nth "power_gpu_watts_socket") json |> Ezjsonm.get_float
      in
      Some
        (power_cpu_watts_socket, power_mem_watts_socket, power_gpu_watts_socket)
    with Not_found -> None

  let of_json = function
    | `O json ->
        let hostname = List.assoc "hostname" json |> Ezjsonm.get_string in
        let timestamp = List.assoc "timestamp" json |> Ezjsonm.get_float in
        let power_node =
          List.assoc "power_node_watts" json |> Ezjsonm.get_float
        in
        let rec loop (cpu, mem, gpu) n =
          match get_socket json n with
          | None -> (List.rev cpu, List.rev mem, List.rev gpu)
          | Some (c, m, g) -> loop (c :: cpu, m :: mem, g :: gpu) (n + 1)
        in
        let cpu, mem, gpu = loop ([], [], []) 0 in

        Ok
          {
            hostname;
            timestamp;
            power_node;
            num_sockets = List.length cpu;
            power_cpu_watts_socket = cpu;
            power_mem_watts_socket = mem;
            power_gpu_watts_socket = gpu;
          }
    | _ -> Error (`Msg "Parsing node power failed!")

  let get () =
    let open Ctypes in
    (* Calculation based on: https://github.com/LLNL/variorum/blob/aa5bfa84dd50b144df95c642a4cad9fe22ea08a4/src/examples/variorum-get-node-power-json-example.c#L47*)
    get_num_of_sockets () >>= fun sockets ->
    let s = allocate_n string ~count:(((sockets * 150) + 180) * sizeof char) in
    let res = F.variorum_get_node_power_json s in
    with_error_value !@s res >>= fun s ->
    Printf.printf "JSON: %s\n%!" s;
    of_json (Ezjsonm.from_string s)

  let get_domain_info () =
    let open Ctypes in
    let s = allocate_n string ~count:(800 * sizeof char) in
    let res = F.variorum_get_node_power_domain_info_json s in
    with_error_value !@s res
end
