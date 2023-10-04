
default: HDM.pdf

data query:
	mkdir $@

data/%.csv: R/query_manage.R query/%.sql | data
	Rscript $^ $@

data/v1/summaried_table.csv: R/died_summary.R data/v1/summary_died.csv
	Rscript $^ $@

data/v2/summaried_table.csv: R/died_summary.R data/v2/summary_died.csv
	Rscript $^ $@

data/similar_table.csv: R/similar.R data/v1/similar_patients.csv
	Rscript $^ $@

data/similar_table_v2.csv: R/similar_v2.R data/v1/similar_patients.csv
	Rscript $^ $@

vitals_fig_v1.png: R/vitals.R data/v1/detail_271350.csv
	Rscript $^ $@

vitals_fig_v2.png: R/vitals.R data/v2/detail_274006.csv
	Rscript $^ $@

icu_fig.png: R/icu_comps.R data/icustays.csv
	Rscript $^ $@

icu_fig_v2.png: R/icu_comps.R data/v2/icustays.csv
	Rscript $^ $@

ALLFILES := patient_42130 detail_271350 similar_patients summary_died icustays

allcsvs: $(patsubst %,data/%.csv,$(ALLFILES))

HDM.pdf: HDM.qmd vitals_fig.png icu_fig.png data/summaried_table.csv data/similar_table.csv
	quarto render $<