(* OASIS_START *)
(* OASIS_STOP *)
open Ocamlbuild_plugin
open Ocamlbuild_pack

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

let lib_dir pkg =
  let ic = Unix.open_process_in ("ocamlfind query " ^ pkg) in
  let line = input_line ic in
  close_in ic;
  line

let rec copy_mlt_files path =
  let elements = Pathname.readdir path in
  Array.iter 
    (fun p ->
      if Pathname.is_directory (path / p) then
        copy_mlt_files (path / p)
      else if Pathname.check_extension p "mlt" then
        let src = path / p in
        let dst = !Options.build_dir / path / p in
        Shell.mkdir_p (!Options.build_dir / path);
        Pathname.copy src dst
      else
        ())
    elements

let () =
  let additional_rules = function
      | After_rules     ->
        if has_coverage () then
          begin
            let bsdir = Printf.sprintf "%s/%s" (lib_dir "bisect") in
            flag ["pp"]                        (S [A"camlp4o"; A"str.cma"; A (bsdir "bisect_pp.cmo")]);
            flag ["compile"]                   (S [A"-I"; A (bsdir "")]);
            flag ["link"; "byte"; "program"]   (S [A"-I"; A (bsdir ""); A"bisect.cmo"]);
            flag ["link"; "native"; "program"] (S [A"-I"; A (bsdir ""); A"bisect.cmx"]);
          end
        else
          begin
            let kpdir = Printf.sprintf "%s/%s" (lib_dir "kaputt") in
            copy_mlt_files "src";
            flag ["kaputt"; "pp"]              (S [A (kpdir "kaputt_pp.byte"); A"on"; A"camlp4o"]);
            flag ["compile"]                   (S [A"-I"; A (kpdir "")]);
            flag ["link"; "native"; "program"] (S [A"-I"; A (kpdir ""); A"kaputt.cmx"]);
          end
      | _ -> ()
  in
  dispatch
    (MyOCamlbuildBase.dispatch_combine
      [MyOCamlbuildBase.dispatch_default conf package_default;
      additional_rules])
