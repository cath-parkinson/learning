library(dplyr)
library(tidyr)
library(ggplot2)

plot1 <- fin %>% select(Industry, Revenue, Expenses, Profit, Growth)

plot1 %>% ggplot(aes(x = Revenue, y = Expenses)) + 
  geom_point(aes(colour = Industry, size = Profit)) + 
  ggtitle("Revenue vs. Profit")

plot1 %>% ggplot(aes(x=Revenue, y = Expenses, colour = Industry))+
  geom_point() + geom_smooth(fill = NA, size = 1.2)

plot1 %>% ggplot(aes(y = Growth, x = Industry, colour = Industry)) + 
  geom_jitter() +
  geom_boxplot(size = 1, alpha = 0.5, outlier.colour = NA) + 
  ggtitle("Growth by Industry") + 
  scale_x_discrete(labels = abbreviate)
