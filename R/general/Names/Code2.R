library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)

#setwd("C:/Users/Catherine/OneDrive/Documents")
setwd("C:/Users/cpark/OneDrive/Documents/R/R Advanced Udemy/Data")

data <- read_xls("C:/Users/Catherine/OneDrive/Documents/R/Practice/Names/names1996to2016.xls", 
                      sheet = "Girls",
                      skip = 5)

#delete out all the rank columns - all even columns in 43 long set need to go
# use grpl is so much easier! 
data <- data[,!grepl("Rank", names(data))]

vector <- seq(2016, 1996, -1)

cat(paste(shQuote(vector, type = "cmd"), collapse = ", "))
names(data) <- c("Name", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000", "1999", "1998", "1997", "1996")

data <- gather(data, key = "Year", value = "Count", 2:22)
data <- arrange(data, Name, Year)

data$Count <- sub(":", 0, data$Count)
data$Count <- as.numeric(data$Count)

#Most popular ever
top10 <- data %>% group_by(Name) %>% summarise(n = sum(Count)) %>% arrange(-n) %>% top_n(10)

#Most popular in 2016
data %>% filter(Year == "2016") %>% group_by(Name) %>% summarise(n = sum(Count)) %>% arrange(-n)

#Most popular in 1996 
data %>% filter(Year == "1996") %>% group_by(Name) %>% summarise(n = sum(Count)) %>% arrange(-n)

#How have the top 10 changed over time
data[data$Name %in% top10$Name, ] 

?filter
