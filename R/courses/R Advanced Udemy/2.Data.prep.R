library(dplyr)
library(tidyr)

# Data exploration
# When you load data, R assigns types to the different variables e.g. decides if it's numerical, categorical etc.
# Note! This might not always be how you want it to be, and can cause problems

setwd("C:/Users/Catherine/OneDrive/Documents/R/R Advanced Udemy/Data")
#setwd("C:/Users/cpark/OneDrive/Documents/R/R Advanced Udemy/Data")
# data <- read.csv("P3-Future-500-The-Dataset.csv")
data <- read.csv("P3-Future-500-The-Dataset.csv", na.strings = c(""))
str(data)
head(data)
tail(data, 10)
summary(data)
levels(data$Industry)

# Factor is a categorial variable 
# It also has numerical identifiers - this is how it deals with categorical variables!
# Change integer into factors
data$Inception <- as.factor(data$Inception)
data$ID <- factor(data$ID)

# Change into other variables

#a <- c("12", "13", "14", "12", "12")
#b <- as.numeric(a)

# Factor Variable Trap
# If you try to turn a factor into a numeric, it takes the FACTOR LEVELS, not the originals!
# a <- as.factor(c("12", "13", "14", "12", "12"))
# v <- as.numeric(a)
# # Even though it says it's stored as an integer! 
# typeof(a)
# 
# # So instead you need to convert it into a character FIRST, then convert into a numeric!
# v <- as.character(a)
# v <- as.numeric(v)
# typeof(v)

# Example using data set
data$Profit <- as.factor(data$Profit)
str(data)

data$Profit <- as.character(data$Profit)
data$Profit <- as.numeric(data$Profit)

# Replaces all instances
# NB. sub replaces just the one instance
gsub(",", "", data$Revenue)
data$Expenses <- gsub(" Dollars", "", data$Expenses)
data$Expenses <- gsub(",", "", data$Expenses)
data$Expenses <- as.numeric(data$Expenses)

# However! $ is a special character in r, so it won't work. 
# Therefore you need to "create an escape sequence"
data$Revenue <- gsub(",", "", data$Revenue)
data$Revenue <- gsub("\\$", "", data$Revenue)
data$Revenue <- as.numeric(data$Revenue)

data$Growth <- gsub("%", "", data$Growth)
data$Growth <- as.numeric(data$Growth)
data$Growth <- data$Growth/100

# show all the rows that have at least 1 NA, using a logical operator
#data[complete.cases(data) == F, ]
data[!complete.cases(data), ]

# But NAs will still appear when you use boulions to filter your data set
data[data$Revenue == 9746272, ]

# Which tells you which bits of the logical vector are TRUE, and returns the original values
# We can now use this in our filter - essentially it ignores the NAs
data[which(data$Revenue == 9746272), ]
data[which(data$Employees == 45), ]

# show rows that have NAs in the expenses column
data[is.na(data$Expenses), ]

# Remove rows NAs, when NAs in a certain column
backup <- data
data[!complete.cases(data), ]
data[!is.na(data$Industry), ]
data <- data[!is.na(data$Industry), ]

#na.omit(data)

# You might then want to reset the data frame index
# If you delete rows, R retains the the same indices (unlike excel! where they would change)
# If you WANT to reset them then you can

length(rownames(data))
rownames(data) <- seq(1,498,1)
rownames(data) <- 1:498
rownames(data) <- NULL

# imputing values - two ways of doing the same thing!
# data[is.na(data$State), ][ data[is.na(data$State), ]$City == "New York", ]$State <- "NY"
# data[is.na(data$State), ][ data[is.na(data$State), ]$City == "San Francisco", ]$State <- "CA"
data[is.na(data$State) & data$City == "New York", "State"] <- "NY" 
data[is.na(data$State) & data$City == "San Francisco", "State"] <- "CA" 


#impute the median response 
median(data[data$Industry == "Retail", "Employees"], na.rm = T)
employees.median <- data[!is.na(data$Employees), ] %>% group_by(Industry) %>% summarise(median = median(Employees))

data[is.na(data$Employees) & data$Industry == "Retail", "Employees"] <- employees.median[employees.median$Industry == "Retail", ][2]
data[is.na(data$Employees) & data$Industry == "Financial Services", "Employees"] <- employees.median[employees.median$Industry == "Financial Services", ][2]

#show all NAs in the growth column
data[is.na(data$Growth) , "Growth"]

#use median of number of employees 

# data[!is.na(data$Growth), ] %>% mutate(E.bands = ifelse(Employees <= 28, 1, 
#                                  ifelse(between(Employees, 29, 56), 2, 
#                                         ifelse(between(Employees, 57, 126), 3, 4)))) %>%
#   group_by(E.bands) %>% summarise(median = median(Growth))

growth.median <- data[!is.na(data$Growth), ] %>% group_by(Industry) %>% summarise(median = median(Growth))
data[is.na(data$Growth) & data$Industry =="Construction", "Growth"] <- growth.median[growth.median$Industry == "Construction", "median"]

rev.median <- data[!is.na(data$Revenue), ] %>% group_by(Industry) %>% summarise(median = median(Revenue))
data[is.na(data$Revenue) & data$Industry == "Construction", "Revenue"] <- rev.median[rev.median$Industry == "Construction", "median"]

data[is.na(data$Expenses) & data$Industry == "Construction", ]
exp.median <- data[!is.na(data$Expenses), ] %>% group_by(Industry) %>% summarise(median = median(Expenses))
data[is.na(data$Expenses) & data$Industry == "Construction", "Expenses"] <- exp.median[exp.median$Industry == "Construction", "median"]

#ensure that profit is also missing! Use this to stack conditions for subsetting
data[!complete.cases(data) & is.na(data$Profit),]
data[!complete.cases(data),]

# Final remaining NAs using formulas
data[data$ID == 17, "Expenses"] <- data[data$ID == 17, "Revenue"] - data[data$ID == 17, "Profit"]

data[(data$ID == 8 | data$ID == 44), "Profit"] <- data[(data$ID == 8 | data$ID == 44), "Revenue"] - data[(data$ID == 8 | data$ID == 44), "Expenses"]
data[(data$ID == 8 | data$ID == 44), ] 

fin <- data




