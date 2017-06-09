#standardSQL
--
-- Sample variant counts within BRCA1.
--
WITH brca1_calls AS (
  SELECT
    reference_name,
    start,
    `end`,
    reference_bases,
    ARRAY_TO_STRING(v.alternate_bases, ',') AS alts,
    call.call_set_name,
    call.genotype[SAFE_ORDINAL(1)] AS first_allele,
    call.genotype[SAFE_ORDINAL(2)] AS second_allele
  FROM
    `@THE_TABLE` v, v.call call
  WHERE
    reference_name IN ('chr17', '17')
    AND start BETWEEN 41196311 AND 41277499 # per GRCh37
)

SELECT
  call_set_name,
  COUNT(call_set_name) AS variant_count
FROM brca1_calls
WHERE
    first_allele > 0 OR second_allele > 0
GROUP BY
  call_set_name
ORDER BY
  call_set_name
