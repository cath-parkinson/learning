data <- read.csv("data-raw/day3_input.txt",
                 header = FALSE)
library(stringr)

v <- data$V1

#needs to be more than 3*323=969 wide, so 11*100 = 1000
3*323
11*100

# create grid
list <- split(v, seq(v))
list <- lapply(list, rep, 100)
list <- lapply(list, paste0, collapse = "")

# part 1 ####
# vector telling me which integer I need to look at for each level
c <- seq(1,969, by = 3)

# test for trees
# grep("\\.", v[1])
# v[1]
# str_detect(v[1], "\\.")
# 
# substring(v[1], 2,2)
# 
# lapply(list, trees, x)

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

# part 2 ####


# extend to check more slopes
# make the sequence vectors, then can just apply my function over it
# move the data to be in the function! Because I'm using the same hill each time

steps <- c(1,3,5,7,1)
steps_end <- steps*323

makelist <- function(steps,steps_end){
  
  list <- list()
  for(i in 1:length(steps)){
    
    list[[i]] <- seq(1,steps_end[i], by = steps[i])
    list[[i]]
  }
  
  return(list)
  
}

steps_list <- makelist(steps,steps_end)


trees_2 <- function(x){
  
  map <- list
  final_list <- list()
  
  for (i in 1:length(x)){
    
    v <- rep(NA , length(x[[i]]))
    steps <- x[[i]]
    
    for(j in 1:length(steps)){
      
      map_row <- map[[j]]
      start_stop <- steps[j]
      v[j] <- substring(map_row, start_stop, start_stop)
      v[j]
    
    }
    
    final_list[[i]] <- v
  }
  return(final_list)
} 

final_list <- trees_2(steps_list)
final_list_trees <- lapply(final_list, grepl, pattern = "\\#")
final_list_tress_count <- lapply(final_list_trees, sum)
  
# part 2 - finish ####
# add the element to skip a line if needed

test <- list[c(TRUE,FALSE,TRUE,FALSE,TRUE)]
v <- c("a","b","c")
v[c(TRUE,FALSE,FALSE)]

trees_3 <- function(x, slope){
  
  if(slope == 2){
    map <- list[c(TRUE,FALSE)]
  } else {map <- list}
  
  final_list <- list()
  
  for (i in 1:length(x)){
    
    v <- rep(NA , length(x[[i]]))
    steps <- x[[i]]
    
    for(j in 1:length(map)){
      
      map_row <- map[[j]]
      start_stop <- steps[j]
      v[j] <- substring(map_row, start_stop, start_stop)
      v[j]
      
    }
    
    final_list[[i]] <- v
  }
  return(final_list)
} 

finall1 <- trees_3(steps_list[c(1:4)], 1)
finall2 <- trees_3(steps_list[5], 2)
finallfinal <- c(finall1,finall2)

finallfinal_a <- lapply(finallfinal, grepl, pattern = "\\#")
final_list_tress_count <- lapply(finallfinal_a, sum)
final_v <- unlist(final_list_tress_count)

prod(final_v)

