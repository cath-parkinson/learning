#LAB 2

#create a bar chart
ggplot(data = nycflights, aes(x = arr_delay)) + geom_bar() + xlim(-100,200)
which.min(nycflights$arr_delay)
nycflights$arr_delay[31892]
typeof(nycflights$dest)

#create a histogram (adjust binwidth as needed)
ggplot(data = nycflights, aes(x = arr_delay)) + geom_histogram(binwidth = 10)

#two ways of flitering by RDU - which is best?!
RDU_flights2 <- nycflights %>% filter(dest == "RDU") #"==" means if it's equal to!
RDU_flights <- filter(nycflights, dest == "RDU")


#2 ways of adding multiple filters
SFO_FEB_flights <- filter(nycflights, (dest == "SFO") & (month == 2))
SFO_FEB_flights2 <- nycflights %>% filter(dest == "SFO", month == 2)

SFO_orFEB_flights <- filter(nycflights, (dest == "SFO") | (month == 2))
SFO_orFEB_flights2 <- nycflights %>% filter(dest == "SFO" | month == 2)


ggplot(data = RDU_flights, aes(x=dep_delay)) + geom_histogram()

#logical operators - do this "if"
# == means "equal to"
# != means "not equal to"
#> or < means "greater than" or "less than"
#>= or <= means "greater than or equal to" or "less than or equal to"

#numerical summaries! this creates a list - is there a way of calling them all at once?!!
RDU_flights %>% summarise(mean_dd = mean(dep_delay), sd_dd = sd(dep_delay), median_dd = median(dep_delay), IQR_dd = IQR(dep_delay), n = n())

#mean
#median
#sd
#var
#IQR
#range
#min
#max

#introduce the group by function to see the summary stats by different groups!
RDU_flights %>% group_by(origin) %>% summarise(mean_dd = mean(dep_delay), sd_dd = sd(dep_delay), median_dd = median(dep_delay), IQR_dd = IQR(dep_delay), n = n())

#introduce the "arrange" function to sort from high to low by specifed variable
nycflights %>% group_by(month) %>% summarise(mean = mean(dep_delay), sd = sd(dep_delay), median = median(dep_delay), max = max(dep_delay)) %>% arrange(desc(median))

#identify the unique calues in a vector!
length(nycflights_origin)
unique(nycflights_origin)

#box plots! You must have a categorical variable on the y-axis! #"factor" turns any variable into a categorical variable
ggplot(data=nycflights, aes(x=factor(month), y=dep_delay)) + geom_boxplot()

#segmented bar chart!
ggplot(data=nycflights, aes(x=factor(origin), fill = depontime)) + geom_bar()

#lapwork
ggplot(data=SFO_FEB_flights, aes(x=arr_delay)) + geom_histogram(binwidth = 10)
SFO_FEB_flights %>% summarise(mean = mean(arr_delay), sd = sd(arr_delay), median = median(arr_delay), max = max(arr_delay))
SFO_FEB_flights %>% group_by(carrier) %>% summarise(mean = mean(arr_delay), sd = sd(arr_delay), median = median(arr_delay), IQR = IQR(arr_delay), max = max(arr_delay))
nycflights_origin <- nycflights$origin
sum(nycflights_origin)
length(nycflights_origin)
unique(nycflights_origin)
nycflights %>% group_by(month) %>% summarise(mean = mean(arr_delay), sd = sd(arr_delay), median = median(arr_delay), max = max(arr_delay))
nycflights %>% group_by(month) %>% summarise(mean = mean(dep_delay), sd = sd(dep_delay), median = median(dep_delay), max = max(dep_delay)) %>% arrange(desc(median))
nycflights %>% group_by(carrier) %>% summarise(mean = mean(dep_delay), sd = sd(dep_delay), median = median(dep_delay), max = max(dep_delay)) %>% arrange(desc(median))
#capture all flights with delays of under 5
nycflightsnew <- nycflights %>% mutate(depontime = (dep_delay < 5))
#same but using the ifelse function!
nycflights <- nycflights %>% mutate(depontime = ifelse((dep_delay < 5), "On time", "Delayed"))
#this adds a calulcation into the summary stats table!
nycflights %>% group_by(origin) %>% summarise(deprate = sum(depontime == "On time") / n())
nycflights <- nycflights %>% mutate(avg_speed = distance / air_time)
nycflightstest <- nycflights %>% arrange(desc(avg_speed)) %>% select(avg_speed,tailnum)
nycflightstest <- nycflights %>% arrange(desc(avg_speed))
#after doing these transformations how do i get my data set back to its original ordering?!!
ggplot(data=nycflights, aes(x = distance, y= avg_speed)) + geom_point()
nycflights <- nycflights %>% mutate(arr_type = ifelse(arr_delay <= 0, "On time", "Delayed"))
nycflights %>% summarise(arrivalrate = sum(arr_type == "On time")/ n())
nycflights %>% group_by(depontime) %>% summarise(arrivalrate = sum(arr_type == "On time")/ n())
