SET search_path TO mimiciii;

SELECT 
  EXTRACT(epoch FROM AGE(charttime, intime)) AS time_secs,
  label, valuenum, valueuom, warning, error
FROM chartevents 
JOIN icustays USING (icustay_id)
JOIN d_items USING (itemid)
WHERE
  icustay_id = 271350 -- manually specify based on previous query
  -- only want the long time series values,
  -- this pares down to the relevant ones
	AND label IN (
	  'Heart Rate',
	  'Arterial Blood Pressure systolic',
	  'Arterial Blood Pressure diastolic',
	  'Respiratory Rate',
	  'O2 saturation pulseoxymetry',
	  'Temperature Fahrenheit'
  )
ORDER BY itemid, charttime;
