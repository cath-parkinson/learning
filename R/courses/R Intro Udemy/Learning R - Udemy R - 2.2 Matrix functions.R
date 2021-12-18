#Matrix operations

test <- round(FieldGoals / Games,1) #work out the number of goals scored per game per player, round to the nearest 1 decimal
test["DerrickRose", "2012"] <- 0 #reassign the "NaN" value as a 0, so that you can computate 
max(test) #this now returns the highest goals per player - how do I get it to tell which values it corresponds to?
test
mean(test) #ask Tom - how do I get the mean for just KobeBryant!!
mean(test[1])
rowMeans(test) #this shows you the mean for each player across all years. Can also do colmeans

#visualising matrices
matplot(FieldGoals) #it works by plotting columns! so you may need to transpose your data (flip the rows and columns)
matplot(t(FieldGoals/Games), type = "b", pch=15:18, col=c(1:4,6)) #type b is a line chart, "pch" are the shape of the data points, col is a colour vector
legend("bottomleft", inset = 0.01, legend = Players, pch=15:18, col=c(1:4,6), horiz = F) #add a legend to your chart - where do you want it, how much will it be inset by, and where does the information come from (must be a vector)
?legend

#Salary per point
Salaryt <- t(Salary)
Pointst <- t(Points)
matplot(Salaryt[,1]/Pointst[,1], type = "b", pch=15:18, col=c(1:4,6)) #zoom in on Kobe Bryant who got an astromical salary for just 83 points in 2013!

#Points per game
matplot(t(Points/Games),type = "b", pch=15:18, col=c(1:4,6))

#Points per Minutes played
matplot(t(Points/MinutesPlayed),type = "b", pch=15:18, col=c(1:4,6))

#Subsetting - very important, something a lot of people get wrong

#with a vector
x <- c("a", "b", "c", "d", "e")
x
x[c(1,5)] #extract multiple values from a vector
x[1] #this is subsetting a vector "x"

#with a matrix
Games
Games[1:3, 6:10] #when you want rows that are next to each other
Games[c(1,10),1:9] #when you want rows that are not next to each other
Games["KobeBryant",]#gets you just kobes' games, but without the row names
is.matrix(Games["KobeBryant"]) #however this does not produce another matrix
is.vector(Games["KobeBryant"]) #it's producing a vector - because R guesses that you want a vector
Games["KobeBryant", ,drop=F] #and that's because its default setting is DROP=T so it's dropping any "unuseful" dimensions from the code (this is a secret element!)
#so remember when you're using the square brackets that R is going to guess what you want

#more visualising (but with subsetting)
matplot(t(MinutesPlayed[1:3,]), type = "b", pch=15:18, col=c(1:4,6)) #run with just the first 3 players
legend("bottomleft", inset = 0.01, legend = Players[1:3], pch=15:18, col=c(1:4,6), horiz = F) #and adjust the legend
MinutesPlayed

#SO when you try to just run with 1 player- the square brackets produce a vector, instead of matrix so the matlab doesn't work, therefore you need to force it to remain as a matrix!
matplot(t(MinutesPlayed[1, ,drop=F]), type = "b", pch=15:18, col=c(1:4,6)) #run with just one player
legend("bottomleft", inset = 0.01, legend = Players[1], pch=15:18, col=c(1:4,6), horiz = F) #you don't need to adjust the legend code because the code is looking for a vector



