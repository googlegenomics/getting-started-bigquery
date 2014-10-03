# Count the number of records and nested calls for each reference.
SELECT
  reference_name,
  COUNT(reference_name) AS num_records,
  COUNT(call.call_set_name) AS num_calls
FROM
  [_THE_TABLE_]
GROUP BY
  reference_name
ORDER BY
  reference_name
