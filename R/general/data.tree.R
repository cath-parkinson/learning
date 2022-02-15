library(data.tree)
# basics

# make tree 
acme <- Node$new("Acme Inc.")
accounting <- acme$AddChild("Accounting")
software <- accounting$AddChild("New Software")
standards <- accounting$AddChild("New Accounting Standards")
research <- acme$AddChild("Research")
newProductLine <- research$AddChild("New Product Line")
newLabs <- research$AddChild("New Labs")
it <- acme$AddChild("IT")
outsource <- it$AddChild("Outsource")
agile <- it$AddChild("Go agile")
goToR <- it$AddChild("Switch to R")

print(acme)

acme$children[[1]]

# convert to dataframe
df1 <- ToDataFrameTree(acme, "level")  # show in app
df2 <- ToDataFrameNetwork(acme, "level") 
df3 <- ToDataFrameTypeCol(acme, "level") # save down

# make tree from datatable

library(treemap)
data(GNI2014)

GNI2014$pathString <- paste("world", 
                            GNI2014$continent, 
                            GNI2014$country, 
                            sep = "/")

population <- as.Node(GNI2014)
print(population, "iso3", "population", "GNI", limit = 20)

population

