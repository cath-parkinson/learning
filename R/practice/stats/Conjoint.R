install.packages("conjoint")
library(conjoint)

# conjoint is a rating / ranking based conjoint - which is not what I need
# I need a choice based conjoint methodology

data(tea)

# tprof is a list of 13 different products, defining what each would be made up of 
# on each screen the respondent was shown the product, and asked to rate it on a scale of 1-10
# tprefm is what each respondent rated each product (which is why there are 13 columns)
# tsimp, is an example simulation (4 products against each other)

#importance of attributes
caImportance(tprefm, tprof)

#matrix of utilities by respondent
caPartUtilities(tprefm, tprof, tlevn)
caTotalUtilities(tprefm, tprof)

#full conjoint output
Conjoint(tprefm, tprof, tlevn, y.type="score")

# Share of preference 

# you give it the simulation (tsimp)
# then the ratings for each product ()
# then a list of what the products were
# so it can join this information together to get the preference

caBTL(tsimp, tpref, tprof)



