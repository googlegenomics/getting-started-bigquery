#standardSQL
--
-- Retrieve sample-level information for BRCA1 variants.
--
SELECT
  reference_name,
  start,
  `end`,
  reference_bases,
  ARRAY_TO_STRING(v.alternate_bases, ',') AS alts,
  quality,
  ARRAY_TO_STRING(v.filter, ',') AS filters,
  ARRAY_TO_STRING(v.names, ',') AS names,
  call.call_set_name,
  (SELECT STRING_AGG(CAST(gt AS STRING)) from UNNEST(call.genotype) gt) AS genotype
FROM
  `@THE_TABLE` v, v.call call
WHERE
  reference_name IN ('17', 'chr17')
  AND start BETWEEN 41196311 AND 41277499 # per GRCh37
  -- Skip non-variant segments.
  AND EXISTS (SELECT alt FROM UNNEST(v.alternate_bases) alt WHERE alt NOT IN ("<NON_REF>", "<*>"))
ORDER BY
  start,
  alts,
  call_set_name
