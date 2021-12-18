library(stringr)
library(tidyverse)

# read in and process data ####
data <- read.csv("data-raw/day7_input.txt",
                 header = FALSE, sep = ".")
data$V2 <- NULL
data <- data$V1 
# list <- split(data, seq(data))
colour <- str_extract(data, "[:alpha:]+ [:alpha:]+")

list <- str_extract_all(data, "[:digit:] [:alpha:]+ [:alpha:]+")
rm(data)

format_rules_num <- function(x){
  
  x <- unlist(str_extract_all(x, "[:digit:]"))
  x <- as.numeric(x)
  
}

list_num <- lapply(list, format_rules_num)

format_rules_colour <- function(x){
  
  x <- unlist(str_extract_all(x, "[:alpha:]+ [:alpha:]+"))
  
}

list_colour <- lapply(list, format_rules_colour)

# part 1 calculations ####

# final 
names(list_colour) <- colour
names(list_num) <- colour
names(list) <- colour

# need to get this into a loop
# we need a while loop - because we don't know how many times we'll go around

# loop over the list, testing a different subset of colours
# create a vector containing all the colours

goldbag_test <- function(x,y){
  
  result <- lapply(x, function(i){ 
    if(length(i) > 0) { 
      
      if(sum(y %in% i)>0){ TRUE } else { FALSE }
    }
    else { FALSE }
  } ) 
  
  result <- unlist(result)
  
}

goldbags <- function(x){
  
  final_colours <- "shiny gold"
  previous_colours <- c()
  while(!(length(final_colours) == length(previous_colours))) {
    
  answer <- goldbag_test(x, final_colours)
  answer <- names(x)[answer]
  previous_colours <- final_colours
  final_colours <- union(final_colours, answer)
  # print(final_colours)
  # print(previous_colours)
  }
  return(final_colours)
}

list_colour_condensed <- list_colour[!sapply(list_colour, length) == 0]
goldbags(list_colour_condensed)


# try out a small while loop!
# counter <- 1 #assigns 1 to the value counter
# v <- c()
# while (counter < 12){ #checks if counter is less than 12
#   v <- union(v,counter)
#   counter <- counter + 1 #it then adds 1 to the counter value, then returns the start, where counter is now 2! And so on
#   print(v)
# }


# no other bags
# data[is.na(str_extract(data, "[:digit:]"))]

# part 2! calculations #####

# first put my list of colours into a helpful form
# where each colour is repeated the number of times it is needed

format <- function(x,y) {
  vec <- c()
  for(i in 1:length(x)){
    
    answer <- rep(x[i], y[i])
    vec <- c(vec, answer)
    
  }
  return(vec)
}


format_list <- function(x,y){
  
  final_list <- list()
  for(i in 1:length(x)){
    
    colour <- x[[i]]
    num <- y[[i]]
    
    final_list[[i]] <- format(colour, num)
    
  }
  names(final_list) <- names(list_colour)
  return(final_list)
}

final_list <- format_list(list_colour, list_num)

# create functions

# not ready to use 
goldbag_count <- function(x,y){
  
  final <- c()
  for (i in 1:length(y)){
    
    answer <- (names(x) %in% y[i])
    answer <- unlist(x[answer])
    final <- c(answer, final)
    names(final) <- NULL
    
  }
  
  return(final)
}

goldbag_count(final_list, c("shiny gold" , "striped grey"))



goldbags_count_bags <- function(x){
  
  final_colours <- c() 
  previous_colours <- "shiny gold"
  while(!(length(previous_colours) == 0)){
    
    answer <- previous_colours
    # this needs to be a loop because I'm not capturing multiple colours!
    # can I use gold bag test above?
    # do a separate function for this so it's easier to read
    # needs to run over every element of the vector and output a new character vector of colours at the end
    answer <- goldbag_count(x,answer)
    print(answer)
    previous_colours <- answer
    final_colours <- c(final_colours, answer)
    
  }
  return(final_colours)
}

length(goldbags_count_bags(final_list))
answer <- goldbags_count_bags(final_list)

