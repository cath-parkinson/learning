library(stringr)
library(tidyverse)

data <- read.csv("data-raw/day5_input.txt",
                 header = FALSE)

data <- data$V1
rows <- str_sub(data,1,7)
seats <- str_sub(data,8,10)
v <- seq(0,127, by = 1)

# cannot do function on string! so need to break string up into a vector
rows <- str_split(rows, "")
seats <- str_split(seats, "")
test <- c("F", "B", "F", "B", "B", "F", "F")

calculate_rows <- function(x){
  
  v <- seq(0,127, by = 1)
  
  for(i in 1:length(x)){
    
    n <- length(v)/2
    sub <- c(rep(F, n), rep(T,n))
    if(x[i] == "B") { v <- v[sub] } else { v <- v[!sub] }
  }
  return(v)
}

rows <- unlist(lapply(rows, calculate_rows))

calculate_seats <- function(x){
  
  v <- seq(0,7, by = 1)
  
  for(i in 1:length(x)){
    
    n <- length(v)/2
    sub <- c(rep(F, n), rep(T,n))
    if(x[i] == "R") { v <- v[sub] } else { v <- v[!sub] }
  }
  return(v)
}

seats <- unlist(lapply(seats, calculate_seats))

final <- (rows*8) + seats
max(final)

# what is my seat?
sequence <- seq(1, 944, by = 1)
sequence[!sequence %in% final]





