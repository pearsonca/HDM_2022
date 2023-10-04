SET search_path TO mimiciii;

SELECT
	subject_id, first_careunit, gender,
	admitage, icutime_hrs/24 AS icutime_days,
	code_summary, title_summary
FROM (
-- trimmed version of the similar_patients query
	SELECT
		hadm_id, subject_id, gender,
		DATE_PART('year', AGE(admittime, dob)) AS admitage,
		CASE WHEN dod
		  IS NULL THEN false
		  ELSE (dod BETWEEN first_icu AND last_icu) END
		AS died,
		icutime_hrs,
		first_careunit
	FROM (
		SELECT
			hadm_id,
			EXTRACT(epoch FROM SUM(AGE(outtime, intime)))/3600 AS icutime_hrs,
			MIN(intime) - interval '6 hour' AS first_icu,
			MAX(outtime) + interval '6 hour' AS last_icu,
			(ARRAY_AGG(first_careunit))[1] AS first_careunit
		-- only want admissions where cardiac device indicated => JOIN
		FROM (
			SELECT hadm_id FROM diagnoses_icd WHERE icd9_code LIKE 'V450%' GROUP BY hadm_id
		) cardiacdevs
		-- we know all the deaths have icu time => JOIN
		JOIN icustays USING (hadm_id)
		GROUP BY hadm_id
	) cardiacadmits
	JOIN admissions USING (hadm_id)
	JOIN patients USING (subject_id)
	WHERE DATE_PART('year', AGE(admittime, dob)) BETWEEN 60 AND 64
) simpats
JOIN (
	SELECT
		hadm_id,
		ARRAY_TO_STRING(ARRAY_AGG(icd9_code),', ') AS code_summary,
		ARRAY_TO_STRING(ARRAY_AGG(short_title),', ') AS title_summary
	FROM (SELECT * FROM diagnoses_icd ORDER BY hadm_id, icd9_code) sort_icd
	JOIN d_icd_diagnoses USING (icd9_code)
	GROUP BY hadm_id
) icd9 USING (hadm_id)
WHERE died = true;