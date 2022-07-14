open Ctypes
module T = Types_generated

module Functions (F : Ctypes.FOREIGN) = struct
  open F

  let get_variorum_error_message =
    foreign "get_variorum_error_message" (int @-> returning string)

  let variorum_cap_each_core_frequency_limit =
    foreign "variorum_cap_each_core_frequency_limit" (int @-> returning int)

  (* Printing *)
  let variorum_print_power_limit =
    foreign "variorum_print_power_limit" (void @-> returning int)

  let variorum_print_thermals =
    foreign "variorum_print_thermals" (void @-> returning int)

  let variorum_print_counters =
    foreign "variorum_print_counters" (void @-> returning int)

  let variorum_print_power =
    foreign "variorum_print_power" (void @-> returning int)

  let variorum_print_hyperthreading =
    foreign "variorum_print_hyperthreading" (void @-> returning int)

  let variorum_print_topology =
    foreign "variorum_print_topology" (void @-> returning void)

  let variorum_print_energy =
    foreign "variorum_print_energy" (void @-> returning int)

  (* Hardware  *)

  let variorum_get_num_sockets =
    foreign "variorum_get_num_sockets" (void @-> returning int)

  let variorum_get_num_cores =
    foreign "variorum_get_num_cores" (void @-> returning int)

  let variorum_get_num_threads =
    foreign "variorum_get_num_threads" (void @-> returning int)

  (* JSON API *)
  let variorum_get_node_power_json =
    foreign "variorum_get_node_power_json" (ptr string @-> returning int)

  let variorum_get_node_power_domain_info_json =
    foreign "variorum_get_node_power_domain_info_json"
      (ptr string @-> returning int)
end
