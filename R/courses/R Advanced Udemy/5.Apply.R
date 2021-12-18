library(dplyr)
library(tidyr)
library(ggplot2)

setwd("C:/Users/Catherine/OneDrive/Documents/R/R Advanced Udemy/Data")
#setwd("C:/Users/cpark/OneDrive/Documents/R/R Advanced Udemy/Data")

#quicker way of accessing the folder you need (as long as your working directory is already set)
#the "." means "the folder you already in"
setwd("./P3-Weather-Data/Weather Data")

# use "row.names" to ensure that the first column is your data (not the row names)
# make it a matrix, because all our data is numeric
Chicago <- read.csv("Chicago-C.csv", row.names = 1)
Chicago <- as.matrix(Chicago)
Houston <- read.csv("Houston-C.csv", row.names = 1)
Houston <- as.matrix(Houston)
NewYork <- read.csv("NewYork-C.csv", row.names = 1)
NewYork <- as.matrix(NewYork)
SanFrancisco <- read.csv("SanFrancisco-C.csv", row.names = 1)
SanFrancisco <- as.matrix(SanFrancisco)

list <- list(Chicago = Chicago,Houston = Houston,NewYork = NewYork,SanFrancisco = SanFrancisco)

# we should be able to read in all the files in one go using apply!
# and we can filter by celcius not farrenhiet, using grepl!
files <- list.files(path = "./P3-Weather-Data/Weather Data")
list <- lapply(files[!grepl("-F", files)], read.csv)

# understanding "apply"
# X - matrix you're interested in
# MARGIN - (1) rows or (2) columns
# FUN - the function you want to apply to your matrix
# ... additional arguments you might need in your function

# Find all the row averages
apply(Chicago, 1, max)
apply(Chicago, 2, max)
apply(Chicago, 1, min)

# But there is a faster way using lapply below!
apply(Chicago, 1, mean)
apply(Houston, 1, mean)
apply(NewYork, 1, mean)
apply(SanFrancisco, 1, mean)

# Explore finding the mean of every row using a loop
output <- NULL
for (i in 1:5){
  output[i] <- mean(Chicago[i,])
}
names(output) <- rownames(Chicago)

# Same thing, but using apply
output.2 <- apply(Chicago,1,mean)

# Using lapply to transpose all of the matrices in the list
lapply(list, t)

# You can then pass other arguments in "optional arguments to FUN
lapply(list, rbind, Another.row=1:12)
lapply(list, rowMeans)

list$Chicago[1,1]

# Combine lapply with [[]] to get out elements of the list
lapply(list, "[" ,1,1)
lapply(list, "[", 1, )
lapply(list, "[", "AvgHigh_C", )
lapply(list, "[", , "Mar")
lapply(list, "[", , 3)
lapply(list, "[", , 3:4)
lapply(list, "[", , c("Mar", "Apr"))

# Adding your own functions is especially powerful
# You have to type "function" and then say how many arguments it wil have
# With apply, you always need one argument - because that is what the apply is iterating over
# Then you put the description of the function immediately after  
lapply(list, function(x) x[1,])
lapply(list, function(x) x[,12])
lapply(list, function(x) x[1,]-x[2,])
lapply(list, function(x) round((x[1,]-x[2,])/x[2,], 2))

# sapply is simplifiying the output from lapply
# It's clever! It can put infomation back into a user friendly way (that isn't a list!)
sapply(list, "[", "AvgHigh_C", )
sapply(list, "[", 1,7 )
sapply(list, function(x) round((x[1,]-x[2,])/x[2,], 2))
sapply(list, "[", 1,10:12)

# Use sapply to get all the information into one matrix
round(sapply(list, rowMeans),2)

# Nest apply functions within apply functions
# you add the apply as the function, and then "1" and "max" as optional parameters
lapply(list, apply, 1, max) #preferred approach
lapply(list, function(x) apply(x,1,max)) #this does the same thing
sapply(list, apply, 1, max) #just tidys this up

#which.max
#multiple levels to this 
# need to go over 1 row in matrix, then all rows in matrix, then all rows in all data frames
#which month has the maximum temp
s <- which.max(Chicago[1,])
names(which.max(Chicago[1,]))

#which month has the maximum for temp, precip, sunshine etc. (all rows)
apply(Chicago, 1, which.max)
apply(Chicago, 1, names)

#use apply to go over all rows of the matrix - you need to use the function syntax to do this
apply(Chicago, 1, function(x) names(which.max(x)))

#use lapply to go over all the data frames
lapply(list, apply, 1, function(x) names(which.max(x))) #preferred 
sapply(list, apply, 1, function(x) names(which.max(x)))

lapply(list, function(y) apply(y, 1 , function(x) names(which.max(x)))) #but you can also add y as a function too
sapply(list, function(y) apply(y, 1 , function(x) names(which.max(x)))) 





