<!-- R Markdown Documentation, DO NOT EDIT THE PLAIN MARKDOWN VERSION OF THIS FILE -->

<!-- Copyright 2014 Google Inc. All rights reserved. -->

<!-- Licensed under the Apache License, Version 2.0 (the "License"); -->
<!-- you may not use this file except in compliance with the License. -->
<!-- You may obtain a copy of the License at -->

<!--     http://www.apache.org/licenses/LICENSE-2.0 -->

<!-- Unless required by applicable law or agreed to in writing, software -->
<!-- distributed under the License is distributed on an "AS IS" BASIS, -->
<!-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. -->
<!-- See the License for the specific language governing permissions and -->
<!-- limitations under the License. -->

# Literate Programming with R and BigQuery

## R Markdown Introduction

This is an [R Markdown](http://rmarkdown.rstudio.com/) document.  By using RMarkdown, we can write R code in a [literate programming](http://en.wikipedia.org/wiki/Literate_programming) style interleaving snippets of code within narrative content.  This document can be read, but it can also be executed.  Most importantly though, it can be rendered so that the results of an R analysis at a point in time are captured.

It is written in [Markdown](http://daringfireball.net/projects/markdown/syntax), a simple formatting syntax for authoring web pages.  See the [`rmarkdown` package](http://cran.r-project.org/web/packages/rmarkdown/index.html) for more detail about how to use RMarkdown from R.  [RStudio](http://www.rstudio.com/) has support for [R Markdown](http://rmarkdown.rstudio.com/) from its user interface.

Now let's proceed with a specific example of [literate programming](http://en.wikipedia.org/wiki/Literate_programming) for [BigQuery](https://cloud.google.com/bigquery/).

## Setup

If you have not used the [bigrquery](https://github.com/hadley/bigrquery) package previously, you will likely need to do something like the following to get it installed:


```r
### To install the bigrquery package.  The currently released version 0.3.0 does not yet
### have the parameter to use Standard SQL instead of Legacy SQL, so we install from github.
library(devtools)
install_github('rstats-db/bigrquery')
```

Next we will load our needed packages into our session:

```r
library(bigrquery)
library(ggplot2)
```

And set a few variables:

```r
######################[ CHANGE ME ]##################################
# This codelab assumes that the current working directory is where the Rmd file resides.
setwd("/YOUR/PATH/TO/getting-started-bigquery/RMarkdown")

# Set the Google Cloud Platform project id under which these queries will run.
project <- "YOUR-PROJECT-ID"
#####################################################################
```


```r
# By default this codelab runs upon the Illumina Platinum Genomes Variants.
# Change the table here if you wish to run these queries against a different table.
theTable <- "genomics-public-data.platinum_genomes.variants"
```


And write a little convenience function:

```r
DisplayAndDispatchQuery <- function(queryUri) {
  # Read in the SQL from a file or URL.
  querySql <- readChar(queryUri, nchars=1e6)
  # Find and replace the table name placeholder with our table name.
  querySql <- sub("@THE_TABLE", theTable, querySql, fixed=TRUE)
  # Display the updated SQL.
  cat(querySql)
  # Dispatch the query to BigQuery for execution.
  query_exec(querySql, project, use_legacy_sql = FALSE)
}
```

## Running a Query in R

Now we're ready to execute our query, bringing the results down to our R session for further examination:

```r
result <- DisplayAndDispatchQuery("../sql/sample-variant-counts-for-brca1.sql")
```

```
# Sample variant counts within BRCA1.
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
    `genomics-public-data.platinum_genomes.variants` v, v.call call
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
```

```
10.7 gigabytes processed
```

Let us examine our query result:

```r
head(result)
```

```
  call_set_name variant_count
1       NA12877            27
2       NA12878           198
3       NA12889           198
4       NA12890            33
5       NA12891            37
6       NA12892           209
```

```r
summary(result)
```

```
 call_set_name      variant_count  
 Length:6           Min.   : 27.0  
 Class :character   1st Qu.: 34.0  
 Mode  :character   Median :117.5  
                    Mean   :117.0  
                    3rd Qu.:198.0  
                    Max.   :209.0  
```

```r
str(result)
```

```
'data.frame':	6 obs. of  2 variables:
 $ call_set_name: chr  "NA12877" "NA12878" "NA12889" "NA12890" ...
 $ variant_count: int  27 198 198 33 37 209
```
We can see that what we get back from bigrquery is an R dataframe holding our query results.

## Data Visualization of Query Results

Now that our results are in a dataframe, we can easily apply data visualization to our results:

```r
ggplot(result, aes(x=call_set_name, y=variant_count)) +
  geom_bar(stat="identity") + coord_flip() +
  ggtitle("Count of Variants Per Sample")
```

<img src="figure/viz-1.png" title="plot of chunk viz" alt="plot of chunk viz" style="display: block; margin: auto;" />

Its clear to see that number of variants within BRCA1 for each sample corresponds roughly to two levels.

We can then examine the variant level data more closely:

```r
result <- DisplayAndDispatchQuery("../sql/variant-level-data-for-brca1.sql")
```

```
# Retrieve variant-level information for BRCA1 variants.
SELECT
  reference_name,
  start,
  `end`,
  reference_bases,
  ARRAY_TO_STRING(v.alternate_bases, ',') AS alts,
  quality,
  ARRAY_TO_STRING(v.filter, ',') AS filter,
  ARRAY_TO_STRING(v.names, ',') AS names,
  ARRAY_LENGTH(v.call) AS num_samples
FROM
  `genomics-public-data.platinum_genomes.variants` v
WHERE
  reference_name IN ('17', 'chr17')
  AND start BETWEEN 41196311 AND 41277499 # per GRCh37
  # Skip non-variant segments.
  AND EXISTS (SELECT alt FROM UNNEST(v.alternate_bases) alt WHERE alt NOT IN ("<NON_REF>", "<*>"))
ORDER BY
  start,
  alts
```

```
9.9 gigabytes processed
```
Number of rows returned by this query: 281.

Displaying the first few rows of the dataframe of results:

|reference_name |    start|      end|reference_bases |alts | quality|filter                                            |names | num_samples|
|:--------------|--------:|--------:|:---------------|:----|-------:|:-------------------------------------------------|:-----|-----------:|
|chr17          | 41196407| 41196408|G               |A    |  733.47|PASS                                              |      |           3|
|chr17          | 41196820| 41196823|CTT             |C,CT |  287.18|PASS                                              |      |           1|
|chr17          | 41197273| 41197274|C               |A    | 1011.08|PASS                                              |      |           3|
|chr17          | 41197957| 41197958|G               |T    |  178.48|TruthSensitivityTranche99.90to100.00              |      |           4|
|chr17          | 41198182| 41198183|A               |C    |   98.02|TruthSensitivityTranche99.00to99.90               |      |           1|
|chr17          | 41198186| 41198187|A               |C    |    7.68|TruthSensitivityTranche99.90to100.00,LowGQX,LowQD |      |           4|


And also work with the sample level data: 

```r
result <- DisplayAndDispatchQuery("../sql/sample-level-data-for-brca1.sql")
```

```
# Retrieve sample-level information for BRCA1 variants.
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
  `genomics-public-data.platinum_genomes.variants` v, v.call call
WHERE
  reference_name IN ('17', 'chr17')
  AND start BETWEEN 41196311 AND 41277499 # per GRCh37
  # Skip non-variant segments.
  AND EXISTS (SELECT alt FROM UNNEST(v.alternate_bases) alt WHERE alt NOT IN ("<NON_REF>", "<*>"))
ORDER BY
  start,
  alts,
  call_set_name
```

```
17.0 gigabytes processed
```
Number of rows returned by this query: 706.


Displaying the first few rows of the dataframe of results:

|reference_name |    start|      end|reference_bases |alts | quality|filters |names |call_set_name |genotype |
|:--------------|--------:|--------:|:---------------|:----|-------:|:-------|:-----|:-------------|:--------|
|chr17          | 41196407| 41196408|G               |A    |  733.47|PASS    |      |NA12878       |0,1      |
|chr17          | 41196407| 41196408|G               |A    |  733.47|PASS    |      |NA12889       |0,1      |
|chr17          | 41196407| 41196408|G               |A    |  733.47|PASS    |      |NA12892       |0,1      |
|chr17          | 41196820| 41196823|CTT             |C,CT |  287.18|PASS    |      |NA12889       |1,2      |
|chr17          | 41197273| 41197274|C               |A    | 1011.08|PASS    |      |NA12878       |0,1      |
|chr17          | 41197273| 41197274|C               |A    | 1011.08|PASS    |      |NA12889       |0,1      |

## Provenance

Lastly, let us capture version information about R and loaded packages for the sake of provenance.

```r
sessionInfo()
```

```
R version 3.4.0 (2017-04-21)
Platform: x86_64-apple-darwin15.6.0 (64-bit)
Running under: macOS Sierra 10.12.5

Matrix products: default
BLAS: /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] ggplot2_2.2.1        bigrquery_0.3.0.9000 knitr_1.16          

loaded via a namespace (and not attached):
 [1] Rcpp_0.12.11      magrittr_1.5      progress_1.1.2   
 [4] munsell_0.4.3     colorspace_1.3-2  R6_2.2.1         
 [7] rlang_0.1.1       highr_0.6         stringr_1.2.0    
[10] httr_1.2.1        plyr_1.8.4        tools_3.4.0      
[13] grid_3.4.0        gtable_0.2.0      DBI_0.6-1        
[16] htmltools_0.3.6   rprojroot_1.2     digest_0.6.12    
[19] openssl_0.9.6     lazyeval_0.2.0    assertthat_0.2.0 
[22] tibble_1.3.3      curl_2.6          evaluate_0.10    
[25] rmarkdown_1.5     labeling_0.3      stringi_1.1.5    
[28] compiler_3.4.0    backports_1.1.0   scales_0.4.1     
[31] prettyunits_1.0.2 jsonlite_1.5     
```
