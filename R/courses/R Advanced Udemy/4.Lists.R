library(dplyr)
library(tidyr)
library(ggplot2)

setwd("C:/Users/Catherine/OneDrive/Documents/R/R Advanced Udemy/Data")
#setwd("C:/Users/cpark/OneDrive/Documents/R/R Advanced Udemy/Data")

data <- read.csv("P3-Machine-Utilization.csv")
head(data, 12)
str(data)
summary(data)
tail(data)

#add in column
data <- data %>% mutate(Util = 1-Percent.Idle)
sum(na.omit(data$Percent.Idle + data$Util))+361

#POSIXct (POSIX calendar time)
#POSIXlt (POSIX local time)

# Family of standards for time, stores time, as the number of seconds that has passed since the start of January 1970
# So it's essentially just an integer 


# To do this you need to pass on the format to the computer, to understnad what it's dealing with
data$POSIXTime <- as.POSIXct(data$Timestamp, format = "%d/%m/%Y %H:%M") 
data <- data %>% select(Time = POSIXTime, Machine, Percent.Idle, Util)

summary(RL1)
RL1 <- data[data$Machine == "RL1", ]

# Construct list

#named vector
vector_stats <- c(min = min(data$Util, na.rm=T),
                  max = max(data$Util, na.rm=T), 
                  mean = mean(data$Util, na.rm=T))

# Which Tells us which elements are true! And ignores NA
util_under90 <- RL1[which(RL1$Util < 0.9), ]

list <- list(Machine.name = "RL1", Stats = vector_stats, Times.under90 = util_under90)
names(list) <- c("Machine", "Stats", "LowThreshold")

# extract elements
# remains a list (but with one element)
list[1]
list[2]

# this just extracts the object
list[[1]]
list$Machine

# this extracts an element of the object 
list[[2]][3]
list$Stats[3]

# add new information
list[4] <- "New information"
list$Unknown.Hours <- RL1[is.na(RL1$Util), "Time"]
list[20] <- "Even more information"

# remove information 
# note lists react to moving components - they move the elements up
list[7:20] <- NULL
list$Data <- RL1
str(list)
summary(list)

# remember you can subset lists
sublist <- list[c(1,3)]

#but you can not use double square brackets to subset lists! 
# with the [[]] you need to only access 1 element at a time


plot <- data %>% ggplot(aes(x = Time, y=Util)) + 
  geom_line(aes(colour = Machine), size = 1.2) +
  facet_grid(Machine~.) +geom_hline(yintercept = 0.9, 
                                    colour = "Grey", 
                                    size = 1.2, 
                                    linetype = 1) + ylim(0.7,1)

# save into 
list$plot <- plot
list





