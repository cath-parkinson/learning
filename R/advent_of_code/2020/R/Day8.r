library(stringr)
library(tidyverse)

# read in and process data ####
data <- read.csv("data-raw/day8_input.txt",
                 header = FALSE, sep = " ")

colnames(data) <- c("op", "arg")
# need a while loop

x <- data$op
y <- data$arg

# part 1 - run code

run_boot <- function(x,y){
  
  val <- 0
  ran <- rep(0,length(x))
  i <- 1
  # use a while loop to manually implement a for loop so I can change i
  # NB the order of checking the conditions in while loop matters
  while((i <= 656  & i > 0) & ran[i] == 0){
    
    if(x[i] == "jmp"){
      
      ran[i] <- ran[i] + 1
      i <- i + y[i]
      
    } else if (x[i] == "acc"){
      
      val <- val + y[i]
      ran[i] <- ran[i] + 1
      i <- i + 1
      
    } else if(x[i] == "nop"){
      
      ran[i] <- ran[i] + 1
      i <- i + 1
    } 
    # print(i)
    # print(val)
    # print(ran)
    
  }
  # can only call return once - put in same list!
  return(list(i, val, ran))
}

output <- run_boot(x,y)


# part 2 - test changing 1 element of the code each time


fix_boot <- function(x,y){
  
  original_x <- x
  j <- 1
  output[[1]] <- 1
  while(output[[1]] <= 656 & output[[1]]>0 & j <= 656){
    
    if(x[j] == "jmp"){
      
      x[j] <- "nop"
      
    } else if(x[j] == "nop"){
      
      x[j] <- "jmp"
      
    } else if (x[j] == "acc") {
      
      x[j] <- "acc"
    } 
    
    print(j)
    output <- run_boot(x,y)
    x <- original_x
    print(output[[1]])
    j <- (j + 1)
  }
  
  return(list(output, j, x, original_x))
}

look <- fix_boot(x,y)
