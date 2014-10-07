# For more information see https://github.com/hadley/bigrquery
library(bigrquery)

# Provide a table if you want to query your own data
DisplayAndDispatchQuery <- function(project, queryUri,
    table="genomics-public-data:platinum_genomes.variants") {
  # Read in the SQL from a file or URL.
  querySql <- readChar(queryUri, nchars=1e6)
  # Find and replace the table name placeholder with the table name.
  querySql <- sub("_THE_TABLE_", table, querySql, fixed=TRUE)
  # Display the updated SQL.
  cat(querySql)
  # Dispatch the query to BigQuery for execution.
  query_exec(querySql, project)
}

GettingStarted <- function(project) {
  result <- DisplayAndDispatchQuery(project, "../sql/record-and-call-counts-by-reference.sql")

  cat("\nSummary:\n")
  print(summary(result))

  cat("\nResult:\n")
  print(result)
}
