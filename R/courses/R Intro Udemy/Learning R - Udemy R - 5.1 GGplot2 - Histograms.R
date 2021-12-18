#ggplot - histograms!

s <- ggplot(data=movies, aes(x=BudgetMillions)) 
s + geom_histogram(binwidth = 10)

#add colour
#this gives you the outline only!
s + geom_histogram(binwidth = 10, colour = "Red")
s + geom_histogram(aes(colour = Genre), binwidth = 10) 
#this fills the colour of a histogram
s + geom_histogram(binwidth = 10, fill="Red")
s + geom_histogram(aes(fill = Genre), binwidth = 10) 
#and this adds a border!
s + geom_histogram(aes(fill = Genre), binwidth = 10, colour = "White") 

#density plots
s + geom_density(aes(fill = Genre), position= "stack")

#starting layer tips
#version 1 - sets more information in the object, so you don't have to keep typing it out every time  
t <- ggplot(data = movies, aes(x=AudienceRating))
t + geom_histogram(binwidth = 10, fill = "White", colour = "Purple")

#version 2 - gives you more flexibility, for example if you're exploring the data
t <- ggplot(data=movies)
t + geom_histogram(binwidth = 10, 
                   aes(x=AudienceRating),
                   fill = "White", colour = "Purple")

#using facets!
#creates lots of charts
v <- ggplot(data=movies, aes(x=BudgetMillions))
#use facet grid - you need to put "Genre" in the rows, and then "." for the columns (which means nothing)
v + geom_histogram(binwidth = 10, aes(fill=Genre), colour = "Black") + 
  facet_grid(Genre~., scales = "free")
#this is exactly the same but flipping the rows and columns
v + geom_histogram(binwidth = 10, aes(fill=Genre), colour = "Black") + 
  facet_grid(.~Genre, scales = "free")

#adding in themes!
o <- ggplot(data=movies, aes(x=BudgetMillions))
#adding in an x-label
h <- o + geom_histogram(binwidth = 10, aes(fill = Genre), colour = "White")
h + xlab("Budget (millions)") + ylab("Frequency density")
#axis title formatting
h + xlab("Budget (millions)") + ylab("Frequency density") +
  theme(axis.title.x = element_text(colour = "Dark Green", size = 30), axis.title.y = element_text(colour = "Red", size = 30))
#axis formatting - colour, and size of labels and titles
h + xlab("Budget (millions)") + ylab("Frequency density") +
  theme(axis.title.x = element_text(colour = "Dark Green", size = 30), 
        axis.title.y = element_text(colour = "Red", size = 30), 
        axis.text.x = element_text(size = 20),
        axis.text.y = element_text(size = 20))
#legend formatting
h + xlab("Budget (millions)") + ylab("Frequency density") +
  ggtitle("Movie Budget Distribution") +
  scale_fill_brewer(palette = "Set1") +
  theme(axis.title.x = element_text(colour = "Dark Blue", size = 15, family="Calibri"), 
        axis.title.y = element_text(colour = "Dark Blue", size = 15, family = "Calibri"), 
        axis.text.x = element_text(size = 8, colour = "Dark Blue"),
        axis.text.y = element_text(size = 8, colour = "Dark Blue"), 
        legend.justification = c(1,1),
        legend.position = c(.9,.9),
        legend.text = element_text(size = 8, family = "Calibri"),
        legend.direction = "horizontal", 
        plot.title = element_text(colour = "Dark Blue", 
                                  size = 40, 
                             family="Calibri"))

#installing extra fonts!
install.packages("extrafont")
library(extrafont)
font_import()
fonts()
loadfonts(device = "win")

#installing extra colours!
library(RColorBrewer)
#bring up the different colour palettes
display.brewer.all()
