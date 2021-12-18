setwd("C:/Users/Catherine/OneDrive/Documents/R/Advent of code")
data <- read.csv("day3_input.txt",
                 header = FALSE)
library(stringr)

v <- data$V1

# needs to be more than 3*323=969 wide, so 11*100 = 1000
3*323
11*100

# create grid
list <- split(v, seq(v))
list <- lapply(list, rep, 100)
list <- lapply(list, paste0, collapse = "")

# vector telling me which integer I need to look at for each level
c <- seq(1,969, by = 3)

# test for trees
grep("\\.", v[1])
v[1]
str_detect(v[1], "\\.")

substring(v[1], 2,2)

lapply(list, trees, x)

trees <- function(x){
  
  v <- rep(NA, length(list))
  c <- c
  for (i in 1:length(list)){
    
    z <- c[i]
    x <- list[[i]]
    v[i] <- substring(x, z, z)
    v[i]
    
  }
  
    return(v)
  }

final <- trees(list)  
sum(grepl("\\#", final))


# extend to check more slopes
# make the sequence vectors, then can just apply my function over it
# move the data to be in the function! Because I'm using the same hill each time

steps <- c(1,3,5,7,1)

lapply




