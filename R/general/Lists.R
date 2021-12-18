##Lists

#r object, in which you can put elements of different types 
#can store integers, strings, vectors, matrices, data frames, functions or other lists

#create a list using the list function
myvector <- 1:5
mymatrix <- matrix(data=c(1:10), nrow=5, ncol = 2)
mydataframe <- data.frame(x=c(1:5), y=c(6:10))
mylist <- list(myvector, mymatrix , mydataframe)

#you also name elements of your list, when you create it - using either of these methods
mylist <- list(my_vector = myvector, my_matrix = mymatrix, my_dataframe = mydataframe)
names(mylist) <- c("my_vector", "my_matrix", "my_dataframe")

#you can then call the names of your list, and print out your list contents
names(mylist)
print(mylist)

#you can subset a list
#NB. the "[" operator always returns something that's the same class as the original
mylist[2]
mylist[c(2,3)]
mylist[-2]

#access parts of the list
mylist$my_dataframe

#this is the same as extracting single parts of a list
#you do this using the "[[" operator
mylist[[2]]
mylist[["my_dataframe"]]

#and then you can use this operator to subset nested elements of a list
#this gets the third element, of the 1st item in the list
#outputs an integer
mylist[[c(1,3)]]

#this gets the second element, of the second item in the list
#outputs an integer
mylist[[c(2,2)]]

#this gets the first element of the thrid item in the list
#outputs a vector!
mylist[[c(3,1)]]

#this get the second element, of the second column in the data frame (which is the third element in the list)
mylist[[c(3,2,2)]]

#you can merge lists - this creates a list of two lists
anotherlist <- list(numbers = 1:5, message = "hello")
mergedlist <- list(anotherlist, mylist)

#this creates a list of 5 elements
mergedlist2 <- c(anotherlist, mylist)

#in order to apply arithmetic operations on lists, you can convert them into vectors
#creating a names vector
v1 <- unlist(anotherlist)
v2 <- unlist(mergedlist)
v3 <- unlist(mergedlist2)

#you can use subsetting to find NA values
x <- c(1, 2, NA, 4, NA, 5)
y <- c("a", "b", NA, "d", NA, NA)

#tells me where are the NAs
good <- complete.cases(x)

#subset the NAs to get a shorter vector not including any NAs
xgood <- x[good]

#use it to subset data frame to get rid of NAs
#this removes rows with at least 1 NA
df = cbind(x,y)
good <- complete.cases(df)
dfgood <- df[good, ]

##Apply functions

#base r code, you can populate it with functions, to manipulate data in a reptative way
#they allow you to "cross" the data in lots of ways
#and avoid the use of loops
#they act on input lists, matrices, arrays and apply a named function with on or more arguments

#1) apply

#operates on arrays
#this example focuses on 2d objects - matrix
#you specify the object you want to manipulate
#then whether you want to manipulate rows (1) or columns(2), or both (as below)
#then you specify the function to be applied
#NOTE the caps

#use it to convert to character df
chardf <- apply(X=mydataframe, MARGIN=c(1,2), FUN=as.character)

#we can use it to sum over the columns
test <- raw[-1]
sumdf <- apply(mydataframe, 2, sum)

#2) lapply

#operates on lists, and returns a list
#also can be used on dataframes, lists or vectors
#but it always returns a list, of the same length of the original list
A <- matrix(c(1:10), 5,2)
B <- matrix(c(11:20), 5,2)
C <- matrix(c(21:30), 5,2)

mylist <- list(A,B,C)

#this creates a list of 3 integers (each the sum of each matrix)
#we could use this to sum up all elements
extract1 <- lapply(mylist, sum)
sum(unlist(extract1))

#extract the second column from all lists
#the "[" is the "select" operator
#then we want any rows, so we have a blank space, then we want the second column
extract2 <- lapply(mylist, "[", , 2)


x <- c(1,2,3,4,5)
y <- c(10,11,12,13,14,15)
z <- c(5,10,15,20,25)

