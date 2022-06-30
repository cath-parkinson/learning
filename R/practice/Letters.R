### Useful functions ####

#set up vector
a <- c("th" , "bath", "tath")


#stringr
#tidyverse equiquivalent of nchar
str_length(a)
nchar(a)

#access different bits of the string, this gives you the first to third bits
str_sub(a,1,3)
substr(a,1,3)

#in stringr, really useful because you can count from the left or the right
#positive integers count from the left, negative integers from the right
#for example this gets you the whole string, start to end
str_sub(a,1,-1)

#you can also use this to assign parts of the string
#this takes out the third letter, and replaces it with "HELLO"
str_sub(a,3,3) <- "HELLO"
a

#you can also dublicate strings
#this returns the same sized vector, but with the string dubplicated 3 times
str_dup(a, 3)

#string ordering - gives you the alphabetical order!
b <- c("bath" , "th", "tath")
str_order(b)

#string sort - puts it in alphabetical order! 
str_sort(b)

#base
#returns an integer vector, where the length is the number of matches, 
#and the values are the position of the matches in the original vector
b <- grep("ath", a, value=FALSE)

#in stringr you can count the number of matches within a string!
#gives you a numeric vector of the length of original
#each value is the number of matches within that string
str_count(a, "ath")

#and you can get it to tell you where the match is
#this returns a matrix, where each row is a element of your original vector
#and the columns are the start and end integers of where the match is
loc <- str_locate(a, "ath")
loc

#returns a character vector, where the length is the number of matches,
#and the values are the values that matched in the original vector
c <- grep("ath", a, value=TRUE)
#stringr equivalent! - returns the elements of the vector that match
c <- str_subset(a, "ath")

#returns a logic vector, wthe same length as the original vector, 
#with "T" OR "F" depending on whether there is a match
d <- grepl("ath", a)
#stringr equivalent
d <- str_detect(a, "ath")

#base
#returns an integer vector, of the same length as the original vector,
#the the number represents the character position where the first match was found
#a match at the start of the string is "1", if no match it's "-1"
e <- regexpr("ath", a)

#base
#returns a list, where each element corresponds to an element of the original vector
#with lots of information
f <- gregexpr("ath", a)

#in stringr, you can extract the text corresponding the first match
g <- str_extract(a, "ath")

#extracts a character string, from a character string, you specfiy which bits to extract
substr("abcdef", 2,4)

### Code ####

#object we're interested in
text <- "abcwxyzabghwxyz"

#create alphabet vector
library(stringr)
alpha <- str_remove_all(str_remove_all(toString(letters), " "), ",")

### Workings ####

#this is the length of the vector we'll have at the end - number of possible iterations of the alphabet
#we will have n(char)-x+1 iterations for each x, where x is length of iteration e.g. 3 is "abc"
#r <- seq(3,str_length(alpha))
#sum(str_length(alpha)+1-r)

#say I wanted to get all the 3s
c((str_sub(alpha,1,3)), str_sub(alpha,2,4), str_sub(alpha,3,5))
#first number is 1 all the way up to str_length(alpha)-3
#the second number is always, the original, plus 3-1

#the length of vector is number of iterations you get
#the number inside tell you where to start and stop

#going to need one of these for each 3 to 26
#the length of the vector, is the number of subsectors you get out
str_sub(alpha, c(1,4,3), c(3,6,4))
s <- c(b,c,text)

i <- 1

#starting with a
f <- rep(1,24)
g <- seq(3,26)
str_sub(alpha,f,g)

#starting with b
h <- rep(2,23)
i <- seq(4,26)
str_sub(alpha,h,i)

#starting with c
j <- rep(3,22)
k <- seq(5,26)
str_sub(alpha,j,k)

#try doing this in a loop
l <- c(f,h,j)
m <- c(g,i,k)
str_sub(alpha,l,m)

# More code ####

#vector of start values
a <- 26:1
b <- 1:26
start <- rep(a,b)
start <- sort(start)
rm(a,b)

#vector of stop values
stop <- integer()
for (i in 1:26) {
  a <- seq(i,26)
  stop <- c(stop, a) 
  }
rm(a,i)

# To do ####

#investigate doing this with lapply and lists!!
#?lapply
#a <- 1:26
#u <- lapply(a, function(x) {c(x:26)})
#length(unlist(u))


# More code ####

#create final vector of all iterations of the alphabet
alphait <- str_sub(alpha, start, stop)
rm(start,stop)

#remove all the ones that are sizes 2 or less
a <- str_length(alphait) >= 3
alphaitf <- alphait[a]
rm(a, alphait)

#identifies which one is a match
a <- str_detect(text,alphaitf)

#identifies how many matches
b <- str_count(text,alphaitf)

#identifies the length of the match
c <- str_length(alphaitf)

#put everything together
d <- cbind(alphaitf,a,b,c)
rm(a,b,c,alphaitf)
d <- as_tibble(d)
e <- d %>% filter(a==T, as.integer(b) >=2) 
f <- e %>% filter(c == as.integer(max(c))) %>% summarise(answer = alphaitf)

