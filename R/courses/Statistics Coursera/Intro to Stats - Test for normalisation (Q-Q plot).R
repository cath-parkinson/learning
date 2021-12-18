#create a Q-Q plot

#check which of these I should be using?! I get an error message at the moment
library(plyr)
library(dplyr)
library(ggplot2)

#create a normalised data set of SAT scores! mean = 1500, sd = 300
normaldata <- rnorm(100,1500,300)
normaldata.frame <- data.frame(normaldata)
ggplot(normaldata.frame, aes(x=normaldata)) + geom_histogram(binwidth = 40)

#standardising the scores, and add it to the data frame
#z = (value - mean)/sd
normaldata.frame <- normaldata.frame %>% mutate(standscore = ((normaldata.frame$normaldata-1500)/300))

#check the equation has worked!
#in which row is the highest value of zscore?
which.max(normaldata.frame$standscore)
#what is the highest value of the zscore?
max(normaldata.frame$standscore)
normaldata.frame$standscore[48]
#and which normal score does that correspond to?
normaldata.frame[48,"normaldata"]
normaldata.frame$normaldata[48]
#what is the percentile associated with the highest SAT score?
pnorm(2122.107,1500,300)
#and what is the z-score associated with it (to check it matches the highest z-score we have in our data set!)
qnorm(0.9809459,0,1)

#then add the corresponding percentile into the data frame
normaldata.frame <- normaldata.frame %>% mutate(percentile=pnorm(normaldata.frame$normaldata,mean(normaldata.frame$normaldata), sd(normaldata.frame$normaldata)))
#check percentile is working!
normaldata.frame[1,1]
mean(normaldata.frame$normaldata)
sd(normaldata.frame$normaldata)
pnorm(normaldata.frame[1,1],mean(normaldata.frame$normaldata),sd(normaldata.frame$normaldata) )
pnorm(1426.813,mean(normaldata.frame$normaldata),sd(normaldata.frame$normaldata))

#finally add in the exact z-scores to the data frame
#why won't this order my data!!!
normaldata.frame <- normaldata.frame %>% arrange(order(normaldata.frame$normaldata))
order(normaldata.frame$normaldata)
typeof(normaldata.frame$normaldata)
rm(normaldata)
normaldata.frame <- normaldata.frame %>% mutate(zscore = sort(rnorm(100)))

#plot the 2 variables against each other - with normal data on the y axis, and zscore on the x axis
#you can see they are exactly on the line 
ggplot(normaldata.frame, aes(x=zscore, y=standscore)) + geom_point()
qqnorm(normaldata.frame$normaldata)
qqline(normaldata.frame$normaldata)
#but when you plot against the percentile, they are not the line at the ends!
ggplot(normaldata.frame, aes(x=percentile, y=normaldata)) + geom_point()
?ChickWeight

#compare this to some data of chick weight!
data("ChickWeight")
mean(ChickWeight$weight)
IQR(ChickWeight$weight)
which.max(ChickWeight$weight)
min(ChickWeight$weight)
sd(ChickWeight$weight)
#produces a histogram with a strong right skew!
ggplot(ChickWeight, aes(x=weight)) + geom_histogram(binwidth = 5)
#standardise the chicken weight scores, and add that to the data set
ChickWeight <- ChickWeight %>% mutate(standscore = ((ChickWeight$weight-mean(ChickWeight$weight))/sd(ChickWeight$weight)))
#order your data set from low to high
ChickWeight <- ChickWeight %>% arrange(desc(-ChickWeight$weight))
ChickWeight <- ChickWeight %>% arrange(sort(ChickWeight$weight))
ChickWeight <- ChickWeight %>% arrange(order(ChickWeight$standscore))
order(as.numeric(ChickWeight$weight))
sort(ChickWeight$weight)
ChickWeight
?as.numeric
#calculate the exact z-scores that correspond to the quantiles in your data (the normalised equivalent version)
#create the quantiles (use q=579)
n <- 579
ChickWeight <- ChickWeight %>% mutate(zscore = qnorm(seq(from = 1/n, by = 1/n, length.out = (n-1))))

#remove a column from the data frame
ChickWeight$`zscore <- qnorm(seq(from = 1/n, by = 1/n, length.out = (n - 1)))` <- NULL
#calculate the corresponding percentiles and add to the data set
ChickWeight <- ChickWeight %>% mutate(percentile=pnorm(ChickWeight$weight,mean(ChickWeight$weight), sd(ChickWeight$weight)))

#Q-Q plot - plot the 2 variables against each other - you can see the data bends up and to the left of the line - consistent with what you'd expect from data with a right skew!
#this shows the data bending up and to the left of the straight line
ggplot(ChickWeight, aes(x=zscore, y=standscore)) + geom_point() + geom_smooth(method=lm)
ggplot(ChickWeight, aes(x=zscore, y=weight)) + geom_point() + geom_smooth(method=lm)
#P-P plot - this plots the percentiles against the 
ggplot(ChickWeight, aes(x=percentile, y=weight)) + geom_point() + geom_smooth(method=lm)
?geom_smooth#work out how to use a line of best of fit!!! Y = MX + C - do I need to calculate M and C and then put in the formula?
?rnorm()
?qqnorm

#R can also automatically produce a Q-Q plot
qqnorm(ChickWeight$weight)
qqline(ChickWeight$weight)
