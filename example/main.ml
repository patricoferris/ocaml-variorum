let ( >>= ) = Result.bind

let main () =
  Variorum.Node_power.get () >>= fun node_power ->
  Printf.printf "%s\n" (Ezjsonm.value_to_string (Variorum.Node_power.to_json node_power));
  Variorum.Node_power.get_domain_info () >>= fun domain_info ->
  print_endline domain_info;
  Variorum.print_power ()

let () = match main () with Ok () -> () | Error (`Msg m) -> print_endline m
