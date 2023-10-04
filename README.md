# Overview

Each section has 10 elements and is worth 10 points. Most of the questions are worth 1 or 0, with some of the more elaborate / subjective ones allowing for a 0.5 result.

Some items are marked (FIRST ONLY), meaning only the first marker needs to check this item (though the 2nd marker is allowed to do so).

FIRST MARKER: In addition to providing the marks, you also need to prepare written feedback. You should provide 2-3 notes (1-2 sentences), for each of the three dimensions below, on items you think the student did particularly well. Similarly, you should provide 2-3 notes, per section, on items from the rubric below where the student received 0 points. For this critical feedback, your notes should include how to remedy the issue, and where there are more than 2-3 0s on items, you should prioritize the issues that are easiest to fix.

# Obtaining Materials

Log into [Moodle](ble.lshtm.ac.uk), navigate to the latest offering of HDM (should be dashboard => my courses => academic year at the top of list => HDM link), then open the assessment tile, scroll down and click on the assessment submission point. You should see only your assigned submissions for review. Conveniently, you can also get all of your assigned scripts at once by clicking the selection box beside "Grading Action" and picking "Download submitted files". This will initiate a download of a zip file of all your assigned scripts.

# Section Rubrics

## Report Rubric

For example, see example HDM.pdf

1.  Does it fit in 2 pages? 0 (no) or 1 (yes)
2.  Are all table / plot labels in typical English / human readable format? No syntax / code artefacts? 0 (no), 0.5 (mostly / some artefacts), 1 (yes)
3.  Does it contain a table of data for patient 42130? 0 (no or wrong patient) or 1 (yes)
4.  ... containing total stay time (in reasonable units: days or hours), ICU time (ibid), and diagnoses + codes, prescriptions, and summarizing demographic data (age, gender, ethnicity, &c)? 0 (no), 0.5 (partially / crap units / limited or too much demographic data), 1 (yes)
5.  Is there a plot of vitals? 0 (no), 0.5 (yes, but too few / too many), 1 (yes - roughly heart rate, blood pressure, oxygen %, temp +/- a few)
6.  Is there a summary table of stay times for similar patients, stratified by gender and death? 0 (no) or 1 (yes)
7.  Is there a summary table of those similar patients that died, with id, care unit, gender, age at admission, total days in ICU, and diagnoses? 0 (no), 0.5 (partial), 1 (all)
8.  Is there a visualization, organized by ICU, showing average ICU time? 0 (no), 0.5 (partial / organized by wards instead of units), 1 (yes)
9.  ... with all the correct population / ICU divisions (by all, all 60-65 with cardiac device, 60-65 with cardiac device & simvastatin prescribed, 60-65 with cardiac device & simvastatin NOT prescribed AND with across all ICUs)? 0 (no), 0.5 (some), 1 (yes)
10. Is there a notes section explaining how ambiguities dealt with? 0 (no), 0.5 (only addresses one of simvastatin & summarization choices), 1 (addresses both simvastatin & summarization choices, +whatever else)

Note: there's lots of subjective choice that we allow here. E.g., if people decide to lean into some clinical knowledge (e.g. excluding the NICU for the final Qs) AND explain that choice in the notes section, that's fine!

## SQL Rubric

See contents of `query` folder for examples for each of the stages (plus some support checking code).

1.  Is there consistent use of CASE or case for SQL keywords / functions vs selected columns, tables, etc? 0 (no) or 1 (yes)
2.  Is there consistent organization of code into sections e.g. starting FROMs or JOINs on their own lines, indentation, ...? 0 (no), 0.5 (mostly consistent, some exceptions), 1 (yes)
3.  Are there comments to explain where hard coded numbers / comparisons (e.g. restricting the chartevents to a set of vitals) happen? Where queries make assumptions? Where lots of query calls for explanation? 0 (no), 0.5 (too little or too much), 1 (yes)
4.  Are hard coded WHERE clauses limited? 0 (in most queries), 0.5 (some / poorly explained), 1 (very limited & explained)
5.  (FIRST ONLY) Do all the query files work? 0 (no) or 1 (yes)
6.  Do the queries generally avoid `SELECT *` and return only needed data? 0 (in most queries), 0.5 (mixed), 1 (limited & explained)
7.  Are JOINs / sub SELECTs used in a straightforward and efficient fashion? 0 (no - e.g. too many layers of subselects), 0.5 (mixed), 1 (yes - all queries easy to read / execute quickly)
8.  Is aggregation, time conversion, processing, etc handled in queries? Are the queries correct? 0 (no), 0.5 (some), 1 (all correct, more processing done in SQL, give or take quantiling)
9.  Is code used across queries in a consistent manner? 0 (no - very different approaches for e.g. finding the similar patients in iii vs iv) or 1 (yes)
10. When using AS, are the names sensible? 0 (generally no), 1 (generally yes)

## Supporting Code

See this repository generally for example organization / R code (`Makefile` + `R/` + `query/` directories).

1.  Are the supporting code + SQL files packaged in a reasonable, documented way? 0 (no), 0.5 (somewhat), 1 (yes)
2.  Is there a clear, code-driven organization (e.g. not just a README, but file names, etc) of which SQL files =\> what data =\> what inputs in any plotting / tabling / calculating code? 0 (no) or 1 (yes)
3.  (FIRST ONLY) Does the supporting code run with minimal fiddling? 0 (no) or 1 (yes)
4.  (FIRST ONLY) Can the entire report be generated from scratch with a single action (given database access)? 0 (no) or 1 (yes)
5.  Does the supporting code use only data from SQL outputs? Does the code *NOT* expose any sensitive data (n.b. database access user / password is sensitive data)? 0 (no - has some data hard coded / exposes sensitive data) or 1 (yes)
6.  Would the code generally pass a linter? E.g. consistent variable naming style, reasonable line lengths, ...? 0 (no), 0.5 (mixed), 1 (yes)
7.  Is the supporting code complete? I.e. code for all plots / computed values. 0 (no) or 1 (yes)
8.  Is the code internally commented appropriately? 0 (no) or 1 (no)
9.  Is the supporting code organized? e.g. separate scripts or delineated sections for each plot, separate worksheets if using Excel? Appropriate level of DRY / no copy-pasta spaghetti code? 0 (no) or 1 (yes)
10. Are all code calculations / transformations / etc correctly implemented? 0 (no), 0.5 (mostly), 1 (yes)
