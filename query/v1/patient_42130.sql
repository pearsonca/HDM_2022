SET search_path TO mimiciii;

-- n.b. manually verified subject_id = 42130 has only one visit
-- & Simvastatin was prescribed during it
--
-- SELECT COUNT(*) FROM admissions WHERE subject_id = 42130 GROUP BY hadm_id; 
--
-- SELECT hadm_id, COUNT(*)
-- FROM prescriptions
-- WHERE subject_id = 42130 AND LOWER(drug) LIKE 'simvas%'
-- GROUP BY hadm_id;
-- 
-- therefore no requirement for complicated JOIN below to filter
-- for that visit
--
-- also checked first_careunit / ward_id == last ones

SELECT
  -- some demographic data
  subject_id, gender,
  DATE_PART('years', AGE(admittime, dob)) AS admitage_yrs,
  language, ethnicity,
  -- stay data
  diagnosis,
  EXTRACT(epoch FROM AGE(dischtime, admittime))/3600 AS stay_hrs,
  EXTRACT(epoch FROM AGE(outtime, intime))/3600 AS icustay_hrs,
  first_careunit, first_wardid,
  code_summary, drugs
FROM patients
JOIN admissions USING (subject_id)
JOIN icustays USING (hadm_id, subject_id)
-- get the ICD9 code data
JOIN (
	SELECT
		hadm_id,
		ARRAY_TO_STRING(ARRAY_AGG(icddesc),', ') AS code_summary
	FROM (
		SELECT
		  hadm_id, CONCAT(short_title, ' (', icd9_code,')') AS icddesc
		FROM diagnoses_icd
		JOIN d_icd_diagnoses USING (icd9_code)
		ORDER BY hadm_id, icd9_code
	) sort_icd
	GROUP BY hadm_id
) icd9 USING (hadm_id)
-- get the prescription data
JOIN (
	SELECT
		hadm_id, 
		ARRAY_TO_STRING(ARRAY_AGG(drug_c),', ') AS drugs
	FROM (SELECT hadm_id, CONCAT(drug, ' x', COUNT(*)) AS drug_c FROM prescriptions GROUP BY hadm_id, drug) rx
	GROUP BY hadm_id
) drg USING (hadm_id)
WHERE subject_id = 42130;
