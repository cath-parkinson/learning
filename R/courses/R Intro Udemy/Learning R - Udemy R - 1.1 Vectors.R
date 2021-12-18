#Vectors

#Sequence of data elements of the same basic type - imagine it like a horizontal bookshop with lots of different shelves for data
#Numberic vectors can be integers (whole numbers, negative and positive including zeros) or doubles 

#this function creates a vector
MyFirstVector <- c(3, 45, 56, 732) #c stands for combine
MyFirstVector

#two ways of doing the same thing
#make a vector of size 2 from the combine function
c <- c(rnorm(1), rnorm(1))
c

#this automatically creates a vector of 2
d <- rnorm(2)
d

#is this object numeric? TRUE
is.numeric(MyFirstVector)

#is this object an integer? FALSE, becuase r stores integers as doubles! (because it's used for lots of numeric operations)
is.integer(MyFirstVector)

#this this obect a double? TRUE
is.double(MyFirstVector)

#force it to be an integer
v2 <- c(3L, 45L, 56L, 732L)
v2

#is this object an integer? TRUE!
is.integer(v2)

#character vector
v3 <- c("a", "B23", "Hello")
v3
is.character(v3)
is.numeric(v3)

#vectors must contain data that is all one type!!! Very important.
v3 <- c("a", "B23", "Hello", 7) #this stores 7 as a character, so in the console it comes out as "7"
v3

#sequence - very similar to :
seq() #sequence 

#all of these create a vector from 1 to 15 
seq(1,15)
c(1:15)
1:15
seq(15)

f1 <- c("c", "d", "f")
f1

seq(f1) #this gives you a sequence of numbers from 1 to 4

seq(1,15,2) #you can add a step of 2! This gives you all the odd numbers up to 15, because it goes up in steps of 2
z <- seq(1,15,4) #this gives you 1,5,9,13 (all your numbers will be between 1 and 15)

#replicate
rep(3, 50) #this create a vector which repeats 3, 50 times
d <- rep (3,50)
d

rep("a", 5) #this creates a vector with a repeated 5 times
x <- c(80, 20)
rep(x,10) #this creates a vector which is 80 20 80 20 80 20 etc...

#how to access different values of the vector NOTE! This won't actually be used that often
w <- c("a", "b", "c", "d", "e")
w[3] #give me n=3 of the vector
w[1] #give me the first element of the vector
w[-1] #give me everything except the first value
w[-2 :-3] #give me everything except the 2nd and 3rd value NOTE! The colon creates a vector, so it's passing a vector back through to the original vector! To tell it what to do
w[1:3] 
w[-2:-4]
w[c(-1,-3,-5)] #therefore you can use your COMBINE function to create a vector as well, and this allows you to skip values that arn't next to each other
w[sum(1,2)]#calculates the sum (which equal 3, and then outputs the 3rd value of the vector)

#you can add, multiply and subtract vectors
w <- 1:5
c <- 6:10
w + c
w * c
w / c
#if the vectors are not the same size - then r RECYCLES vectors, so the smaller one will repeat again in order to fit into the bigger one! R will do this, but it will give you an error
w <- 1:2
c <- 1:6
w + c
w <-1:4

x <- rnorm(5)
x
x[1:5]

#we want to print out each value of x separately 
#version 1, i cycles from 1 -5 (this is a conventional programming loop)
for(i in 1:5){
  print(x[i])
}
#version improved (r specific!) - "for each i in x - do whatever". You can just use "x" in place of "1:5", and i cycles round each of the 5 random numbers (it's assuming the values of each of the vectors)
for(i in x){
  print(i)
}
#ASK TOM - what is happening here?!! It's printing the ith value of x! Where i is an element of x...
for(i in x){
  print(x[i])
}

#comparing vectorised operations with devectorised operations (spoiler - with vectors it's quicker!)
N <- 100
a <- rnorm(100)
b <- rnorm(100)

#vector approach
c <- a * b

#devector approach - this takes much longer to run
d <- rep(NA,100) #create an empty vector! You're allocating empty memory
for (i in 1:N){
  d[i] <- a[i]*b[i]
}


