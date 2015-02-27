default:
	@echo "available targets:"
	@echo "  setup.data     generate setup.dataj"
	@echo "  configure EN   configure project where EN are optional arguments (ex --enable-coverage) to pass to Oasis."
	@echo "  build          build binaries"
	@echo "  report         create a report web page in report_dir/ based off of a trial run"
	@echo "  clean          remove _build directory"
	@echo "  clean_reports  remove report_dir irectory"
	@echo "  distclean      remove setup files for build as well as previous 2 targets."

setup.data: myocamlbuild.ml
	oasis setup -setup-update dynamic

configure: setup.data
	ocaml setup.ml -configure $(EN)

build:
	ocaml setup.ml -build

report_dir:
	mkdir report_dir

report: report_dir
	bisect-report -I _build -html report_dir $(shell ls -t bisect*.out | head -1)

clean:
	rm -rf _build main.native main_lib.native

clean_reports:
	rm -rf report_dir bisect*.out

distclean: clean clean_reports
	rm -rf setup.ml setup.data setup.log

.PHONY: default build clean clean_reports distclean
