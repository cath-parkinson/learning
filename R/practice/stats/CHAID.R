library(rpart)
library(readr)
library(caTools)
library(dplyr)
library(party)
library(partykit)
library(rpart.plot)

titanic_data <- "https://goo.gl/At238b" %>%  #DataFlair
  read.csv %>% # read in the data
  select(survived, embarked, sex, 
         sibsp, parch, fare) %>%
  mutate(embarked = factor(embarked),
         sex = factor(sex))

set.seed(123)
sample_data <- sample.split(titanic_data, SplitRatio = 0.75)

train_data <- subset(titanic_data, sample_data == TRUE)
test_data <- subset(titanic_data, sample_data == FALSE)

rtree <- rpart(survived ~ . , train_data)
rpart.plot(rtree)
ctree_ <- ctree(survived ~ . , train_data)
plot(ctree_)



rtree <- rpart(fare ~ . , train_data)
rpart.plot(rtree)
mean(titanic_data$fare, na.rm = T)
