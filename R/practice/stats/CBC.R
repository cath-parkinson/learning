install.packages("bayesm")
library(bayesm)

# create a choice model ofthe conjoint, using hierarchical Bayes (HB) 

# then add that to "predict" along with the scenario you are interested in

?predict

data(bank)

# respondent level data - 946 respondents
# each respondent was presented with between 13-17 paired comparisons (select one or the other)
# so each row is a comparison
# the pairings are labled choice "1" or choice "0"
# if there is a "1" in the column 
choices <- bank$choiceAtt
length((unique(choices$id)))

#columns - id, choice 

#example from package info
cat(" table of Binary Dep Var", fill = TRUE)
print(table(bank$choiceAtt[, 2]))
cat(" table of Attribute Varaibles ", fill = TRUE)
mat <- apply(as.matrix(bank$choiceAtt[,3:16]), 2, table)
print(mat)


# 

if(0) {
  
  choices <- bank$choiceAtt
  demos <- bank$demo
  
  z[ ,1] <- rep(a, nrow(z))
  z[ ,2] <- z[,2] - mean(z[,2])
  z
  
  
}



# this looks like it's still conjoint

install.packages("faisalconjoint")
library(faisalconjoint)

data("mobile_data")
data("mobile_levels")
faisalconjoint(mobile_data, mobile_levels)
