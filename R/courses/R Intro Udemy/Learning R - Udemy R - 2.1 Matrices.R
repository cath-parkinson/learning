#Matrices

Salary[1,] #call the first row
Salary[,1] #call the first column

MinutesPlayed

#Create a matrix called "Salary"
Salary <- rbind(KobeBryant_Salary, JoeJohnson_Salary, LeBronJames_Salary, CarmeloAnthony_Salary, DwightHoward_Salary, ChrisBosh_Salary, ChrisPaul_Salary, KevinDurant_Salary, DerrickRose_Salary, DwayneWade_Salary)
rm(KobeBryant_Salary, JoeJohnson_Salary, CarmeloAnthony_Salary, DwightHoward_Salary, ChrisBosh_Salary, LeBronJames_Salary, ChrisPaul_Salary, DerrickRose_Salary, DwayneWade_Salary, KevinDurant_Salary)
colnames(Salary) <- Seasons
rownames(Salary) <- Players

#functions for building a matrix
rbind() #creates the matrix
rm() #remove values (like with the sweep!)
colnames() #label the column names of the new matrix 
rownames() #label the row names of the new matrix
r1 <- c("I", "am", "happy")
r2 <- c("What", "a", "day")
r3 <- c("1", "2", "3")
columnnames <- c("col1", "col2", "col3") 
rownames <- c("r1", "r2", "r3")
R <- rbind(r1,r2,r3) #stacks in rows
cbind(r1,r2,r3) #stacks in columns
colnames(R) <- columnnames #this must be a vector!
rownames(R) <- rownames

R["r1","col1"]
#another way of building a matrix (less used)
matrix()
my.data <- 1:20 #create a vector
A <- matrix(my.data,4) #turn the vector into a matrix with 4 rows (see notes)
B <- matrix(my.data, 4, 5, T) #same shape vector, but populating from left to right (instead of down)
B[2,5] #get to the "10"

#named vectors
Charlie <- 1:5 #create a vector
names(Charlie) #check the names of the elements "NULL" means nothing
names(Charlie) <- c("a", "b", "c", "d", "e") #this is weird! we are assigning a vector to a function! R allows you to treat the part on the left as an object
Charlie #this is now a named vector
Charlie["d"]
names(Charlie) <- NULL #this clears the names from a vector

#more practice
temp.vec <- rep(c("a", "b", "zZ"),each=3)
bravo <- matrix(temp.vec,3)
colnames(bravo) <- c("x", "y", "z")
rownames(bravo) <- c("How","Are", "You")
bravo



