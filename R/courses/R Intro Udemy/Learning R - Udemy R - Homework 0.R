#homework 

# ---- -2 ---- -1 ---- 0 ---- 1 ---- 2 ----

#generate a random number from a normally distributed set of numbers (normal distribution is a common probability distribution, with a shape known as a "bell curve", it is always symmetrical about the mean)
#from the the above sequence, if the the curve is normally distrubuted with a mean of 0, a randomnly selected value has the highest probability of being "0"

#we want to prove that as n tends to infinity, 68.2% of numbers will fall between -1 and 0

#work in progress
#checking that it's working (by printing n)
x <- 0
nmax <- 10
for (i in 1:nmax){
  n <- rnorm(1)
  print(n)
  if((n<=1)&(n>-1)){
    x <- x+1
  }
}
answer = x /nmax

#run with increasingly large n
x <- 0
nmax <- 10000000
for (i in 1:nmax){
  n <- rnorm(1)
  if((n<=1)&(n>-1)){
    x <- x+1
  }
}
answer = x /nmax

#this prints the answer out after each iteration, so you can see it converging on 0.68 as n increases
x <- 0
a <- 1
while(a<100){
  for (i in 1:a){
  
    n <- rnorm(1)
    if((n<=1)&(n>-1)){
      x <- x+1
    }
    answer = x /a
    print(answer)
  }
  a <- a+1
}

#runs it many many times, and prints out answer at the end, closest I've got is 0.682776
#prints out after every 10th power 

l <- 10
  
while(l<1e09){

  x <- 0
  a <- 1
  
  while(a<l){
    n <- rnorm(1)
    if((n<=1)&(n>-1)){
      x <- x+1
    }
    a <- a+1
  }
  answer <- x /a
  print (paste ("n=",a,"answer=", answer))
  l <- l*10
}

#workings
#check that n is between 1 and -1
n <- rnorm(1)
n
(n<=1)&(n>-1)


#this prints out 10 randomly generated numbers
x <- 1
nmax <- 10
for (i in 1:nmax){
  print(rnorm(1))
  }

#adds 1 to x if n is less than 1, does nothing if not
n <- rnorm(1)
x <- 0
if(n<1){
  x <- x+1
}

#delivers answer but using vectors, rather than being purely reliant on loops
l <- 10
while(l<1e8){
  
  sample1 <- rnorm(l) #creates a vector of length l
  cond1 <- sample1 < 1 #creates another vector cond1, which for each element, is true, if the corresponding value is less than 1. 
  cond2 <- sample1 > -1 #another vector this time, based on a different condition
  cond3 <- cond1 & cond2 #another vector, created based on the corresponding values in cond1 and cond2 both being TRUE 
  #sum(cond3) - this was key, handy way of counting the number of TRUEs - becuase r stores TRUEs as 1s,and FALSEs as 0s
  #length(cond3) - this gives you the length of a vector
  answer <- sum(cond3)/length(cond3)
  print (paste ("n=",l,"answer=", answer)) #you need print here, because it's in a loop
  l <- l*10
}

#KIRRIL'S answer

#uses a different way of setting up the for loop available in r, you can use i. You basically get a vector of n variables, and i becomes the variable itself, so it cycles through all the variables,  up to rnorm(n). This is key and different from other programming languages!
#not sure I understand this!!!
n <- 10000
x <- 0
for(i in rnorm(n)){
  if((i<=1)&(i>-1)){
    x <- x+1
  }
}
answer <- x /n

#added the while loop into kirril's answer!
l <- 10
while(l<1e06){
    x <- 0
    for(i in rnorm(l)){
    if((i<=1)&(i>-1)){
      x <- x+1
    }
    }
    answer <- x /l
    print(paste("answer=",answer,"sample size=",l))    
    l <- l*10
}


