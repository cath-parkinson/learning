# Multiple rows at a time ---------------------------------------


nrow <- 10
DF <- data.frame(a = 1:nrow, b = abs(rnorm(nrow)), c = abs(rnorm(nrow)))


getrowfromDF <- function(row_number) {
  return(DF[row_number,])
}

putrowintoDF <- function(rowdf, row_number) {
  
  # Each loop is going over a column
  for (i in 1:ncol(DF)) {
    # This needs to be super assigned - otherwise it would just update the table inside the function
    # and we'd need to return it 
    DF[row_number,i] <<- rowdf[,i] # I just needed to change this to accept a vector - and how this will change all the rows!
    print(DF)
  }
}


getrowfromDF(c(1,3,5)) 
my_updated_row <- getrowfromDF(c(1,3,5)) %>% dplyr::mutate(a = c(1,2,3),b=c(1,2,3), c=c(1,2,3))

putrowintoDF(my_updated_row, c(1,3,5))

my_updated_row[,3]
DF[c(1,3,5), 3]





