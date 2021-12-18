#visualising with q-plot

library(ggplot2)
?qplot
#automatically produces bar plot
qplot(data=stats, x = Internet.users) #Note! You don't have to use the $$$ in the text now, because it knows to look in stats already
#automatically produces a dot plot
qplot(data=stats, x = Income.Group, y = Birth.rate, size = 3)
qplot(data=stats, x = Income.Group, y = Birth.rate, geom = "boxplot") #how do you change the order of the categorical variables along the bottom?
qplot(data=stats, x =Internet.users , y = Birth.rate, size = I(3), colour = I("red")) #make everything red
qplot(data=stats, x =Internet.users , y = Birth.rate, size = I(3), colour = Income.Group) #colour by income group!

#size of points, colour by a variable, and shapes
qplot(data = merged, x = Internet.users, y = Birth.rate, size = I(3), colour = Region, shape = I(19))

#transparency - this is alpha
qplot(data = merged, x = Internet.users, y = Birth.rate, size = I(3), colour = Region, shape = I(19), alpha = I(0.6))

#add a title
qplot(data = merged, x = Internet.users, y = Birth.rate, size = I(3), colour = Region, shape = I(19), alpha = I(0.6), main = "Birth Rate by Internet Users")

