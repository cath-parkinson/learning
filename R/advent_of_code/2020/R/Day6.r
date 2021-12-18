library(stringr)
library(stringi)
library(tidyverse)
library(un)

data <- "data-raw/day6_input.txt"
data <- scan(data, what = "list", sep = "\r", blank.lines.skip = F,
           fill = F)

cut_data <- function(x){
  
  boolean <- (x == "")
  v <- c()
  s = 1
  
  for(i in 1:length(x)){
    
    if(boolean[i] == FALSE){
      
      v[i] = s } else { 
        
        v[i] = 0
        s = s+1
      }
    
  }
  return(v)
}

create_list <- function(x){
  
  v <- cut_data(x)
  v <- v[!v == 0]
  x <- x[!x == ""]
  list <- list()
  for(i in 1:max(v)){
    list[[i]] <- x[v == i]
    
  }
  return(list)
}

# finally have data in a list as needed
list <- create_list(data)

# get unique list of values
list <- lapply(list, paste, collapse = "")
list <- lapply(list, str_split, pattern = "")

# count them

count_yes <- function(x){
  
  x <- paste(x, collapse = "")
  x <- unlist(str_split(x, ""))
  x <- unique(x)
  x <- length(x)
  return(x)
  
}

count_list <- lapply(list, count_yes)
sum(unlist(count_list))

# part 2 ###

x <- list[[1]]

letters

count_all_yes <- function(x){
  
  answer <- c()
  for (i in 1:length(letters)){
    
    match <- str_detect(x, letters[i])
    if(length(match) == sum(match)){ answer[i] <- T } else { answer[i] <- F}
  }
  
  return(sum(answer))
  
}

count_list <- lapply(list, count_all_yes)
sum(unlist(count_list))
