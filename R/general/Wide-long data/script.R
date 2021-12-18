#wide to long data
library(readxl)
library(dplyr)
library(tidyr)

setwd("C:/Users/Catherine/Documents/R/Wide-long data")
a <- read_excel("RatesDeaths_AllIndicators.xlsx", col_names = TRUE, skip = 6)
?read_excel()
str(a)
head(a)
dim(a)

#subset the data set to the median estimate (drop the upper and lower uncertainty bounds)
#rename the column (to avoid asterisks)
z <- colnames(a) == "Uncertainty bounds*"
colnames(a)[z] <- "Uncertainty.bounds"
#subset the data
b <- a %>% filter(Uncertainty.bounds == "Median")
#remove column (not needed)
y <- colnames(b) != "Uncertainty.bounds"
c <- b %>% select(colnames(b)[y])

#you can use group_by and summarise, or gather on it's own 
#d <- c %>% gather(country, year, type, value, )

#check that we have same combination of years for each metric
#get the last 4 digits of the colname (this is the year), and divide this by 3 for each metric
d <- colnames(c)
e <- nchar(d)
?nchar
?gather
?substr
f <- substr(d,nchar(d)-3,nchar(d))
g <- substr(d,nchar(d)-3,nchar(d))
h <- d[-1:-2]
i <- f[-1:-2]
j <- i[1:132]
k <- i[133:264]
l <- i[265:396]
#these sum to zero (all falses!), so we have the same years for each metric
sum(j != k)
sum(k != l)
rm(e,f,h,i,j,k,l)

#this doesn't work because we haven't specified which columns to use (to it defaults to everything)
m <- gather(c, year, rate)

#this doesn't work because we only focus on 1 variable
n <- gather(c,year, rate, U5MR.1950:U5MR.2015)
unique(n$year)
tail(n)

#this is better, but we still have type concealed in the year column
o <- gather(c,year,rate, -1:-2)
unique(o$year)

#we can use the separate function to split this up, but this doesn't keep all the info (drops the bits inbetween the multiple full stops)
p <- separate(o, year, c("type","year"))
unique(p$type)

#is there a better way to tidy this up?
q <- separate(o, year, c("type","year"), sep = ".", extra = "merge", fill = "right")
q <- separate(o, year, c("type1", "type2", "type3", "year"))
unique(q$type)  

#need to deal with multiple separators in this full stop, so could mutate a new variable
#which keeps the last full stop, but takes out the others, so the read as one line
#then we end up with only 1 fullstop to deal with

