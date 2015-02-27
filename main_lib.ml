let () = 
  if Array.length Sys.argv > 1 then
    Greeter.greet ~person:Sys.argv.(1) ()
  else
    Greeter.greet ()
