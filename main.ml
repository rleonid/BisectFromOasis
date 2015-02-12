let () = 
  if Array.length Sys.argv > 1 then
    print_endline (Printf.sprintf "Hello %s"  Sys.argv.(1))
  else
    print_endline "Hello Bisect Coverage!"
