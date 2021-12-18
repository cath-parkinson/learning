#functions
#designed to do repetative things quickly

#you can add "rows" into the function, and then when you run your function, what ever you put in the brackets will go everywhere in your function
#if you set the parameters of "rows" in your function tool, then that's what R will default to if the user doesn't enter any parameters
myplot <- function(data, rows=1:10){
Data <- data[rows, , drop=F] #subsets the data you require based on the rows you need
matplot(t(Data), type = "b", pch=15:18, col=c(1:4,6), xlab = "Seasons") #creates the chart
legend("bottomleft", inset = 0.01, legend = Players[rows], pch=15:18, col=c(1:4,6), horiz = F) #adds the legend
}

myplot(Salary, c(1,5))

#running analysis using our function
myplot(Salary)
myplot(Salary / Games) #consider if annomalies are telling you something useful about the data! You may not want to remove them
myplot(MinutesPlayed)
myplot(Points)
#both these metrics are "skewed" with some players being much lower, simply because they played less games
#therefore if you want to make this "fairer" so all players are being analysed on a level playing field - you can "normalise", and look at the data divided by game
myplot(Points/Games) #so this gets you points per game - it's better but it's still impacted by injuries - because they may have still being playing games when injured
myplot(FieldGoals / FieldGoalAttempts)
myplot(FieldGoalAttempts / Games)
myplot(MinutesPlayed / Games) #this appears to show a decline over time
#therefore we can check if the mean has actuatlly gone down over time, it has!
z <- MinutesPlayed / Games
z
mean(z)
z[1:8,]
colMeans(z[1:8,])
