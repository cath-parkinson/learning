#install.packages("bigrquery")

library(bigrquery)
library(tidyverse)
library(lubridate)

# This does not work because Essence have not given me the required job role
projectid = "essence-looker-exports-itv"
sql <- "SELECT * FROM `essence-looker-exports-itv.dbt_prod.__cross_channel__base_table` LIMIT 10"
tb <- bq_project_query(projectid, sql)
# Store the first 10 rows of the data in a tibble
sample <-bq_table_download(tb, n_max = 10)
# Print the 10 rows of data
sample

# So instead I've now ran the query in the BigQuery console, amending the query first to directly 
# save it into a BigQuery dataset/query (the default is the temp table!)

# So now it lives in OUR GCP instance, I should be able to automatically pull in the data
projectid = "measuremonks-tools"
sql <- "SELECT * FROM `measuremonks-tools.test.all`"
# This returns a bq_table (an S3 type of R object)
tb <- bq_project_query(projectid, 
                       sql)

# We can then query this table and store the data as a tibble
sample <-bq_table_download(tb)



