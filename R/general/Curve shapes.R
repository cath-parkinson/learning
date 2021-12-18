#graph functions

x <- round(runif(100,1,500))
y <- x
y <- 1/ sqrt(x)
plot(x,y, main="1/sqrt(x)")

#probabilty
n <- 35
sd <- 17
se <- sd / sqrt(n)
mean <- 130

pnorm(134,mean,se)

qnorm(0.05,mean,se, lower.tail = FALSE)
1-pnorm(134,130,2.9)  

(300/(40/2.33))^2
