library(pdftools)
library(dplyr)
library(googlesheets)
library(tidyverse)

# setwd("C:/Users/cpark/OneDrive/Documents/R/General")
setwd("C:/Users/Catherine/OneDrive/Documents/R/General")
source("myPDFmaker.R")

# run code --------------------------------


# setwd("C:/Users/cpark/OneDrive/Documents")
setwd("C:/Users/Catherine/OneDrive/Documents")
file1 <- "K8 document Estimate-42960803.pdf"
file2 <- "K8 document Estimate-42960804.pdf"

myfiles <- c(file1, file2)

# run function
df <- pdf_to_table(myfiles)

# analysis  ------------------------------------------

df %>% group_by(id) %>% summarise(total = sum(cost))
summary <- df %>% group_by(id, description) %>% 
  summarise(total = sum(cost)) %>% 
  arrange(description) %>% 
  pivot_wider(names_from = id, values_from = total) %>% 
  mutate(comparison = `1` == `2`) %>% 
  mutate(comparison = if_else(is.na(comparison), FALSE, comparison)) %>% 
  filter(comparison == FALSE) %>% 
  arrange(`2`)

# write to disc -----------------------
# write.csv(df, "HOWDENS_table.csv")


