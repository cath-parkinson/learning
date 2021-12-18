#homework 3
#analysing free throws - these are awarded after a foal, worth 1 point

#turn the vectors we've been given into matrices
FreeThrows <- rbind(CarmeloAnthony_FT, ChrisBosh_FT, ChrisPaul_FT, DerrickRose_FT, DwayneWade_FT, DwightHoward_FT, JoeJohnson_FT, KevinDurant_FT, KobeBryant_FT, LeBronJames_FT)
?rbind
FreeThrows
#need to apply the names in the right order - alphabetical!
rownames(FreeThrows) <- sort(Players) 
order(FreeThrows)
sort(FreeThrows)
FreeThrows[order(FreeThrows[,1]),] #sort matrix by value in the first column
FreeThrows[order(rownames(FreeThrows)),] #sort matrix in ascending order
colnames(FreeThrows) <- Seasons
rm(CarmeloAnthony_FT, ChrisBosh_FT, ChrisPaul_FT, DerrickRose_FT, DwayneWade_FT, DwightHoward_FT, JoeJohnson_FT, KevinDurant_FT, KobeBryant_FT, LeBronJames_FT)
FreeThrowAttempts <- rbind(CarmeloAnthony_FTA, ChrisBosh_FTA, ChrisPaul_FTA, DerrickRose_FTA, DwayneWade_FTA, DwightHoward_FTA, JoeJohnson_FTA, KevinDurant_FTA, KobeBryant_FTA, LeBronJames_FTA)
rownames(FreeThrowAttempts) <- sort(Players)
colnames(FreeThrowAttempts) <- Seasons
FreeThrowAttempts
rm(CarmeloAnthony_FTA, ChrisBosh_FTA, ChrisPaul_FTA, DerrickRose_FTA, DwayneWade_FTA, DwightHoward_FTA, JoeJohnson_FTA, KevinDurant_FTA, KobeBryant_FTA, LeBronJames_FTA)

#free throw attemts per game
#generally this has been decreasing since 2005, Joe Johnson falls behind all the others. Kevin Durant has been the most consistent in the last decade!
#Games needs to be in the same alphabetical order!
Games <- Games[order(rownames(Games)),]
matplot(Seasons, t(FreeThrowAttempts/Games), type = "b", pch = 15:18, col=c(1:4,6))
legend("bottomleft", inset = 0.01, legend = sort(Players), pch=15:18, col=c(1:4,6), horiz = F) 
FTperGames <- FreeThrows/Games
FTperGames
mean(FTperGames[c(1:8,10),])
colMeans(FTperGames[c(1:10),])
rowMeans(FTperGames)

#accuracy of free throws
#Dwight Howard's accuracy is significnantly lower than the other 9 players. In 2005 Derrick Rose has the best accuracy, but his accuracy has weakened, while Chris Paul has improved
matplot(Seasons, t(FreeThrows/FreeThrowAttempts), type = "b", pch = 15:18, col=c(1:4,6))
legend("bottomleft", inset = 0.01, legend = sort(Players), pch=15:18, col=c(1:4,6), horiz = F) 
rowMeans(FreeThrows/FreeThrowAttempts)

#player playing style (2 point or 3 point preference) i.e. which do they score more of?
#make sure you exclude points from free throws (1 point)
Points #Total (from fieldgoals and free throws)
Points <- Points[order(rownames(Points)),] #need to be in the same order!
FieldGoals <- FieldGoals[order(rownames(FieldGoals)),]
PointsFG <- Points - FreeThrows #field goal points only
FieldGoals.2P <- (3*FieldGoals)-PointsFG #calculate 2 pointers!
FieldGoals.3P <- FieldGoals - FieldGoals.2P #calculate 3 pointers!
FieldGoals.3P + FieldGoals.2P == FieldGoals
Rate.2P <- round((FieldGoals.2P/FieldGoals)*100)
Rate.2P
Rate.3P <- 100 - Rate.2P
Rate.3P
matplot(Seasons, t(Rate.3P), type = "b", pch = 15:18, col=c(1:4,6))
legend("bottomleft", inset = 0.01, legend = sort(Players), pch=15:18, col=c(1:4,6), horiz = F, cex=0.7) 
#the majority score 2 pointers! Around 80% of all goals
#CarmeloAnthony has been improving his % of 3 pointers
#Dwight Howard has the least! 



