# One row at a time ---------------------------------------


nrow <- 10
DF <- data.frame(a = 1:nrow, b = abs(rnorm(nrow)), c = abs(rnorm(nrow)))


getrowfromDF <- function(row_number) {
  return(DF[row_number,])
}

putrowintoDF <- function(rowdf,idx) {
  for (ic in 1:ncol(DF)) {
    # This needs to be super assigned - otherwise it would just update the table inside the function
    # and we'd need to return it 
    DF[idx,ic] <<- rowdf[1,ic]
  }
}

my_updated_row <- getrowfromDF(9) %>% dplyr::mutate(a = 4)


putrowintoDF(my_updated_row, 9)







