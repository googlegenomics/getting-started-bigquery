# Copyright 2014 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# For more information see https://github.com/hadley/bigrquery
library(bigrquery)

# Provide a table if you want to query your own data
DisplayAndDispatchQuery <- function(project, queryUri,
    table="genomics-public-data.platinum_genomes.variants") {
  # Read in the SQL from a file or URL.
  querySql <- readChar(queryUri, nchars=1e6)
  # Find and replace the table name placeholder with the table name.
  querySql <- sub("@THE_TABLE", table, querySql, fixed=TRUE)
  # Display the updated SQL.
  cat(querySql)
  # Dispatch the query to BigQuery for execution.
  query_exec(querySql, project, useLegacySql = FALSE)
}

GettingStarted <- function(project) {
  result <- DisplayAndDispatchQuery(project, "../sql/record-and-call-counts-by-reference.sql")

  cat("\nSummary:\n")
  print(summary(result))

  cat("\nResult:\n")
  print(result)
}
