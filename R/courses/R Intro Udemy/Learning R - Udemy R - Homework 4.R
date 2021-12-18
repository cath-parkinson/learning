#homework 4
library(ggplot2)

movies <- read.csv(file.choose())
head(movies)
str(movies)
summary(movies)
summary(movies$Genre)

#lots of data in this file
#the below metrics are the propotion of the data that came from US vs. Overseas (so they sum to 100%)
movies$Overseas. + movies$Gross...US

#check I can reach that using the data in the columns!
#first need to convert factor vectors into numeric
#if you just do this straight away you don't get the correct values (you get the factor values)
#so first you need to convert to character, and THEN convert to numeric
overseas.vector <- as.numeric(as.character(movies$Overseas...mill.))
US.vector <- as.numeric(as.character(movies$US...mill.))
#check this works
overseas.vector[1:3]
movies$Overseas...mill.[1:3]
#get US percentage out of total - this matches the final column of the data file, so we know this is correct to use!
USprop.vector <- (US.vector / (US.vector + overseas.vector))*100

#boxplot of domestic gross by genre
#as above the data we need is movies$Gross...US
typeof(movies$Genre)
levels(movies$Genre)
#we only want 5 genres

#filter data on the genres we need
movies.5genre.filered <- movies[movies$Genre == "action", ]
movies.5genre.filered <- subset(movies, movies$Genre == "action" | movies$Genre == "drama" | movies$Genre == "comedy" | movies$Genre == "animation" | movies$Genre == "adventure")
#is there a way of doing this quicker using a vector?
genre5 <- c("action", "adventure", "animation", "comedy", "drama")

#Note! Better way of subsetting your data frame
#is to use the %&% logical operator
#this filters on 1 categorical variable
movies.f1 <- movies[movies$Genre == "action", ]
#this filters on lots! it gives a value of TRUE, if the genres match
movies.f1 <- movies[movies$Genre %in% genre5, ]
movies.f2 <- movies.f1[movies.f1$Studio %in% c("Buena Vista Studios", "Fox", "Paramount Pictures", "Sony", "Universal", "WB"), ]

#this does not give us the required data!
ggplot(data=movies.5genre.filered, aes(x=Genre, y=Gross...US)) + geom_boxplot()
ggplot(data=movies, aes(x=Genre, y=Gross...US)) + geom_boxplot()
movies$Genre

#filter data on the genres we need
levels(movies$Studio)
movies.studio.filered <- subset(movies, movies$Studio == "Buena Vista Studios" | movies$Studio == "Fox" | movies$Studio == "Paramount Pictures" | movies$Studio == "Sony" | movies$Studio == "Universal" | movies$Studio == "WB")
summary(movies.studio.filered)

#try the plot again
ggplot(data=movies.studio.filered, aes(x=Genre, y=Gross...US)) + geom_boxplot()

#and then filter on Genre and studio
movies.final.filter <- subset(movies.studio.filered, movies.studio.filered$Genre == "action" | movies.studio.filered$Genre == "drama" | movies.studio.filered$Genre == "comedy" | movies.studio.filered$Genre == "animation" | movies.studio.filered$Genre == "adventure")

#and then plot again - this is now the correct data! 
m <- ggplot(data=movies.final.filter, aes(x=Genre, y=Gross...US))

#change column name of budget, so it pipes into the chart correctly!
colnames(movies.final.filter)[8] <- "Budget $M"
#however this doesn't help - because the space causes problems when we map the variable!
colnames(movies.final.filter)[8] <- "Budget...mill."

#we can now make the aesthetics look like the final version!
#this hides the outliers
m + geom_boxplot(outlier.shape = NA) 
#this makes box plot transparent, and maps the colour and size of the jitter to studio and genre
m + geom_jitter(aes(colour = Studio, size = Budget...mill.), shape = "bullet") + 
  geom_boxplot(outlier.shape = NA, alpha = 0.7)

#add title and axis labels
m + ggtitle("Domestic Gross % by Genre") + 
  geom_jitter(aes(colour = Studio, size = Budget...mill.), shape = "bullet") + 
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  ylab("Gross % US")

#change the label of the legend mapping the size of budget
m + ggtitle("Domestic Gross % by Genre") + 
  geom_jitter(aes(colour = Studio, size = Budget...mill.), shape = "bullet") +
  labs(size="Budget $M") +
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  ylab("Gross % US")

#change the axis titles to be blue, and make title big and centre aligned
m + ggtitle("Domestic Gross % by Genre") + 
  geom_jitter(aes(colour = Studio, size = Budget...mill.), shape = "bullet") +
  labs(size="Budget $M") +
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  ylab("Gross % US") +
  theme(text = element_text(family = "Comic Sans MS"), 
        axis.title = element_text(colour = "Blue", size = 15), 
        plot.title = element_text(size = 20, hjust = 0.5))

#finally fix the fonts to be Comic sans
library(extrafont)
loadfonts(device = "win")






