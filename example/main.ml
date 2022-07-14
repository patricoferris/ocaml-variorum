let ( >>= ) = Result.bind

let main () =
  Variorum.Node_power.get () >>= fun node_power ->
  print_endline node_power;
  Variorum.Node_power.get_domain_info () >>= fun domain_info ->
  print_endline domain_info;
  Variorum.print_power ()

let () = match main () with Ok () -> () | Error (`Msg m) -> print_endline m
