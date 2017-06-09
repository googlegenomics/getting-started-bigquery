#standardSQL
--
-- Count the number of records and nested calls for each reference.
--
SELECT
  reference_name,
  COUNT(reference_name) AS num_records,
  COUNT(call.call_set_name) AS num_calls
FROM
  `@THE_TABLE` v, v.call call
GROUP BY
  reference_name
ORDER BY
  reference_name
