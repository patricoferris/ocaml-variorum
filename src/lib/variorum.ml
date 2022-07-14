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

  let get () =
    let open Ctypes in
    (* Calculation based on: https://github.com/LLNL/variorum/blob/aa5bfa84dd50b144df95c642a4cad9fe22ea08a4/src/examples/variorum-get-node-power-json-example.c#L47*)
    get_num_of_sockets () >>= fun sockets ->
    let s = allocate_n string ~count:(((sockets * 150) + 180) * sizeof char) in
    let res = F.variorum_get_node_power_json s in
    with_error_value !@s res

  let get_domain_info () =
    let open Ctypes in
    let s = allocate_n string ~count:(800 * sizeof char) in
    let res = F.variorum_get_node_power_domain_info_json s in
    with_error_value !@s res
end
