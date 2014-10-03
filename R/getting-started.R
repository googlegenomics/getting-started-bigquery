# For more information see https://github.com/hadley/bigrquery
library(bigrquery)

### To install the bigrquery package
# install.packages("devtools")
# devtools::install_github("hadley/bigrquery")

# Put your projectID here
project <- "genomics-public-data"

# Change the table if you want to query your own data
table <- "genomics-public-data:platinum_genomes.variants"

DisplayAndDispatchQuery <- function(queryUri) {
  # Read in the SQL from a file or URL.
  querySql <- readChar(queryUri, nchars=1e6)
  # Find and replace the table name placeholder with the table name.
  querySql <- sub("_THE_TABLE_", table, querySql, fixed=TRUE)
  # Display the updated SQL.
  cat(querySql)
  # Dispatch the query to BigQuery for execution.
  query_exec(querySql, project)
}

result <- DisplayAndDispatchQuery("../sql/record-and-call-counts-by-reference.sql")

summary(result)

result
