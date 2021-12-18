#set up
library(dplyr)
library(ggplot2)
library(tidyr)
library(knitr)

#load data
setwd("C:/Users/cpark/OneDrive/Documents")
load("brfss2013.RData")

#filter data to be 2013, all USA states
brfss2013 <- brfss2013 %>% filter(as.numeric(X_state) < 53 & as.numeric(X_state) > 1 & iyear == "2013") 

#get the variables I am going to need
brfss2013 <- brfss2013 %>% select(physhlth, menthlth, poorhlth, income2, sex, X_age_g)

#remove NAs (but not from poorhlth)
t <- complete.cases(brfss2013[ , -3])
brfss2013 <- brfss2013[t, ]
rm(t)

#question 1

#look at distribution of key variables
#similar right skew up to 10, with spikes at 10 , 20, 30 potentially down to how respondents answer the question
#vast majority of people have had a healthy 30 days
#with a long tail
#TD) find a nice way of showing these, side by side
#gather, with some facetting
ggplot(data=brfss2013, aes(x=physhlth)) + geom_histogram(bins= 30)
ggplot(data=brfss2013, aes(x=menthlth)) + geom_histogram(bins= 30)

C1 <- brfss2013 %>% select(physhlth, menthlth) %>% gather(health, Days)
labels <- c(physhlth = "Physically unwell", menthlth = "Mentally unwell")
C1$health <- factor(C1$health, levels = c("physhlth", "menthlth"))

ggplot(data=C1, aes(x=Days)) + geom_histogram(bins = 30) + 
  facet_grid(health~. , labeller = labeller(health = labels)) + 
  ggtitle("Number of days unwell (in the last 30)")


#key summary statistics 
#average is lower for mental health conditions

D1 <- brfss2013
colnames(D1)[1] <- "Physical"
colnames(D1)[2] <- "Mental"
F3 <- D1 %>% gather(Health, days, c(Physical, Mental)) %>% 
  select(Health, days)%>% group_by(Health) %>% 
  summarise(Mean = round(mean(days), 1), 'Standard deviation' = round(sd(days),1), IQR = IQR(days)) %>%
  arrange(desc(Mean))
kable(F3, caption = "Figure 3: Number of days unwell (statistics)", padding = 0)

#group into 3 bands
#use the cut function
brfss2013 <- brfss2013 %>% 
  mutate(ph.band = cut(physhlth, breaks = c(0,1,10,31), labels = c("0", "1-9", "10+"), right=FALSE)) %>% 
  mutate(me.band = cut(menthlth, breaks = c(0,1,10,31), labels = c("0", "1-9", "10+"), right=FALSE)) %>% 
  mutate(ph.band2 = cut(physhlth, breaks = c(0,1,31), labels = c("0", "1+"), right=FALSE)) %>% 
  mutate(me.band2 = cut(menthlth, breaks = c(0,1,31), labels = c("0", "1+"), right=FALSE))

#this is the stacked plot
#TD) make look nice 
F2 <- brfss2013 %>% gather(health, days, c(ph.band, me.band)) %>% 
  group_by(health, days) %>% 
  summarise(count=n(), Percentage = n()*100/nrow(brfss2013))
ggplot(data=F2, aes(x=days, y=Percentage, fill=factor(health))) + 
  geom_bar(stat = "identity", position = "dodge") + 
  xlab("Days unwell (grouped)")

typeof(F2$health)

F2 <- brfss2013 %>% gather(health, days, c(ph.band, me.band)) %>% 
  group_by(health, days) %>% 
  summarise(count=n(), Percentage = n()*100/nrow(brfss2013))
F2$health <- factor(F2$health, levels = c("ph.band", "me.band"))
ggplot(data=F2, aes(x=days, y=Percentage, fill=health)) + 
  geom_bar(stat = "identity", position = "dodge") + 
  ggtitle("Figure 2: Health of US population in last 30 days") +
  xlab("Days unwell (grouped)") +
  scale_fill_discrete(name = "Health", labels = c("Physcially", "Mentally"))

#question 2
#look at those with at least 1 men health day, and at least 1 physical day and look at the overlap, and also the impact on whether you haven't been able to do something

C2 <- brfss2013 %>% group_by(ph.band2, me.band2) %>% summarise(percent = round(n()*100 / nrow(brfss2013)), 1) %>% 
  mutate(combo = paste(ph.band2, me.band2))

fill <- c("#56B4E9", "#F0E442","#56B4E9", "#F0E442")

ggplot(data=C2, aes(y=percent, x="health", fill = combo)) + 
  geom_bar(stat = "identity") + coord_flip() + 
  scale_fill_discrete(name = "Key", labels = c("Zero days unwell", "At least 1 mental, no physical", "At least 1 physical, no mental", "At least 1 mental, and 1 physical")) + 
  theme(axis.ticks = element_blank(), axis.text.y = element_blank(), axis.title.y = element_blank()) + 
  ggtitle("Figure 4: Proportion who have had at least 1 day unwell (in last 30)")

ggplot(data=C2, aes(y=percent, x="health", fill = combo)) + 
  geom_bar(stat = "identity") + coord_flip() + 
  scale_fill_discrete(name = "Key", labels = c("Zero days unwell", "At least 1 mental, no physical", "At least 1 physical, no mental", "At least 1 mental, and 1 physical")) + 
  theme(axis.ticks = element_blank(), axis.text.y = element_blank(), axis.title.y = element_blank()) + 
  ggtitle("Figure 4: Proportion who have had at least 1 day unwell (in last 30)")

?scale_fill_discrete

rm(fill)
scale_fill_manual(values= fill) +


Z1 <- brfss2013 %>% gather(health, days, c(ph.band2, me.band2))
ggplot(data=Z1, aes(y=percent, x="health", fill = percent)) + geom_bar(stat = "identity")


#this creates the 2x2 I need
F5 <- table(brfss2013$me.band2, brfss2013$ph.band) %>% prop.table(2)*100
F5 <- as.data.frame(F5)
ggplot(data=F5, aes(y=Freq, x=Var2, fill = Var1)) + geom_bar(stat = "identity") +
  scale_fill_discrete(name = "Days mentally unwell") + 
  xlab("Days physically unwell") + ylab("Percentage") +
  ggtitle("Figure 5: Relationship between Physical and Mental unwellness")

#create the chart the other way round

F6 <- table(brfss2013$ph.band2, brfss2013$me.band) %>% prop.table(2)*100
F6 <- as.data.frame(F6)
ggplot(data=F5, aes(y=Freq, x=Var2, fill = Var1)) + geom_bar(stat = "identity") +
  scale_fill_discrete(name = "Days mentally unwell") + 
  xlab("Days physically unwell") + ylab("Percentage") +
  ggtitle("Figure 5: Relationship between Physical and Mental unwellness")


#spare code
e <- Q2 %>% gather(health, days, c(ph.band2, me.band2))
f <- e %>% group_by(health, days) %>% summarise(count=n(), freq = n()*100/nrow(Q1))

brfss2013 %>% group_by(menthlth) %>% summarise(n())
brfss2013 %>% group_by(me.band) %>% summarise(n()*100/nrow(brfss2013))
brfss2013 %>% group_by(physhlth) %>% summarise(n())
brfss2013 %>% group_by(ph.band) %>% summarise(n()*100/nrow(Q1))

Q1 %>% group_by(ph.band, po.band) %>% summarise(n()*100/nrow(Q1))

#look at difference in mental and physical deteriation across different age, gender, income variables

D2 <- brfss2013
colnames(D2)[1] <- "Physical"
colnames(D2)[2] <- "Mental"
colnames(D2)[6] <- "Age"

F7 <- D2 %>% gather(Health, Days, c(Physical, Mental)) %>% select(Age, Health, Days) %>% group_by(Age, Health) %>% summarise(mean=mean(Days))
F7$Health <- factor(F7$Health, levels = c("Physical", "Mental"))

ggplot(data=F7, aes(x=Age, y=mean, fill = Health)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(labels = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+")) + ggtitle("Figure 6: Physical and Mental unwellness by age")

#focus in on mental health, and look age by gender

D3 <- brfss2013
colnames(D3)[1] <- "Physical"
colnames(D3)[2] <- "Mental"
colnames(D3)[6] <- "Age"

#mental - stark differences between gender!
F8 <- D3 %>% gather(Health, Days, c(Physical, Mental)) %>% select(Age, Health, sex, Days) %>% group_by(Age, Health, sex) %>% summarise(mean=mean(Days)) %>% filter(Health == "Mental")
ggplot(data=F8, aes(x=Age, y=mean, fill = sex)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(labels = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+")) + ggtitle("Figure 6: Mental unwellness by age and gender")

#physial - while for physical the gaps are much smaller, narrowest among the 55-64 age bracket
F9 <- D3 %>% gather(Health, Days, c(Physical, Mental)) %>% select(Age, Health, sex, Days) %>% group_by(Age, Health, sex) %>% summarise(mean=mean(Days)) %>% filter(Health == "Physical")
ggplot(data=F9, aes(x=Age, y=mean, fill = sex)) + geom_bar(stat = "identity", position = "dodge") + scale_x_discrete(labels = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+")) + ggtitle("Figure 6: Physical unwellness by age and gender")


#look at % who have had at least 1 - how many people are unwell?!

D3 <- brfss2013
colnames(D3)[1] <- "Physical"
colnames(D3)[2] <- "Mental"
colnames(D3)[6] <- "Age"

D3 <- D3 %>% group_by(Age, ph.band2, me.band2) %>% summarise(percent = round(n()*100 / nrow(D3)), 1) %>% 
  mutate(combo = paste(ph.band2, me.band2))

D3 <- D3 %>% mutate(combined = (D3$Physical + D3$Mental) == 0*1)
D3 <- D3 %>% mutate(combined = if_else(Physical == 0 & Mental == 0, "Zero", "At least 1"))

F10 <- table(D3$combined, D3$Age) %>% prop.table(2)*100
F10 <- as.data.frame(F10)
ggplot(data=F10, aes(y=Freq, x=Var2, fill = Var1)) + geom_bar(stat = "identity") +
  scale_fill_discrete(name = "Days mentally unwell") + 
  xlab("Days physically unwell") + ylab("Percentage") +
  ggtitle("Figure 5: Relationship between Physical and Mental unwellness")



