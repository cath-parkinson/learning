library(stringr)
library(tidyverse)

# none of this worked to get the input data in the required format!

# data <- read.csv("data-raw/day4_input.txt",
#                  header = FALSE, sep = '\t', blank.lines.skip = F)
# data <- read.table("data-raw/day4_input.txt",
#                  header = FALSE, sep = "\r", blank.lines.skip = F, fill = TRUE)
# data <- read.delim("data-raw/day4_input.txt",
#                    header = FALSE, sep = "\n", allowEscapes = T)
# 
# this eventually worked ,but then requires some manipulation
data <- scan("data-raw/day4_input.txt", what = "character", blank.lines.skip = F)

create_list <- function(x){
  
  v <- cut_data(x)
  v <- v[!(v == 0)]
  x <- x[!(x == "")]
  list <- list()
  for(i in 1:max(v)){
    list[[i]] <- x[v == i]
    
  }
  return(list)
}

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

# finally have data in a list as needed
list <- create_list(data)
v <- unlist(list)

fields <- unique(str_sub(v, 1,4))
fields <- fields[!fields %in% "cid:"]

test <- lapply(list, str_sub, 1,4)
mytest <- function(x){
  
  v <- c()
  for(i in 1:length(x)){
   
    v[i] <- sum(fields %in% x[[i]]) 
    
  }
  return(v)
}

sum(mytest(test) == 7)

# part2: add validation checks 
list_complete <- list[mytest(test) == 7]
list_complete <- lapply(list_complete, sort)

check_birth <- sapply(list_complete, function(x){
  
  x <- x[grepl("byr:", x)]
  x <- gsub("byr:", "", x)
  x <- as.numeric(x)
  x <- (x >= 1920 & x <= 2002)
})

check_issueyear <- sapply(list_complete, function(x){
  
  x <- x[grepl("iyr:", x)]
  x <- gsub("iyr:", "", x)
  x <- as.numeric(x)
  x <- (x >= 2010 & x <= 2020)
})

check_expyear <- sapply(list_complete, function(x){
  
  x <- x[grepl("eyr:", x)]
  x <- gsub("eyr:", "", x)
  x <- as.numeric(x)
  x <- (x >= 2020 & x <= 2030)
})

check_height <- sapply(list_complete, function(x){
  
  x <- x[grepl("hgt:", x)]
  x <- gsub("hgt:", "", x)
  if(grepl("cm", x)){
    x <- gsub("cm", "",x)
    x <- as.numeric(x)
    x <- (x >=150 & x <= 193)
  } else if(grepl("in", x)){
    x <- gsub("in", "",x)
    x <- as.numeric(x)
    x <- (x >=59 & x <= 76)
  } else { x <- FALSE}
})

check_haircolour <- sapply(list_complete, function(x){
  
  x <- x[grepl("hcl:", x)]
  x <- gsub("hcl:", "", x)
  x <- str_detect(x, "\\#[[:xdigit:]]{6}")
  
})

eyecolour <- c("amb", "blu", "brn", "gry", "grn", "hzl", "oth")

check_eyecolour <- sapply(list_complete, function(x){
  
  x <- x[grepl("ecl:", x)]
  x <- gsub("ecl:", "", x)
  x <- x %in% eyecolour
  
})

check_pid <- sapply(list_complete, function(x){
  
  x <- x[grepl("pid:", x)]
  x <- gsub("pid:", "", x)
  x <- str_detect(x, "[[:digit:]]{9}") & str_length(x) ==9
  
})

matrix <- cbind(check_birth, check_issueyear, check_expyear, check_height, check_haircolour,
                check_eyecolour, check_pid)

sum(apply(matrix, 1, sum)==7)

