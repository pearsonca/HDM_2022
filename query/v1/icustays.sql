SET search_path TO mimiciii;

SELECT
	hadm_id,
	CASE
		WHEN DATE_PART('year', AGE(admittime, dob)) BETWEEN 60 AND 64 THEN '60-65'
		ELSE 'other' END
	AS admitage,
	icutime,
	icu_careunit,
	CASE WHEN has_device IS NULL THEN false ELSE has_device END AS has_device,
	CASE WHEN has_simvastatin IS NULL THEN false ELSE has_simvastatin END AS has_simvastatin
FROM admissions
JOIN patients USING (subject_id)
JOIN ( -- only consider admissions with *some* ICU time => JOIN
	SELECT
		hadm_id, EXTRACT(epoch FROM SUM(outtime - intime))/3600 as icutime,
		(ARRAY_AGG(first_careunit))[1] icu_careunit -- resolve ambiguity in multi-icu-ward admits in favor of first careunit
	FROM (
		SELECT hadm_id, intime, outtime, first_careunit FROM icustays ORDER BY hadm_id, intime
	) ics
	GROUP BY hadm_id
) icudata USING (hadm_id)
LEFT JOIN ( -- may have admissions indicating at least one cardiac device => LEFT JOIN
	SELECT hadm_id, true AS has_device FROM diagnoses_icd WHERE icd9_code LIKE 'V450%' GROUP BY hadm_id
) cardiacdev USING (hadm_id)
LEFT JOIN ( -- may have admissions indicating at least one simvastatin prescription => LEFT JOIN
	SELECT hadm_id, true AS has_simvastatin FROM prescriptions WHERE gsn LIKE '%016579%' OR gsn LIKE '%016577%' GROUP BY hadm_id
) simvas USING (hadm_id); 
