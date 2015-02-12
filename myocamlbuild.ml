(* OASIS_START *)
(* OASIS_STOP *)
open Ocamlbuild_plugin

let has_coverage () =
  let key = "coverage=" in
  let n   = String.length key in
  try
    let ic = open_in "setup.data" in
    let rec l () =
      let s = input_line ic in
      if String.sub s 0 n = key then
        let sub = String.sub s (n + 1) (String.length s - n - 2) in
        bool_of_string sub
      else
        l ()
    in
    l ()
  with _ -> false

let () =
  let additional_rules = function
      | After_rules     ->
        if has_coverage () then
          begin
            flag ["pp"]             (S [A"camlp4o"; A"str.cma"; A"/Users/leonidrozenberg/.opam/4.01.0/lib/bisect/bisect_pp.cmo"]);
            flag ["compile"]        (S [A"-I"; A"/Users/leonidrozenberg/.opam/4.01.0/lib/bisect"]);
            flag ["link"; "byte"]   (S [A"-I"; A"/Users/leonidrozenberg/.opam/4.01.0/lib/bisect"; A"bisect.cma"]);
            flag ["link"; "native"] (S [A"-I"; A"/Users/leonidrozenberg/.opam/4.01.0/lib/bisect"; A"bisect.cmxa"]);
            flag ["link"; "java"]   (S [A"-I"; A"/Users/leonidrozenberg/.opam/4.01.0/lib/bisect"; A"bisect.cmja"])
          end
        else
          ()
      | _ -> ()
  in
  dispatch additional_rules
