#functions
#think about these as a blender - (a) you put your inputs (fruit) into the (b) function (blender!) 
#they take your inputs, do something to them, and give you an output

dim(a)
typeof(a) #check the type of
sum(a,b) #sum
c() #for numbers
seq() #sequence
rep() #replicate
paste() #for charcters
sqrt() #do the square root
print() #prints out your result (needed in loops)
data() #load your data
is.integer() #check what type of variable it is 
is.character(a) #check what type of variable it is 
is.numeric(a) #check what type of variable it is 
load() #load a package
rnorm()
length(a) #length of a vector

#way of filling an empty vector with random normal numbers
E <- rep(NA,10)
rnorm(E)

seq(from = 1, by = 3, along.with = a) #sequence from 1, increasing by 3 each time, up to the length of vector a
seq(from = 1, by = 3, length.out = 100) #as above, but you specify you want to get a vector of length 100

rep(5:6,times=10)
rep(5:6, each=10)

x <- c(NA, 1)
x
rep(x, each=10)
