#creating a data frame

?data.frame #similar to the cbind() function!
mydf <- data.frame(Countries_2012_Dataset, Codes_2012_Dataset, Regions_2012_Dataset)
#changing the names of the columns (similar to what we did with matrices)
colnames(mydf) <- c("Country", "Code", "Region")

#or you can add in the column names straight away! You don't need to use quotations because of the way the data frame function works
#btw you can also use this functionality in the cbind and rbind
mydf <- data.frame(Country = Countries_2012_Dataset, Code = Codes_2012_Dataset, Region = Regions_2012_Dataset)
head(mydf)
levels(mydf$Codes) #tells you the different levels of a column!

#is the country code data exactly the same?
mydf$Codes == stats$Country.Code
mydf[,2] == stats[,"Country.Code"]

#merging data frames
#you need to match by rows that are the same! So where we have "Aruba" in 1 frame, check for "Aruba" in the new frame, and pass over the new information according
#where x = the stats frame, y is the my df frame, it's going to match on Country.Code is equal to Code
#you can also specify "-1" in the "my df" which tells merge to ignore column 1
merged <- merge(stats, mydf[,-1], by.x = "Country.Code", by.y = "Code")
