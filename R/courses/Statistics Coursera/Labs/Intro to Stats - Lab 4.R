#set up
NZ.election <- read.csv(file.choose())
load("selected_nzes2011.Rdata")
NZ.election <- selected_nzes2011
rm(selected_nzes2011)
library(dplyr)
library(ggplot2)

#exploring data
head(NZ.election)

#question 1
#look at relationship between 3 variables
#jpartyvote - who you voted for
#jdiffvoting - do you believe voting makes a difference?
#X_singlefav - party you're most strongly aligned with

head(NZ.election,3)
str(NZ.election)

#filter the data frame so you can visualise the 3 variables more easily
typeof(NZ.election$jpartyvote)
unique(NZ.election$jpartyvote)
summary(NZ.election$jpartyvote)
explore <- select(NZ.election,jpartyvote, jdiffvoting, X_singlefav)
NZ.election %>% select(jpartyvote, jdiffvoting, X_singlefav) %>% str()
NZ.election %>% select(jpartyvote, jdiffvoting, X_singlefav) %>% summary()

colnames(NZ.election)
sum(na.omit(NZ.election$jpartyvote == NZ.election$X_singlefav))

NZ.election %>% group_by(jpartyvote) %>% summarise(count = n())
explore <- explore %>% mutate(sameparty = jpartyvote == X_singlefav)

na.omit(explore) %>% group_by(sameparty, jdiffvoting) %>% summarise(count = n())
na.omit(explore) %>% group_by(jdiffvoting) %>% summarise("no. voted same" = sum(sameparty), count = n(), "voted same" = sum(sameparty)/n()*100) 
na.omit(explore) %>% 
  group_by(jdiffvoting) %>% 
  summarise("no. voted same" = sum(sameparty), 
            count = n(), 
            "voted same" = sum(sameparty)/n()*100)
#how do I group rows in my summary table?!!
#it looks like the hypothesis is not true - those who think voting makes a big difference, are actually more likley to have voted the same

#question 2
#is there a relationship between age and how much voters like NZ first party?
explore.2 <- select(NZ.election, jnzflike, jage)
explore.2 %>% filter(jnzflike != "NA" & jage != "NA") %>% group_by(jnzflike) %>% summarise(count=n(), agemean = mean(jage), agemedian = median(jage)) %>% arrange(desc(jnzflike))

#change the factor variable into a numeric so it's more useful
head(as.numeric(explore.2$jnzflike))
head(as.character(explore.2$jnzflike))

explore.2 <- explore.2 %>% mutate(jnflike.num = as.numeric(as.character(jnzflike)))
explore.2 %>% filter(jnflike.num != "NA" & jage != "NA") %>% group_by(jnflike.num) %>% summarise(count=n(), agemean = mean(jage), agemedian = median(jage)) %>% arrange(jnflike.num)

