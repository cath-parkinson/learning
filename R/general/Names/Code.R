library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)

setwd("C:/Users/Catherine/OneDrive/Documents")
data.2017 <- read_xls("C:/Users/Catherine/OneDrive/Documents/R/Practice/Names/2017girlsnames.xls", 
         sheet = "Table 6",
         skip = 5)

data.2017 <- data.2017[ ,1:3]
names(data.2017) <- c("Rank", "Name", "2017")

data.1996 <- read_xls("C:/Users/Catherine/OneDrive/Documents/R/Practice/Names/1996girlsnames.xls", 
                      sheet = 4,
                      skip = 6,
                      col_names = c("Rank", "Name", "1996"))

data.2006 <- read_xls("C:/Users/Catherine/OneDrive/Documents/R/Practice/Names/2006girlsnames.xls", 
                      sheet = 7,
                      skip = 6,
                      col_names = c("Rank", "Name", "2006"))

list <- list(data.1996 = data.1996, data.2006 = data.2006, data.2017 = data.2017)
list <- lapply(list, na.omit)

data <- left_join(data.1996[, 2:3], data.2006[,2:3], by = "Name")
data <- left_join(data, data.2017[,2:3], by = "Name")

apply(data[,2:4], 2, sum, na.rm = TRUE)
colnames(data) <- c("Name", "d.1996", "d.2006", "d.2017")
data <- data %>% mutate(Total = d.1996 + d.2006 + d.2017)
data <- data %>% arrange(desc(Total))

long.data <- gather(data[,1:4], key = "Year", value = "Count", 2:4)
ggplot(long.data, aes(y = Count, x= Year)) + geom_boxplot()
ggplot(long.data, aes(y = Count, x= Year)) + geom_bar(stat="identity")
ggplot(long.data, aes(y = Count, x= Name)) + geom_bar(stat="identity")+ facet_grid(.~Year)

ggplot(long.data, aes(y = Count, x= Year)) + geom_bar(stat="identity") + facet_grid(.~Name)
ggplot(long.data, aes(y = Count, x= Year)) + geom_bar(stat="Name")



