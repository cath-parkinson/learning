#life insurance

monthly.cost <- c(10.23, 15.49, 22.19, 25.57, 27.44, 41.62)
age <- c(20, 30, 40, 50, 60, 70)
death <- 80
years.to.pay <- death - age

life.insurance <- data.frame(monthly.cost = monthly.cost, age = age, years.to.pay = years.to.pay)
life.insurance$total.cost <- monthly.cost * 12 * years.to.pay
life.insurance

