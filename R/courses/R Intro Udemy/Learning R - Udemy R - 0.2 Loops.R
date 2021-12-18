#loops

#the while loop
#not actually used that much in r, because it has other means of achieveing the same results from functions such as sapply, lapply and so. But it's important to understand how this is working in the background

while(#a logical expression goes in here e.g. abc){ #here goes the body of the loop, e.g. xyz
  
}

#***when r runs the loop, it will check the logical expression first (normal
#brackets), if this is true, then it will execute whatever is inside the loop.
#When it's done that, it goes back to the start and again checks if the logical
#expression is still true, and then again excucutes what is inside the main
#loop. This will continue until abc is false, then it will stop. HIT "ESC" or
#"CTL Z" to stop the code from running (or the stop button in the console)

while(TRUE){ 
  print("Hello")
}  
#this while loop will print out Hello forever...because TRUE is true

print() #this is used to the print the result -it is needed when you're working inside a loop

counter <- 1 #assigns 1 to the value counter
while (counter < 12){ #checks if counter is less than 12
  print(counter) # if it's less than 12, it prints out the value of counter
  counter <- counter + 1 #it then adds 1 to the counter value, then returns the start, where counter is now 2! And so on
}

#this while loop prints out the numbers 1 to 11, and ends with counter having the value of 12

counter <- 1 
while(counter < 5){
  counter <- (counter*2)
  print(counter)
}

#this while loop prints out the numbers 2,4,8, and ends with counter value 8

#the for loop
#similar to the while loop, but argueably more useful

for(#different from the while loop, this specifies the iterations - what are we going to iterate over?){
  #this part of the loop works in the same way
  }

#this is our first touch on vectors, "1:5" is basically a vector of numbers (or array) e.g. 1 2 3 4 5
#here we are saying i has to iterate through numbers 1 to 5
for(i in 1:5){
  print("Hello R")
}
#this prints out "Hello R" five times


for(i in 5:10){
  print("Hello R")
}
#this prints out "Hello R" six times

for(i in 5:10){
  print(i*i)
}
#this prints out the square of i


for(i in 5:10){
  print(sqrt(i))
}
#this prints out the squart root of 5, then 6, then 7 etc. Note! The sqrt must be inside the print function (not on separate lines)

#the "if" statement

# ---- -2 ---- -1 ---- 0 ---- 1 ---- 2 ----

#generate a random number from a normally distributed set of numbers (normal distribution is a common probability distribution, with a shape known as a "bell curve", it is always symmetrical about the mean)
#from the the above sequence, if the the curve is normally distrubuted with a mean of 0, a randomnly selected value has the highest probability of being "0"

rnorm(n, mean=0, sd=1) #these are the default paramaters (which match the sequence above!)
rnorm(1) #this generates a random number from the above distribution

x <- rnorm(1) #assigns a random value to x

#different from the for loop, this does not run many times, it runs once!
if (x>1){
  answer <- "Greater than 1"
} 
#this will check if x is greater than 1, if it is, it assigns "Greater than 1" to the answer, but if it isn't, it doesn't do anything

rm(answer) #removes value from the variable

#the "else" statement  
#happens if the main body of the "if" function is not true

x <- rnorm(1)
if (x>1){
  answer <- "Greater than 1"
} else{
  answer <- "Less than or equal to 1"
}

#the "if else" statement - this is called nesting functions
# this nests another if function in the else function, so you can do another check! this is a nested ifelse statement
#this is not best practice, as it's very cumbersome

x <- rnorm(1)
if (x>1){
  answer <- "Greater than 1"
} else{
  
  if(x>=-1){
    answer <- "Between -1 and 1"
  } else {
    answer <- "Less than -1"
  }
  
}

#this is the same as above but doing the checks in a different order
x <- rnorm(1)
if (x>1){
  answer <- "Greater than 1"
} else{
  
  if(x<=-1){
    answer <- "Less than -1"
  } else {
    answer <- "Between - 1 and 1"
  }
  
}

#check with Tom - why doesn't this work?!!!
x <- rnorm(1)
if (x>1){
  answer <- "Greater than 1"
} else{
  
  if(x< -1){ #must have a space before the minus
    answer <- "Less than -1"
  } else {
    answer <- "Between - 1 and 1"
  }
  
}

#"else if" - this is called chaining statements
#it's a much more efficient

x <- rnorm(1)
if (x>1){
  answer <- "Greater than 1"
} else if(x>=-1){
  answer <- "Between -1 and 1"
} else {
  answer <- "Less than -1"
}

