library(tidyverse)

date <- unique(raw_data$ActivityDT)

dates1 <- as.Date(date, "%d/%m/%Y")
dates2 <- as.Date(date, "%Y-%m-%d")

show <- data.frame(date,dates1,dates2)

mydatefunction <- function(v){
  
  if_else(grepl("[0-9]{2}/[0-9]{2}/[0-9]{4}", v),as.Date(v, format = "%d/%m/%Y"),
          if_else(grepl("[0-9]{4}-[0-9]{2}-[0-9]{2}", v), as.Date(v, format = "%Y-%m-%d"),
                  as.Date(v, origin = "1899-12-30")))
}

#### alternatives ####

mydatefunction_long <- function(x){
  
  n = length(x)
  y <- as.Date(integer(length = n), "1899-12-30")
  
  for(i in 1:n){
    
    if(grepl("[0-9]{2}/[0-9]{2}/[0-9]{4}", x[i])){
      
      y[i] <- as.Date(x[i],"%d/%m/%Y")
      y[i]
    } else {
      
      y[i] <- as.Date(x[i], "%Y-%m-%d")
      y[i]
    }
    
  }
  y
}

my_date_function_short <- function(v) {
  date_v <- case_when(grepl("[0-9]{2}/[0-9]{2}/[0-9]{4}", v) ~ as.Date(v, format = "%d/%m/%Y"),
                      grepl("[0-9]{4}-[0-9]{2}-[0-9]{2}", v) ~ as.Date(v, format = "%Y-%m-%d"),
                      TRUE ~ as.Date(NA_integer_, origin = "1899-12-30"))
  
  return(date_v)
}

worked <- mydatefunction(date)

