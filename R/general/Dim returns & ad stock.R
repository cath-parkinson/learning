#dimishing returns ####

#start with an exponential
x <- seq(1,30)
a <- exp(x)
plot(x,a,"l")

#flip it by the x axis
#-f(x)
b <- a*-1 
plot(x,b,"l")

#flip it by the y axis
#f(-x)
c <- (-1*exp(-1*x))
plot(x,c,"l")

#shift back into the positive y-axis
d <- c +0.5
plot(x,d,"l")
par(new=T)

#steepness of the curve
e <- (-1*exp((-1*x)/10)) + 0.5
plot(x,e,"l")
par(new=T)

f <- (-1*exp((-1*x)/5)) + 0.5
plot(x,f,"l")
par(new=T)

#shape of graph is determing by the steepness of the curve i.e. what value do you divide the x by

#streches or compresses the graph
#f(x)*FACTOR
g <- (-1.1*exp((-1*x)/5)) + 0.5
plot(x,g,"l")


#real diminishing returns curve

x <- seq(from=50000, to=10e6, by=50000)
y <- 416089*(1-exp(-x/168256))
y
plot(x,y,"l")

?seq
#adstock ####
#effect of advertising decays
#we apply adstock to media spends, because the effect of advertising won't just be 1 week - it will last longer, and decay over time
#therefore we transform the media variable, using adstock
#COME BAK AND CHECK THIS IS HOW THE TRANSFORMATION WORKS

orig <- sample(1:500,20)
week <- c(1:20)
plot(week,orig, "l")
data <- data.frame(week,orig)

#install.packages("data.table")
library(data.table)

# using a "for" loop!
data.10 <- c()
for
  (i in week)
    {
  if(i==1){
    x <- orig[i]
    data.10[i] <- x
  } else {
    x <- (x*0.1) + orig[i]  
    data.10[i] <- x
  }
rm(x)
}

data.50 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.50[i] <- x
  } else {
    x <- (x*0.5) + orig[i]  
    data.50[i] <- x
  }
}
rm(x)

data.80 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.80[i] <- x
  } else {
    x <- (x*0.8) + orig[i]  
    data.80[i] <- x
  }
}
rm(x)

data <- data.frame(week, orig, data.10, data.50, data.80)
library(ggplot2)
ggplot(data, aes(x=week)) +
  geom_line(aes(y=orig), colour = "blue") +
  geom_line(aes(y=data.10), colour = "green") + 
  geom_line(aes(y=data.50), colour = "yellow") +
  geom_line(aes(y=data.80), colour = "red")

# read in data ####
setwd("C:/Google Drive/Brightblue/!Clients/Dowsing Reynolds/MMM_19/Data/Worked/Media")
library(readxl)
readin <- read_excel("Magazine.xlsx", sheet=11, skip=13)

?read_excel()
orig <- readin$Total..4
week <- c(1:104)
data.10 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.10[i] <- x
  } else {
    x <- (x*0.1) + orig[i]  
    data.10[i] <- x
  }
}

data.20 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.20[i] <- x
  } else {
    x <- (x*0.2) + orig[i]  
    data.20[i] <- x
  }
}
data.30 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.30[i] <- x
  } else {
    x <- (x*0.3) + orig[i]  
    data.30[i] <- x
  }
}
data.40 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.40[i] <- x
  } else {
    x <- (x*0.4) + orig[i]  
    data.40[i] <- x
  }
}
data.50 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.50[i] <- x
  } else {
    x <- (x*0.5) + orig[i]  
    data.50[i] <- x
  }
}
data.60 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.60[i] <- x
  } else {
    x <- (x*0.6) + orig[i]  
    data.60[i] <- x
  }
}
data.70 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.70[i] <- x
  } else {
    x <- (x*0.7) + orig[i]  
    data.70[i] <- x
  }
}
data.80 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.80[i] <- x
  } else {
    x <- (x*0.8) + orig[i]  
    data.80[i] <- x
  }
}
data.90 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.50[i] <- x
  } else {
    x <- (x*0.9) + orig[i]  
    data.90[i] <- x
  }
}
data.95 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.95[i] <- x
  } else {
    x <- (x*0.95) + orig[i]  
    data.95[i] <- x
  }
}
data.97 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.97[i] <- x
  } else {
    x <- (x*0.97) + orig[i]  
    data.97[i] <- x
  }
}

data.99 <- c()
for
(i in week)
{
  if(i==1){
    x <- orig[i]
    data.99[i] <- x
  } else {
    x <- (x*0.99) + orig[i]  
    data.99[i] <- x
  }
}

data <- data.frame(week, orig, data.10, data.20, data.30, data.40, data.50, data.60, data.70, data.80, data.90, data.95, data.97, data.99)
week <- readin$Date

library(ggplot2)
ggplot(data, aes(x=week)) +
  geom_line(aes(y=orig), colour = "red") +
  geom_line(aes(y=data.10), colour = "green") + 
  geom_line(aes(y=data.20), colour = "yellow") +
  geom_line(aes(y=data.30), colour = "blue") +
  geom_line(aes(y=data.40), colour = "purple") +
  geom_line(aes(y=data.50), colour = "orange")

write.csv(data, file = "adstocked.csv")

# Alphas and Betas ####

# what happens when we change beta, keep alpha constant

x <- c(1:300)
a <- 50

y1 <- 10*(1-exp(-x/a))
y2 <- 30*(1-exp(-x/a))
y3 <- 50*(1-exp(-x/a))
y4 <- 70*(1-exp(-x/a))
y5 <- 100*(1-exp(-x/a))

data <- data.frame(x,y1,y2,y3,y4,y5)

library(ggplot2)
ggplot(data, aes(x=x)) +
  geom_line(aes(y=y1), colour = "red") +
  geom_line(aes(y=y2), colour = "green") + 
  geom_line(aes(y=y3), colour = "yellow") +
  geom_line(aes(y=y4), colour = "blue") +
  geom_line(aes(y=y5), colour = "purple") + labs(title = ("Change Beta, Constant Alpha"))

# what happens when we change alpha, keep beta constant

x <- c(1:300)
b <- 50

y1 <- b*(1-exp(-x/10))
y2 <- b*(1-exp(-x/30))
y3 <- b*(1-exp(-x/50))
y4 <- b*(1-exp(-x/70))
y5 <- b*(1-exp(-x/100))

data <- data.frame(x,y1,y2,y3,y4,y5)

library(ggplot2)
ggplot(data, aes(x=x)) +
  geom_line(aes(y=y1), colour = "red") +
  geom_line(aes(y=y2), colour = "green") + 
  geom_line(aes(y=y3), colour = "yellow") +
  geom_line(aes(y=y4), colour = "blue") +
  geom_line(aes(y=y5), colour = "purple") + labs(title = ("Change Alpha, Constant Beta"))




