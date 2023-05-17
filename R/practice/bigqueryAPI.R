#install.packages("bigrquery")
library(bigrquery)
library(tidyverse)
library(lubridate)
projectid = "essence-looker-exports-itv"
sql <- "SELECT * FROM `essence-looker-exports-itv.dbt_prod.__cross_channel__base_table` LIMIT 10"
tb <- bq_project_query(projectid, sql)
# Store the first 10 rows of the data in a tibble
sample <-bq_table_download(tb, n_max = 10)
# Print the 10 rows of data
sample