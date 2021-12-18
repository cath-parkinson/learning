#lab 3

#explore the data set
data("kobe_basket")
typeof()
unique() #what values are in a particular variable
length() #how long is a particular variable
is.unsorted() #check if a variable is not sorted in ascending order (it returns TRUE or FALSE)
table() #quickly output how many of each value included in the variable!!! USEFUL

#add a variable 1-133 so you can arrange the data set in the original order if needed
kobe_basket <- kobe_basket %>% mutate(id = seq(1,133))
is.unsorted(kobe_basket$id) #check it's in ascending order

#ask Tom - how do you filter data, and then unfilter? And how do I check that time is in descending order by date and time?
kobe_basket <- kobe_basket %>% filter(game==1)
kobe_basket

#look at time (quarters run 12 mins each, and they count down)
typeof(kobe_basket$time)

#look at the first 8 values of the variable "shot"
typeof(kobe_basket$shot)
kobe_basket$shot[1:8]

#use a custom function to calculate the number of streaks
kobe_streak <- calc_streak(kobe_basket$shot)
kobe_streak

#create the no. of streaks using a for / ifelse loop!!
kobe_basket$shot[133] #NB the last value is a hit, so this code works except it doesn't capture the very last streak!
strkl <- 0
s <- rep(NA, 134)
for(i in 1:134){
  if(kobe_basket$shot[i] == "H") {
    strkl <- strkl + 1
  } else { 
    s[i] <- strkl
    strkl <- 0
  }
}

#exploring my new variable s
typeof(s)
unique(s)
length(s)
x <- is.na(s) #tells me where the "NA"s are in my "s" vector
sfinal <- na.omit(s) #creates a new vector where you delete all of the NAs!!

#check my vector matches their vector (yay!)
checkvar <- kobe_streak$length #turns their data into a vector
checkvar == sfinal #checks! it's all correct 

#FINAL CODE!
#amend code so it works for the last value
strkl <- 0
s <- rep(NA, 133)
for(i in 1:133){
  if(i <= 132 & kobe_basket$shot[i] == "H") {
    strkl <- strkl + 1
  } else if(i == 133 & kobe_basket$shot[i] == "H"){
    strkl <- strkl + 1
    s[i] <- strkl
  } else {
    s[i] <- strkl
    strkl <- 0
  }
}
sfinal <- na.omit(s)

#workings
#check the double assignment in the if loop (you cannot use "1:133" in an AND statement, you need to say "less than or equal to")
i <- 19
if(i <= 133 & kobe_basket$shot[i] == "H") {
  print(kobe_basket$shot[i])
}

#checking the for loop works
for(i in kobe_basket$shot) {
    ifelse(i == "H", print(i), NA)
}
for(i in 1:133) {
  ifelse(kobe_basket$shot[i] == "H", print(i), NA)
}

#check the for loop works, and can assign the value to the vector
s <- rep("NA",500)
for(i in kobe_basket$shot) {
  ifelse(i == "H", print(i), NA)
}

#check how assigning to the vector works
s <- rep(NA, 500)
strkl <- 3
s[strkl] <- strkl #this assigns "3" to the "THIRD" value of s!!!! Instead need to assign to the "ith" value, otherwsie it will keep overwriting 

#histogram of the streak data
ggplot(kobe_streak,aes(x=length)) + geom_histogram(binwidth = 1)
IQR(kobe_streak$length) #tell me the IQR

#creating a random data set
coin_outcomes <- c("heads", "tails")
faircoin <- sample(coin_outcomes, 100, replace = TRUE) #the sample function, creates a vector of size 100 where it selects values from "coin_outcomes", using the replacement (after you pick one, you put it back).It assume each value is equally likely
table(faircoin) #quickly output the number of values in a vector!!
biasedcoin <- sample(coin_outcomes, 100, replace = TRUE, prob = c(0.2,0.8)) #as above but with a biased coin (it's more likely to be tails!)
table(biasedcoin)
table(kobe_basket$game)

#you can create this for hits and misses too! So we can compare "hot hands" to a shooter with a 0.45 chance of scoring
score_outcomes <- c("H", "M")
fakedata_baskets <- sample(score_outcomes, 133, replace = TRUE, prob = c(0.45, 0.55))
fakedata_baskets

#calculate the number of streaks using my above code!
strkl <- 0
fakedata_streaks <- rep(NA, 133)
for(i in 1:133){
  if(i <= 132 & fakedata_baskets[i] == "H") {
    strkl <- strkl + 1
  } else if(i == 133 & fakedata_baskets[i] == "H"){
    strkl <- strkl + 1
    fakedata_streaks[i] <- strkl
  } else {
    fakedata_streaks[i] <- strkl
    strkl <- 0
  }
}
fakedata_streaksfinal <- na.omit(fakedata_streaks)
mydataframe <- data.frame(fakedata_streaksfinal) #turns the vector into a data frame
data(fakedata_streaksfinal)#reads in the data

#looks at the histogram, and compares data to the coursera data - gets the same answer!
ggplot(data = mydataframe, aes(fakedata_streaksfinal)) + geom_histogram(binwidth = 1)
IQR(fakedata_streaksfinal)
IQR(kobe_streak$length)
mean(fakedata_streaksfinal)
mean(kobe_streak$length)
coursera_fakedata_streak <- calc_streak(fakedata_baskets)
ggplot(data = coursera_fakedata_streak, aes(length)) + geom_histogram(binwidth = 1)

