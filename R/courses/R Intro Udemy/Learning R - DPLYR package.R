library("dplyr")

#select
#select the columns you need
#1) select the column that you want
a <- select(NZ.election, jpartyvote)
a
#2) select everything except one column
b <- select(NZ.election, -jpartyvote)
#3) you can also use the index to select columns
c <- select(NZ.election, 1:2)
d <- select(NZ.election,c(1,4,5))
select(NZ.election, -(1:6))
#4) all names
names(NZ.election)
#one name, or some names
names(NZ.election)[82]
names(NZ.election)[1:4]
#change a name
names(NZ.election)[11] <- c("lablike")
#5) Select data based on words contained in the column names
e <- select(NZ.election, contains("j"))
names(e) == names(NZ.election)
names(select(NZ.election, 107))
f <- select(NZ.election, starts_with("j"))
g <- select(NZ.election, contains("ethnicity"))
h <- select(NZ.election, ends_with("fun"))
#when you stack conditions, it just gets you all columns that meet at least 1 condition
i <- select(NZ.election, starts_with("j"), ends_with("vote"))
#how would you alter this to get both starting with j AND ending with vote?
j <- select(NZ.election, c(starts_with("j"), ends_with("vote")))
#you can also rename within the select function
k <- select(NZ.election, Party_Vote = jpartyvote)


#filter
#select data based on ROWS that you need
#1) based on AND/OR conditions
l <- filter(NZ.election, jage>54 | jage<25)
sum(na.omit(NZ.election$jage > 54 | NZ.election$jage < 25))
m <- filter(NZ.election, jage > 54 & jpartyvote == "Green")
sum(na.omit(NZ.election$jage > 54 & NZ.election$jpartyvote == "Green"))
#2) based on calculation
o <- filter(NZ.election, 4 < jhhadults + jhhchn)
sum(na.omit(4 < NZ.election$jhhadults + NZ.election$jhhchn))
#3) get rid of NAs
p <- filter(NZ.election, complete.cases(jpartyvote))
nrow(NZ.election) - sum(is.na(NZ.election$jpartyvote))
#4) using text
k <- filter(NZ.election, jpartyvote == "Green")
sum(na.omit(NZ.election$jpartyvote == "Green"))
#5) using the pipe in filter - it looks for Green and Labour and returns the rows if they are there
#what does this operator do?
q <- filter(NZ.election, jpartyvote %in% "Green")
r <- filter(NZ.election, jpartyvote %in% c("Green", "Labour"))
sum(na.omit(NZ.election$jpartyvote == "Green" | NZ.election$jpartyvote == "Labour"))

#arrange
#sort your data by a given condition
#1) from low to high 
c <- arrange(c, Jelect)
#2) from high to low
c <- arrange(c, desc(Jelect))
#3) multiple conditions - it sorts by jelect, and then within than, jnatradio
d <- arrange(d, Jelect, jnatradio)

#creates a "tibble" which is nicer to look at and manage
NZ.election.1 <- as_tibble(NZ.election)

#mutate
#add new variables to your data
n <- mutate(NZ.election.1, total.people = jhhadults + jhhchn)
#1) you can stack these
s <- mutate(NZ.election.1, 
            total.people = jhhadults + jhhchn, 
            ageover54 = jage > 54)
#2) and you can use the ifelse function
t <- mutate(s, ageover54.2 = ifelse(jage>54, "Over 54", "Under 54"))
#also nested ifelse functions
u <- mutate(t, 
            agebands = ifelse(jage < 35, "18-34", 
                              ifelse(jage < 55, "35-54", "55+")))

select(u, "jage", "agebands")

#summarise
#produces a summary table with mean, sd and counts (and any other functions you want!)
summarise(NZ.election, 
          mean_age = mean(jage, na.rm = T), 
          sd_age = sd(jage, na.rm = T), 
          count = n())

u <- select(u, "jage", "agebands")

#you can apply groupby to the summarise function! so you can look at average scores by different groups
summarise(group_by(u, agebands), mean(jage))

#finally, introducing the chain operation
#makes it easy to nest different functions
#because in all of the dplyr functions you have (data, .....)
#so this allows you to drop the reference to the data
# %>% which basically "then"

#so this gets you exactly what you have above!
u %>% group_by(agebands) %>% summarise(mean(jage))

#gather
#allows you to turn wide data into long data
install.packages("tidyr")
library(tidyr)

messy <- data.frame(
  name = c("Wilbur", "Petunia", "Gregory"),
  a = c(67, 80, 64),
  b = c(56, 90, 50)
)
gather(messy, drug, heartrate, a:b)

#separate allows you to split variables based on delimiters like full stops or dashes
?separate

#output a summary table of key statisitics! 
summary(NZ.election$jage)

