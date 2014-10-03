getting-started-bigquery
========================

The repository contains examples of how to use BigQuery with genomics data. The code within each language-specific folder demonstrates the same set of queries upon the Platinum Genomes dataset.  For more detail about this data see [Google Genomics Public Data](https://developers.google.com/genomics/datasets/platinum-genomes).

Getting Started
-------------------------------------

1. [Sign up for BigQuery](https://developers.google.com/bigquery/sign-up).
1. Go to the BigQuery [Browser Tool](https://bigquery.cloud.google.com).
1. Click on **"Compose Query"**.
1. Copy and paste the following query into the dialog box and click on **"Run Query"**:
```
SELECT
  reference_name,
  COUNT(reference_name) AS num_records,
  COUNT(call.call_set_name) AS num_calls
FROM
  [genomics-public-data:platinum_genomes.variants]
GROUP BY
  reference_name
ORDER BY
  reference_name
```
View the results!

Google Genomics Public Data
-------------------------------------

To add the [Google Genomics Public Data](https://developers.google.com/genomics/datasets/platinum-genomes) datasets to your project so that they show up in the left-hand naviation pane.

  1. Click on the drop down icon beside your project name in the left navigation pane.
  1. Pick _‘Switch to project’_ in the menu, and _‘Display project...’_ in the submenu
  <img src="figure/display.png" title="Display project" alt="Display Project" style="display: block; margin: auto;" />
  1. Enter `genomics-public-data` in the _‘Add Project’_ dialog.
  <img src="figure/add.png" title="Add Project" alt="Add Project" style="display: block; margin: auto;" />
Now the [Google Genomics Public Data](https://developers.google.com/genomics/datasets/platinum-genomes) datasets appear in the left navigation pane of the BigQuery [Browser Tool](https://bigquery.cloud.google.com).

What next?
----------
  * New to BigQuery?
    + See the [query reference](https://developers.google.com/bigquery/query-reference).
  * New to working with variants?
    + See an overview of the [VCF data format](http://vcftools.sourceforge.net/VCF-poster.pdf).
  * Looking for more sample queries?
    + See [BigQuery Examples](https://github.com/googlegenomics/bigquery-examples).
