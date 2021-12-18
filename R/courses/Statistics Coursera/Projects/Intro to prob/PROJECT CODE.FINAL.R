#set up
library(dplyr)

#load data
setwd("C:/Users/cpark/OneDrive/Documents")
load("brfss2013.RData")

#filter data to be 2013, all USA states
brfss2013 <- brfss2013 %>% filter(as.numeric(X_state) < 53 & as.numeric(X_state) > 1 & iyear == "2013") 

str(brfss2013)
unique(brfss2013$X_age_g)

#analysis by month
q1 <- brfss2013 %>% select(physhlth, menthlth, fmonth, X_state, X_age_g)
q1 <- na.omit(q1)
rm(brfss2013)


q1 <- q1 %>% mutate(ph.band = ifelse(physhlth == 0, 0, 
                                   ifelse((physhlth > 0 & physhlth < 11), "1-10", 
                                          ifelse((physhlth > 10 & physhlth < 21), "11-20", "21-30"))))
q1 <- q1 %>% mutate(me.band = ifelse(menthlth == 0, 0, 
                                   ifelse((menthlth > 0 & menthlth < 11), "1-10", 
                                          ifelse((menthlth > 10 & menthlth < 21), "11-20", "21-30"))))
c1 <- q1 %>% group_by(fmonth, X_age_g) %>% summarise(mean.p = mean(physhlth), mean.m = mean(menthlth))
c1 <- c1 %>% filter(X_state == "Colorado")
str(c1)
ggplot(data=c1, aes(x=fmonth)) + geom_point(aes(y=mean.p)) + geom_point(aes(y=mean.m))+ ylim(0,6) + facet_grid(X_age_g~.)
#represent data for all states, then for 4-5 different states to show there is not a pattern for all states - can I figure out a pattern?
#best way of showing results for multiple states - run a piece of code that prints out the graphs for all states
#look at demographics - interesting differences by age - filter everything by max, min, standard devaiation - could do a box plot by age for mental and physical

q1 %>% summarise(mean.p = mean(physhlth), sd.p = sd(physhlth), mean.m = mean(menthlth), sd.m = sd(menthlth))
c2 <- q1 %>% group_by(physhlth) %>% summarise(n()*100/ nrow(q1))
c3 <- q1 %>% group_by(menthlth) %>% summarise(n()*100/ nrow(q1))
group_by(q1, ph.band)
unique(q1$ph.band)
str(q1)

q3 <- q1 %>% mutate(overlap = (physhlth == 0 & menthlth == 0))
q3 <- q1 %>% mutate(p.1 = (physhlth != 0)*1, m.1 = (menthlth !=0)*1, o = p.1 + m.1)
q3 %>% group_by(m.1, o) %>% summarise(n()*100/ nrow(q3))

?mutate


#at least 1 mental health
#at least 1 physical health
#might want to cut off 30 days because that's people who are likely suffering from a long term problem
