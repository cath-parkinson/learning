#homework 3! in section 5
library(ggplot2)

#read and explore data
hw.data <- read.csv(file.choose())
head(hw.data)
levels(hw.data$Country.Name)
unique(hw.data$Year)
summary(hw.data)
hw.data[hw.data$Country.Name == "Sweden",]

hw.data$Country.Code == Country_Code
187*2

#rename vectors so they are more managable 
LifeExpectancy.1960 <- Life_Expectancy_At_Birth_1960
rm(Life_Expectancy_At_Birth_1960)
LifeExpectancy.2013 <- Life_Expectancy_At_Birth_2013
rm(Life_Expectancy_At_Birth_2013)
#is there a way to take these vectors and put them straight into the data frame??

#combine into vectors that are same length as our data frame
#create a year vector as well! so you can use this in your merge function
Country_Code_374 <- c(Country_Code, Country_Code)
LifeExpectancy_374 <- c(LifeExpectancy.1960, LifeExpectancy.2013)
Year <- rep(c("1960", "2013"), each= 187)

#so first we need to create a new data frame out of the vectors we have
#data frame of 374 rows
?data.frame
hw.data.LE <- data.frame(Country.Code = Country_Code, Life.Expectancy = LifeExpectancy_374, Year = Year)

#data frame of 187 rows
hw.data.LE.187 <- data.frame(Country.Code = Country_Code, LifeExpectancy.1960 = LifeExpectancy.1960, LifeExpectancy.2013 = LifeExpectancy.2013)

#then we need to merge in the data
#but the data is not stored as the same type!
is.character(hw.data$Country.Code)
is.factor(hw.data$Country.Code)
is.factor(hw.data.LE$Country.Code)
#make sure the data in country code is stored as a vector!
Country_Code_374 <- factor(Country_Code_374)
str(hw.data)
hw.data.LE$Country.Code == hw.data$Country.Code

#merge - this creates a 748 sized data frame!
merge.hw.data <- merge(hw.data, hw.data.LE.374, by.x = c("Country.Code", "Year"), by.y = c("Country.Code", "Year"))
head(hw.data.LE.374)
?merge

#merge - this creates a data set of the right size - by merging based on 2 variables!
merge.hw.data <- merge(hw.data, hw.data.LE, by.x = c("Country.Code", "Year"), by.y = c("Country.Code", "Year"))
head(hw.data.LE)
head(hw.data)
?merge

#merge - this creates a data frame with 2 columns for life expectancy
#so it's like you start with data frame x
merge.hw.data.2 <- merge(hw.data, hw.data.LE.187, by.x = "Country.Code", by.y = "Country.Code")

merge.hw.data.2$Life.Expectancy[filter, ] <- LifeExpectancy.1960

#this creates a filtered data set - not needed!
filter <- merge.hw.data.2[merge.hw.data.2$Year == "1960", ]  
#this creates a filter
filter <- merge.hw.data.2$Year == "1960"

merge.hw.data.2$Life.Expectancy <- merge.hw.data.2$LifeExpectancy.1960*filter
merge.hw.data.2$Life.Expectancy <- merge.hw.data.2$LifeExpectancy.2013*(filter == F)

merge.hw.data.2$Life.Expectancy[merge.hw.data.2$Year == "1960", ] <- merge.hw.data.2$LifeExpectancy.1960
merge.hw.data.2$Life.Expectancy <- merge.hw.data.2$LifeExpectancy.2013*(filter == F)

t <- filter == F
t

#we can now work with our final data set
#first check that the data lines up correctly
head(merge.hw.data)
head(hw.data)
hw.data[hw.data$Country.Name == "Aruba", ]
merge.hw.data[merge.hw.data$Country.Name == "Aruba", ]

#it's also useful to ensure your categorical variables are stored as factors! Rather than numerics
str(data.1960)
data.1960$Year <- factor(data.1960$Year)
merge.hw.data$Year <- factor(merge.hw.data$Year)

#life expectancy on y axis vs. fertility rate on x axis - categories by the countries' regions
#one chart for 1960, one for 2013
#why doesn't this work?!
qplot(data = merge.hw.data[merge.data.frame$Year == "1960", ], x = Fertility.Rate, y = Life.Expectancy, colour = Region)

#creating the filtered data set does however work!
data.1960 <- merge.hw.data[merge.hw.data$Year == "1960", ]  
qplot(data = data.1960, x = Fertility.Rate, y = Life.Expectancy, colour = Region, main = "Life Expectancy by Fertility rate - 1960")
data.2013 <- merge.hw.data[merge.hw.data$Year == "2013", ]
qplot(data = data.2013, x = Fertility.Rate, y = Life.Expectancy, colour = Region, main = "Life Expectancy by Fertility rate - 2013")
?qplot

qplot(data=merge.hw.data, x=Year, y= Life.Expectancy, colour = Region)
qplot(data=merge.hw.data, x=Year, y= Fertility.Rate, colour = Region)
summary(data.1960)
summary(data.2013)

summary(data.1960[data.1960$Region == "Africa", ])
summary(data.2013[data.2013$Region == "Africa", ])
summary(data.1960[data.1960$Region == "Europe", ])
summary(data.2013[data.2013$Region == "Europe", ])


#insights
#European countries have the lowest fertility rate and the highest life expectancy
#While African countries tend to have a higher fertility rate, and typically lower life expectancy

#For all countries - life expectancy has improved from 1960 to 2013, and fertility rate has declined
#However the shift is more apparent in Middle East and Asia, compared with Africa

#In 1960, while all African countries have a high fertility rate, life expectancy is very variable - suggesting other factors play a role in life expectancy of different countries - war, famine??
#However in 2013 LE and FR appear more connected, as life expectancy decreases, fertility rate increases - they seem to be inversely proportional 
