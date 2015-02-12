
report_dir:
	mkdir report_dir

report: report_dir
	bisect-report -I _build -html report_dir $(shell ls -t bisect*.out | head -1)
