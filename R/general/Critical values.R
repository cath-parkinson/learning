#CLT 
#find the p-value
pnorm(q, mean = 0, sd = 1)

#first you need to calculate the test statisitic - q  
#you can either use the orignal number and include the mean and standard deviations
#or you can standardise it as below, and use mean = 0 and sd = 1
q <- (xmean - mu) / se
se <- s/sqrt(n)

s <- 1176
n <- 10
  
#find the relevant cut off value
qnorm(0.8)


 #student t-distribution

#for one sample mean
#find the p-value
pt(q, df, lower.tail= FALSE)

q <- tstatistic

#here we first need to calculate the t-statistic
tstatistic <- (obs - null) / se
df <- n -1

pt(0.87, df=199, lower.tail = FALSE)*2
pt(1.4702, df=99, lower.tail = FALSE)*2

#find cut off value for the t distribution
#with 95% confidence
#this gets you the cutoff on the upper half
qt(0.025, df=72, lower.tail = FALSE)

#with 90% confidence
tcutoff <- qt(0.05, df=14, lower.tail = FALSE)

moe <- se*tcutoff

s <-  0.069
n <- 15
se <- s/sqrt(n)

#standard error difference between two independant means

s1 <-38.63
n1 <- 10
s2 <- 52.24
n2 <- 12
  
sediff <- sqrt((s1^2/n1) + (s2^2/n2))

#fdistribution (for anova)
df(5.21, df1 = 4, df2 = 50734)

#difference of propotions
p <- 0.17
n <- 2254

se <- sqrt((p*(1-p)/n))
1.96*se

#differnece of two proportions
#confidence interval
p1 <- 0.7
p2 <- 0.42
n1 <- 813
n2 <- 783

se <- sqrt((p1*(1-p1)/n1) + (p2*(1-p2)/n2))
1.96*se

#hypothesis tests
p <- 0.5535
n1 <- 144
n2 <- 389
se <- sqrt((p*(1-p)/n1) + (p*(1-p)/n2))
obs <- 0.78-0.92
null <- 0
z <- (obs - null) / se
#draw, and check if you're working with the lower or upper tail! 
pnorm(z, lower.tail =F)*2
pnorm(z)*2

#chi-squared tests
#remember to use the counts! 
o <- c(43,21,35)
props <- c(0.333, 0.333, 0.333)
n <- 99
e <- n*props
chi1 <- (o-e)^2/e  
chi <- sum(chi1)
pchisq(chi, 2, lower.tail=F)

l <- c(43,21,35)
sum(l)
sum(props)

