# Using data.table when things need to happen quickly
# Can be x10 quicker than dplyr

# Create data.table
df <- data.table(fruit = c("apple", "apple", "banana", "banana", "pear", "pear"),
                 metric = c("weight", "height", "weight", "height", "weight", "height"),
                 value = c(150, 9, 200, 3, 170, 12))

# or you can use as.data.table

# dcast pivots wider
df1 <- data.table::setorder(data.table::dcast(df, 
                                              fruit ~ metric), -height)
# melt pivots long
df2 <- data.table::melt(df1,
                        id.vars = "fruit",
                        measure.vars = c("height", "weight") ,
                        variable.name = "metric")

# splits df by metric and stores each of the resulting data.tables as a element of a list
split(df2, by = "metric")