# Linear regression 
# With ages
# Explanatory (h) = Husbands' age
# Response (y) = Wifes' age
h <- seq(1, 100, 1)
y <- 1.57 + 0.91*h

plot(h,y, "b")

table <- cbind(h,y)
table <- as_tibble(table)

table <- table %>% mutate(diff = h - y)

ytest <- y[2:100]
ytest <- c(ytest, NA)

table <- table %>% mutate(test = ytest)
table <- table %>% mutate(unit.increase.iny = ytest - y)
table <- table %>% mutate(husband.older = h > y)

# When a husband in britain gets 1 year older, the average wife gets 0.91 years older
# This means the mens' ages increase at a faster rate. So at older ages, the gap between men and women is bigger

plot(table$h , table$diff)
