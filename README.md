# BisectFromOasis
Example of an OCaml project compiled with [Oasis](http://oasis.forge.ocamlcore.org/MANUAL.html) with optional code coverage provided by [Bisect](http://bisect.x9c.fr/index.html).

## Setup
`opam install bisect`

## Steps:

  1. Create `_oasis`

     Becareful about creating a `Makefile` via `DevFiles` since Oasis will whipe out targets used for creating report, below.
  2. Create `myocamlbuild.ml`
  3. `oasis setup -setup-update dynamic`
     
     `none` will have `Oasis` write out a `_tags` file which tries to link bisect against all `*.ml`.
  4. `ocaml setup.ml -configure --[disable|enable]-coverage`

     Can't pass arguments to make file.
  5. `ocaml setup.ml -build`
  6. `make report`
     Create webpage in `report_dir`.
