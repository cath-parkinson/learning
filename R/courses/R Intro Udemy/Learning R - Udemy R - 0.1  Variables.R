#types of variables

#integer
#an arrow is an assignment integer, the "L" creates an integer of "2". By default r will store your data as double (with decimals)
x <- 2L

#double (numbers with a decimal point)
y <- 2.5

#complex (number that can be expressed in the form a + bi, where a and b are real numbers and i is a solution of the equation x2 = -1. Because no real number satisfies this equation, i is called an imaginary number)
z <- 3 + 2i

#character (1 or characters stored as a string)
a <- "h"

#logical or boolean - can be TRUE (T) or FALSE (F) - must be caps!
q1 <- T
q2 <- FALSE

4 < 5 #output in console will be TRUE
10 > 100 #output in console will be FALSE 
4 == 5 #this is "equals" #output in console will be FALSE

#list of logical operators
# == equal to
# != not equal to
# < less than
# > greater than
# <= less than or equal to 
# >= greater than or equal to
# ! not
# | or
# & and
# isTRUE(x) to check if something is true (you put the variable inside)

result <- (4<5) #assign the result of checking 4 is less than 5 to the value "result"
result #print out the result

typeof(result) #check what type of variable it is! It's a logical variable (true or false)

result2 <- !TRUE #result 2 is not true, therefore it is false
result3 <- !(6<5) #6 is not greater than 5, result3 is the opposite of this

result | result2 #we are checking if at least one of these is true - the answer in the console is TRUE, becuase indeed at least 1 is true
result & result2 #we are checking if both of them are true - the answer is therefore false 

isTRUE(result2) #checks if the value of result 2 is true, the output is true

#general
#"control return" runs your code
#control z undos the last action
#R studio ignores spaces, it excecutes each line of code one after the other
#getwd() tells you where your working directory is, which is where r looks for and stores files


#functions (base r functions)
#check what type of value x is
typeof(a)
#to check the value of an object, just print the name of the object
#squareroot
sqrt(var2)
#create a string of multiple variables
paste(greeting,name)

#examples
A <- 10
B <- 5
C <- A+B
var1 <- 2.5
var2 <- 4
sum(A,B,C) #sums all of the numbers together


result <- var1 / var2
answer <- sqrt(var2)
answer

greeting <- "Hello"
name <- "Bob"
title <- "Mr"

message <- paste(greeting,title, name)
message

#?function in the console gets you the help information (you can also search help)

#"control return" to run 1 line of code (do not need to highlight)
#shift to highlight multiple lines
