

setup.data: myocamlbuild.ml
	oasis setup -setup-update dynamic

configure: setup.data
	ocaml setup.ml -configure $(COPT)

build:
	ocaml setup.ml -build

report_dir:
	mkdir report_dir

report: report_dir
	bisect-report -I _build -html report_dir $(shell ls -t bisect*.out | head -1)

clean:
	rm -rf _build

clean_reports:
	rm -rf report_dir bisect*.out

distclean: clean clean_reports
	rm -rf setup.ml setup.data setup.log

.PHONY: build clean clean_reports distclean
