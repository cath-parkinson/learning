#importing data
#method 1 - select file manually
#this opens a dialog box where you can choose which file to select
stats <- read.csv(file.choose())

#method 2 - set the working directory and read data from there
#the working directory is where by default r studio goes to to save files, open files etc.
getwd() #what is my wd?
setwd("C:/Users/cpark/OneDrive/Documents/R") #set your wd
rm(stats) #remove an object
stats <- read.csv("DemographicData.CSV")

#exploring data
stats
nrow(stats) #count the number of rows
ncol(stats) #count the number of columns
head(stats) #gives you the top 5 rows - helpful to start to look at the data
tail(stats, n=20) #bottom 6 rows is the default, or you can specify
str(stats) #structure! the type of variable contained in each column in the data frame
?factor #a type of variable that often contains categorical data (it assigns numbers to the different levels e.g. "High income" is assigned a 1)
?runif #"random", and "distirbution" - it generates random deiviates (it does do a "run if this"!)
summary(stats) #very useful to give you mins, means, quartiles! in 1 handy table

#using the dollar sign
head(stats)
#many ways if selecting the same data point - the birthrate of Angola
stats[3, 3]
stats[3, "Birth.rate"]
stats[Angola, "Birth.rate"] #you can't do this! Becuase the rows do NOT have names, only the columns have names!
stats$Birth.rate[3]
levels(stats$Income.Group) #tells you all the different factors in a column

#basic operations with a data frame
#subsetting
stats[1:10,3:4]
stats[c(4:100),] #NB. this preserves the structure of the data set
stats[1,] #remember when we subsetted a matrix, and selected 1 row, it turned it into a vector(and it lost the information) - this doesn't happen when we subset a data frame!
is.data.frame(stats[1,]) #it is! no need to "drop=F"
stats[,1] #however when you extract a column, it becomes a vector!
is.data.frame(stats[,1]) #it is not! 
is.data.frame(stats[,1,drop=F])#so it you want to preserve it as a data frame you need to say drop=F

#mathematical operations
head(stats, n=10)
stats$Birth.rate * stats$Internet.users
stats$Birth.rate / stats$Internet.users
stats$Birth.rate + stats$Internet.users

#add a column
stats$MyCalc <- stats$Birth.rate * stats$Internet.users
stats$xyy <- 1:5 #it will recycle the vector, because the vector is too short. But it must be a multiple of 5! Becuase the data set is size 195
#remove a column
stats$MyCalc <- NULL
stats$xyy <- NULL

#filtering a data frame
stats[1:50,] #by rown number
filter <- stats$Internet.users < 2 #by 1 condition
stats[filter,] #this will only display the rows where filter is equal to TRUE
nrow(stats[stats$Birth.rate > 40 & stats$Internet.users < 2, ]) #counts the number of users with internet over 40
stats[stats$Income.Group == "High income", ] #by categorical
stats[stats$Country.Name == "Malta", ]

