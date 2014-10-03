
## ----one time setup, eval=FALSE------------------------------------------
## ### To install the bigrquery package
## install.packages("devtools")
## devtools::install_github("hadley/bigrquery")


## ----initialize----------------------------------------------------------
library(bigrquery)
library(ggplot2)
library(xtable)


## ------------------------------------------------------------------------
project <- "genomics-public-data"                           # put your projectID here
table <- "genomics-public-data:platinum_genomes.variants" # put your table here
DisplayAndDispatchQuery <- function(queryUri) {
  # Read in the SQL from a file or URL.
  querySql <- readChar(queryUri, nchars=1e6)
  # Find and replace the table name placeholder with our table name.
  querySql <- sub("_THE_TABLE_", table, querySql, fixed=TRUE)
  # Display the updated SQL.
  cat(querySql)
  # Dispatch the query to BigQuery for execution.
  query_exec(querySql, project)
}


## ----comment=NA----------------------------------------------------------
result <- DisplayAndDispatchQuery("../sql/sample-variant-counts-for-brca1.sql")


## ----result, comment=NA--------------------------------------------------
head(result)
summary(result)
str(result)


## ----viz, fig.align="center", fig.width=10-------------------------------
ggplot(result, aes(x=call_set_name, y=variant_count)) +
  geom_bar(stat="identity") + coord_flip() +
  ggtitle("Count of Variants Per Sample")


## ----comment=NA----------------------------------------------------------
result <- DisplayAndDispatchQuery("../sql/variant-level-data-for-brca1.sql")


## ----echo=FALSE, message=FALSE, warning=FALSE, comment=NA, results="asis"----
print(xtable(head(result)), type="html", include.rownames=F)


## ----comment=NA----------------------------------------------------------
result <- DisplayAndDispatchQuery("../sql/sample-level-data-for-brca1.sql")


## ----echo=FALSE, message=FALSE, warning=FALSE, comment=NA, results="asis"----
print(xtable(head(result)), type="html", include.rownames=F)


## ----provenance, comment=NA----------------------------------------------
sessionInfo()

