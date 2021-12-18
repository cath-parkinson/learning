library(tidyverse)
data <- read.csv("data-raw/day1_input.txt",
                 header = FALSE)
v <- data$V1
v1 <- v
v2 <- v

df <- data.frame(expand.grid(v,v1))
df %>% mutate(Sum = Var1 + Var2) %>% filter(Sum == 2020) %>% mutate(Multiply = Var1*Var2)

df2 <- data.frame(expand.grid(v,v1,v2))
df2 %>% mutate(Sum = Var1 + Var2 + Var3) %>% filter(Sum == 2020) %>% mutate(Multiply = Var1*Var2*Var3)
