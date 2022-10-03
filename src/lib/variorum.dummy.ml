let undefined _ =
  let exception Undefined in
  raise Undefined

let supported = false
let cap_each_core_frequency_limit = undefined
let print_power_limit = undefined
let print_thermals = undefined
let print_counters = undefined
let print_power = undefined
let print_hyperthreading = undefined
let print_topology = undefined
let print_energy = undefined
let get_num_of_sockets = undefined
let get_num_cores = undefined
let get_num_threads = undefined

module Node_power = struct
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

  let get = undefined
  let get_domain_info = undefined
end
