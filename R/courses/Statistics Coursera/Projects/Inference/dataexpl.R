getwd()
#setwd("C:/Users/cpark/OneDrive/Documents/R/Statistics Coursera/Projects/Inference")
setwd("C:/Users/cpark/OneDrive/Documents/R/Statistics Coursera/Projects/Inference")
str(gss)

#attiudes to woman and sex -> abortion

years <- gss %>% group_by(year) %>% summarise(n())
abany <- gss %>% group_by(year, abany) %>% summarise(n())

gss %>% group_by(uscitzn) %>% summarise(n())
summary(gss$abany)

filter <- gss %>% select(year, abany) %>% filter(!is.na(abany))
data <- filter %>% count(year, abany) %>% group_by(year) %>%
  mutate(percent = n / sum(n)) %>% ungroup()
data %>% filter(abany == "Yes") %>% ggplot(aes(x = year, y=percent)) + geom_line()

# group the data into 10 year periods
decades <- filter %>% mutate(year = ifelse(year < 1989 & year > 1977, "78-88", 
                                           ifelse(year > 2001, "02-12", "Other"))) %>% 
  filter(year != "Other")

decades$year <- as_factor(decades$year)
decades$year <- factor(decades$year, levels = c("78-88", "02-12"))

data_2 <- decades %>% count(year, abany) %>% group_by(year) %>%
  mutate(percent = n / sum(n)) %>% ungroup() %>% filter (year != "Other")
data_2 %>% filter(abany == "Yes") %>% 
  ggplot(aes(x = year, y=percent)) + geom_bar(stat = "identity")

# check conditions

# null hypothesis - the % of ppl who think abortion is ok, has not changed 
# pd2 - pd1 = 0 

#alternative hypothesis - the % of ppl who think abortion is ok, has changed
# pd2 - pd1 != 0

#calculate the pooled proportion 

t <- chart %>% group_by(abany) %>% summarise(total=sum(n))
pooled <- chart %>% group_by(abany) %>% summarise(total=sum(n)) %>% mutate(percent = total / sum(total))

# Confidence Interval
p <- 0.393
n1 <- 11732
n2 <- 7468
se <- sqrt((p*(1-p)/n1) + (p*(1-p)/n2))


(0.3734 - 0.42287) + se*1.96
(0.3734 - 0.42287) - se*1.96
 
#hypothesis tests


# significance test
inference(y = abany, x = year, data = decades, statistic = "proportion", type = "ci", 
          method = "theoretical", success = "Yes")
inference(y = abany, x = year, data = filter, statistic = "proportion", type = "ht", alternative = "twosided",  
          method = "theoretical", success = "Yes", null = 0)
