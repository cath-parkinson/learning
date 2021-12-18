#ggplot2

#load in data
movies <- read.csv(file.choose())
head(movies)
str(movies)

#starting with data -check everything is set up how you want it
#change the column names
colnames(movies) <- c("Film", "Genre","CriticRating", "AudienceRating", "BudgetMillions", "Year")
summary(movies)
#change year from a numeric to a categoric variable (factors)
movies$Year <- factor(movies$Year)
#visualise data - version 1
ggplot(data=movies, aes(x = CriticRating, y = AudienceRating, colour = Genre, size = BudgetMillions)) + 
  geom_point() 

#plotting with layers
#understanding how ggplot works
#ggplot is creating an object, for example...
p <- ggplot(data=movies, aes(x = CriticRating, y = AudienceRating, colour = Genre, size = BudgetMillions))
#then you can layer on geometries
p + geom_point()
p + geom_line() 
#the order you layer is important - this will add the lines, then the points on top
p + geom_line() + geom_point()

#overriding
#using layers, you can overide what has been set 
#overriding size
q <- ggplot(data=movies, aes(x= CriticRating, y = AudienceRating, colour = Genre, size = BudgetMillions))
q + geom_point(aes(size = CriticRating))
#overriding colour
q + geom_point(aes(colour = BudgetMillions))
#however q always remains the same, you're not changing the object
#overriding x or y - however be careful it doesn't change the x-axis label...
q + geom_point(aes(x = BudgetMillions)) 
#...you'll need to add that in yourself 
q + geom_point(aes(x = BudgetMillions)) + xlab("Budget Millions")
#reduce line size - note you don't need to say "aes"
#this is the difference between "mapping" which is saying "aes"
#and setting where you are not
q + geom_line(size=1) + geom_point()

#mapping vs. setting
#adding colour
r <- ggplot(data=movies, aes(x=CriticRating, y = AudienceRating))
r + geom_point()
#two very different ways of doing this!
#mapping colour to your variable
r + geom_point(aes(colour = Genre))
#setting your variable as a colour
r + geom_point(colour = "DarkGreen")
#THIS PRODUCES AN ERROR, it's pink with a legend!!
#that's because you are mapping the colour to a variable (when really you want to set the colour!)
r + geom_point(aes(colour = "DarkGreen"))
#VICE VERSA - this produces an error, you can't set like this
r + geom_point(colour = Genre)

#another example with size
#setting
r + geom_point(size = 1)
#mapping
r + geom_point(aes(size = BudgetMillions))

#statistical transformations!
#adding a trend line (geom_smooth)
u <- ggplot(data=movies, aes(x=CriticRating, y=AudienceRating, colour = Genre))
u + geom_point() + geom_smooth(fill=NA)

#boxplot
u <- ggplot(data=movies, aes(x=Genre, y=AudienceRating, colour = Genre))
u + geom_boxplot(size = 1.2)
u + geom_boxplot(size = 1.2) + geom_jitter()
#add transparency   
u + geom_jitter() + geom_boxplot(size = 1.2, alpha = 0.5)

#using facets!
w <- ggplot(data=movies, aes(x=CriticRating, y=AudienceRating, colour = Genre))
w + geom_point(aes(size = BudgetMillions)) + facet_grid(Genre~Year) +geom_smooth() 
#fix axis so it runs from 0 to 150
w + geom_point(aes(size = BudgetMillions)) + ylim(0,150) + facet_grid(Genre~Year) +geom_smooth() 
#zoom in on axis from 0 to 100
w + geom_point(aes(size = BudgetMillions)) + facet_grid(Genre~Year) +geom_smooth() + coord_cartesian(ylim = c(0,100))

#setting limits
m <- ggplot(data=movies, aes(x=CriticRating, y=AudienceRating, size = BudgetMillions, colour = Genre))
#this removes data that isnt between 0 and 50
m + geom_point() + xlim(50,100) + ylim(50,100)
#this zooms in on the data
m + geom_point() + coord_cartesian(xlim=c(50,100), ylim=c(50,100))

#this is especially important when you're trying to zoom in on histograms!
n <- ggplot(data=movies, aes(x=BudgetMillions))
n + geom_histogram(binwidth = 10, aes(fill=Genre), colour = "White")
n + geom_histogram(binwidth = 10, aes(fill=Genre), colour = "White") + ylim(0,50)
n + geom_histogram(binwidth = 10, aes(fill=Genre), colour = "White") + coord_cartesian(ylim=c(0,50))



