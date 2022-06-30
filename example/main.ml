let () =
  Variorum.print_topology ();
  match Variorum.print_power_limit () with
  | Ok () -> ()
  | Error (`Msg m) -> print_endline m
