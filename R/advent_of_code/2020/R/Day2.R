data <- read.csv("data-raw/day2_input.txt",
                 header = FALSE)
v <- data$V1
library(stringr)
# break into three chunks 

# check I can use space as the break point
grep(" ", v)
list <- gregexpr(" ", v)
start <- unlist(list)[ c(TRUE,FALSE) ]
stop <- unlist(list)[ c(FALSE,TRUE) ]

# extract elements needed
count <- substr(v,0,start-1)
letter <- substr(v,start+1, stop-2)
password <- substr(v,stop+1, length(v))

list <- unlist(gregexpr("-", count))
min <- substr(count, 0, list-1)
max <- substr(count, list+1, length(list))
rm(count, list, start, stop)

df <- data.frame(password, letter, min, max)

# test

df <- df %>% mutate(count = stringr::str_count(password, letter),
                    count2 = count(password,letter))
df <- df %>% mutate(min = as.numeric(min), 
                    max = as.numeric(max))
df <- df %>% mutate(test = (count >= min & count <= max))
sum(df$test)

df <- df %>% mutate(e1 = substr(password, min, min),
                    e2 = substr(password, max, max),
                    e1_t = (e1 == letter),
                    e2_t = (e2 == letter),
                    final = e1_t + e2_t)

sum(df$final == 1)


count <- function(x,y){
  
  count = rep(NA, 1000)
  for(i in 1:1000){
    
    count[i] <- str_count(x[i],y[i])
    count[i]
  }
  return(count)
  
}

