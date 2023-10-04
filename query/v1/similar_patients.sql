SET search_path TO mimiciii;

-- manually confirmed: two patients that died for admissions w/o ICU periods
-- did not die any time near their admission/discharge

SELECT hadm_id, gender,
	CASE WHEN dod
		IS NULL THEN false
		ELSE (dod BETWEEN first_icu AND last_icu) END
	AS died,
	EXTRACT(epoch FROM AGE(dischtime, admittime))/3600 AS staytime_hrs,
	icutime_hrs
FROM admissions
JOIN patients USING (subject_id)
JOIN (
	SELECT hadm_id FROM diagnoses_icd WHERE icd9_code LIKE 'V450%' GROUP BY hadm_id
) icd9 USING (hadm_id)
LEFT JOIN (
	SELECT
		hadm_id,
		EXTRACT(epoch FROM SUM(AGE(outtime, intime)))/3600 AS icutime_hrs,
		MIN(intime) - interval '6 hour' AS first_icu,
		MAX(outtime) + interval '6 hour' AS last_icu
	FROM icustays
	GROUP BY hadm_id
) icu USING (hadm_id)
WHERE DATE_PART('year', AGE(admittime, dob)) BETWEEN 60 AND 64;
