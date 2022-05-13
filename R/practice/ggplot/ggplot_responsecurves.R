dimrets_function <- function(x, a, b){
  b * ( 1 - exp( -x / a ) )
}

library(readxl)
library(dplyr)
library(ggplot2)
library(plotly)

# setwd("R/practice/ggplot")
df <-readxl::read_excel("curves.xlsx")
actual <- df %>% mutate(actual_response = dimrets_function(actual_spend, a,b))

list <- list()
for (i in 1:nrow(df)){
  
  channel_i <- df %>% pull(channel) %>% nth(i)
  a_i <- df %>% pull(a) %>% nth(i)
  b_i <- df %>% pull(b) %>% nth(i)
  max_spend <- df %>% pull(max_spend) %>% nth(i)
  
  x_i <- seq(0,max_spend, by = 1e2)
  response_i <- dimrets_function(x_i,a_i,b_i)
  
  df_i <- tibble(channel = channel_i,
                 spend = x_i,
                 response = response_i)
  
  list[[i]] <- df_i
  
}

plot <- bind_rows(list)

myplot <- plot %>% 
  ggplot(aes(x = spend, y = response)) + 
  geom_line(aes(color = channel)) + 
  scale_y_continuous(
    labels = scales::label_number_si(
      prefix = "$"
    )) + 
  scale_x_continuous(
    labels = scales::label_number_si(
      prefix = "$"
    )) +
  geom_point(data = actual, aes(x = actual_spend, 
                                y = actual_response, 
                                color = channel)) 
ggplotly({
    
    myplot
    
  })
  

