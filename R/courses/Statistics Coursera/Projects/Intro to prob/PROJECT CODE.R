##BRFSS
#2013, US, phone interviews, 56 states plus Guam and Puerto Rico
#collected across the year, 
#consider excluding SA countries?
library(dplyr)
library(ggplot2)

#load data
setwd("C:/Users/cpark/OneDrive/Documents")
load("brfss2013.RData")

#explore data
str(brfss2013)
head(brfss2013)
colnames(brfss2013)

#1% of the data is 2014 
brfss2013 %>% group_by(iyear) %>% summarise(percent = n()*100/nrow(brfss2013))
brfss2013 %>% group_by(X_state) %>% summarise(percent = n()*100/nrow(brfss2013))
sort(unique(brfss2013$X_state))
typeof(brfss2013$X_state)
filter(brfss2013, X_state == 0 | X_state == 80)

#filter data 
brfss2013 <- brfss2013 %>% filter(as.numeric(X_state) < 53 & as.numeric(X_state) > 1 & iyear == "2013")
b <- a %>% group_by(X_state) %>% summarise(percent = n()*100/nrow(a))
a %>% group_by(iyear) %>% summarise(percent = n()*100/nrow(a))

#filter data by variables interested in
brfss2013 %>% group_by(genhlth) %>% summarise(c = n()*100/nrow(brfss2013))
a <- brfss2013 %>% group_by(physhlth) %>% summarise(c = n()*100/nrow(brfss2013))
b <- brfss2013 %>% group_by(menthlth) %>% summarise(c = n()*100/nrow(brfss2013))
c <- brfss2013 %>% select(physhlth, menthlth, fmonth, X_state)
d <- na.omit(c)

ggplot(data=d, aes(x=physhlth, y=menthlth)) + geom_count()
ggplot(data=d, aes(x=menthlth)) + geom_bar()
ggplot(data=d, aes(x=physhlth)) + geom_bar()
d <- d %>% mutate(ph.band = ifelse(physhlth == 0, 0, 
                                   ifelse((physhlth > 0 & physhlth < 11), "1-10", 
                                          ifelse((physhlth > 10 & physhlth < 21), "11-20", "21-30"))))
d <- d %>% mutate(me.band = ifelse(menthlth == 0, 0, 
                                   ifelse((menthlth > 0 & menthlth < 11), "1-10", 
                                          ifelse((menthlth > 10 & menthlth < 21), "11-20", "21-30"))))
ggplot(data=d, aes(x=ph.band, y=me.band)) + geom_count()

d %>% group_by(me.band) %>% summarise(c = n()*100/nrow(d))
d %>% summarise(mean.p = mean(physhlth), mean.m = mean(menthlth))
e <- d %>% group_by(fmonth) %>% summarise(mean.p = mean(physhlth), mean.m = mean(menthlth))

#how do I draw a line of best fit on these?
ggplot(data=e, aes(x=fmonth, y=mean.p)) + geom_point() + geom_smooth()
ggplot(data=e, aes(x=fmonth)) + geom_point(aes(y=mean.p)) + geom_point(aes(y=mean.m)) + ylim(0,5)


#how do I get the % here?!
f <- d %>% group_by(fmonth, ph.band) %>%  summarise(n = n())
y <- d %>% group_by(fmonth) %>% summarise(total=n())
z <- left_join(f, y, by = "fmonth")
z <- z %>% mutate(percent = round(n*100 / total))
ggplot(data=z, aes(x=fmonth, y=percent)) + geom_bar(stat="identity", aes(fill=ph.band))

f <- d %>% group_by(fmonth, physhlth) %>%  summarise(n = n())
y <- d %>% group_by(fmonth) %>% summarise(total=n())
z <- left_join(f, y, by = "fmonth")
z <- z %>% mutate(percent = round(n*100 / total)) 
z <- filter(z,physhlth < 10)
ggplot(data=z, aes(x=fmonth, y=percent)) + geom_bar(stat="identity", aes(fill=as.character(physhlth)))

#there seems to be a connection between time of year of survey and how healthy people are - but mainly for physical health
#look at this by state

d$X_state

j <- d %>% filter(X_state == "Maine")


e <- j %>% group_by(fmonth) %>% summarise(mean.p = mean(physhlth), mean.m = mean(menthlth))
j <- d %>% group_by(X_state, fmonth) %>% summarise(n = n()) %>% arrange(fmonth)

ggplot(data=e, aes(x=fmonth)) + geom_point(aes(y=mean.m)) #+ geom_point(aes(y=mean.m)) 


#need to remove everyone who says they have serious health problems, and focus on gen pop of heathly people?
ggplot(data=e, aes(x=fmonth)) + geom_point(aes(y=mean.p)) + geom_point(aes(y=mean.m)) 

#stacked chart per month 
g <- d %>% group_by(fmonth, ph.band) %>% summarise(n = n())  
ggplot(data=g, aes(x=fmonth, y=n)) + geom_bar(stat="identity", aes(fill=ph.band))

sort(as.character(f$physhlth))

#?as.character
?as.numeric




#data cleaning
#there are some uncomplete interviews "DISPCODE"
#interview is complete if respondents give age / gender / race (half way through survey)
#some questions are state specific - so will have complete data
#check for complete data!


#Interesting variables

#Demographics
#GHEALTH - self assessment of health (5 point scale)
#No of hours sleep, blood pressure, historic illnesses and mental health

#9.5 - smoking
#10 - alcohol consumption
#11 - F&V
#12 - physical activity 
#3.2 - how days depressed in last 30
#17.1 mental illness and stigma 

