# Linear regression 
# Again, because I still don't get it

#So for every unit increase in B, FO will increase by 0.9. 
#Therefore for every 10 unit increase in B, FO will increase by 9


B <- seq(1, 200, 1)
FO <- 9.2076 + 0.9014*B

plot(B,FO, "b")

table <- cbind(B,FO)
table <- as_tibble(table)

table <- table %>% mutate(diff = B - FO)

FOtest <- FO[2:200]
FOtest <- c(FOtest, NA)

table <- table %>% mutate(test = FOtest)
table <- table %>% mutate(unit.increase.iny = FOtest - FO)
