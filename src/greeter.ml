
let greet ?person () = 
  match person with
  | None    -> print_endline "Hello Bisectg Coverage!"
  | Some p  -> print_endline (Printf.sprintf "Hello %s" p)
