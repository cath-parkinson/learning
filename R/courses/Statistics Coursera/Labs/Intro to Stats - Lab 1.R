#intro to r in statistics

#load data 
data("FILENAME")
#look at number of rows and columns 
dim("FILENAME")
#show data
arbuthnot
#type of data. NB. a list is like a vector, except different elements can be different data types
typeof("FILENAME")
#show 1 column of the data
arbuthnot$year
#show the names of the variables in the data frame (column headers!)
names(nycflights)
#to find more inforamtion on the dataset from r
?nycflights #(in the console)
#quick view of the data frame (and type of variables!) NB. nums are either integers or doubles or complexes
str(nycflights)
#type of 1 variable
typeof(nycflights$day)

#scatter plot
ggplot(data = arbuthnot, aes(x = year, y = girls)) #this first bit sets up the chart +
  geom_point() #this second bit is needed to plot the data as a scatter graph
  
+ geom_smooth(method = "lm", se = FALSE) #this adds a line of best fit! based on linear regression

#total of boys  
sum(arbuthnot$boys)
#total of girls
sum(arbuthnot$girls)
#total of boys and girls
sum(arbuthnot$boys,arbuthnot$girls)

#adding the total to your data set
arbuthnot <- arbuthnot %>% #this is the "pipes in" operator, so we're saying take the data set and pipe it into the following line of code
mutate(total = boys + girls) #this says, using this data set, "mutate"a new variable called "total", and that is created by the sum of boys and girls

#calculate range
range(present$year)
max(present$year)
min(present$year)

present <- present %>%
  + mutate(total = boys + girls)

#as above adding total
present <- present %>% mutate(total = boys + girls)
#as above adding difference
present <- present %>% mutate(difference = boys - girls)
#as above adding proportion that are boys
present <- present %>% mutate(prop_boys = boys / total)
#as above adding whether there are more boys or not
present <- present %>% mutate(more_boys = boys > girls)

present <- present %>% mutate(prop_boy_girls = boys / girls)

ggplot(data = present, aes(x=year, y=difference)) + geom_point()

#more_boys is a vector of T and F, where T is stored as 1 and F is stored as 0, so if we count it we get the number of trues - which is 74! Equally the total size of the data set (so it's all of them!)
sum(present$more_boys)
present$more_boys
min(present$prop_boys)

#final bit changes the scale of y-axis!
ggplot(data = present, aes(x=year, y=prop_boys)) + geom_point() + ylim(0.4, 0.6)

#how many rows in data set?
nrow(present)

#identify which year corresponds to the highest total
#with base r
which.max(present$total)
present$year[68]
present[68,"year"]
present[68,]

#with tidyverse
present <- present %>% arrange(desc(total))
