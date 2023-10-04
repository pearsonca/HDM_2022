SET search_path TO mimiciii;

SELECT
	drug, gsn, ndc
FROM prescriptions
WHERE
--	LOWER(drug) LIKE '%simvas%' OR
--	LOWER(drug) LIKE '%zocor%' OR
	gsn LIKE '%016579%' OR gsn LIKE '%016577%' -- this seems to cover all options
GROUP BY drug, gsn, ndc;

-- SELECT * FROM prescriptions LIMIT 10;