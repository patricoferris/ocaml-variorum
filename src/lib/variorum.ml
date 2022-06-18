module T = Variorum_c.C.Type
module F = Variorum_c.C.Functions

let with_error = function
  | 0 -> Ok ()
  | n -> Error (`Msg (F.get_variorum_error_message n))

let cap_each_core_frequency_limit = F.variorum_cap_each_core_frequency_limit
let print_power_limit () = F.variorum_print_power_limit () |> with_error
let print_thermals () = F.variorum_print_thermals () |> with_error
let print_counters () = F.variorum_print_counters () |> with_error
let print_power () = F.variorum_print_power () |> with_error
let print_hyperthreading () = F.variorum_print_hyperthreading () |> with_error
let print_topology () = F.variorum_print_topology ()
let print_energy () = F.variorum_print_energy () |> with_error
