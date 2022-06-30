library(pdftools)
library(dplyr)


# functions -----------------------------------------

# get table
# identify column types
# get lines that cross two rows, into the same line e.g. if n < 1


dedup_data <- function(df){
  
  df <- df %>% filter(y >= 343 & y <= 562) %>% 
    mutate(cost = if_else(grepl("\\.\\d\\d$", text), TRUE, FALSE)) %>% 
    mutate(code = if_else((grepl("[[:upper:]]{3}\\d{2,}", text) & x == 69), TRUE, FALSE)) %>% 
    mutate(cost_F = if_else(grepl("F{,1}", text) & nchar(text) == 1, TRUE,FALSE))
  
  change <- df %>% group_by(y) %>% summarise(n = n(), 
                                             count = sum(cost)) %>% 
    mutate(lag_y = lag(y, 1))%>% 
    filter(count == 0) %>% select(-n, -count)
  
  df_keep <- df %>% filter(!(y %in% change$y))
  df_change <- df %>% filter(y %in% change$y)
  
  df_change <- df_change %>% left_join(change, by = "y") %>% 
    mutate(y = lag_y) %>% 
    select(-lag_y)
  
  df <- bind_rows(df_keep, df_change)
  
  check <- df %>% group_by(y) %>% summarise(count = sum(code))
  
  df <- df %>% left_join(check, by = "y") %>% 
    filter(count == 1) %>% 
    select(-count)
  
  return(df)
  
}


# convert into final table 

make_table <- function(df) {
  
  list <- list()
  
  rows <- df %>% select(y) %>% distinct() %>% pull()
  
  code <- c()
  description <- c()
  cost <- c()
  cost_f <- c()
  
  for (i in 1:length(rows)) {
    
    code[i] <- df %>% filter(y == rows[i]) %>%
      filter(code == TRUE) %>%
      select(text) %>%
      pull()
    
    cost[i] <- df %>% filter(y == rows[i]) %>%
      filter(cost == TRUE) %>%
      select(text) %>%
      pull()
    
    
    # look for F
    
    count <- df %>% filter(y == rows[i]) %>% select(cost_F) %>% pull()
    
    if (sum(count) > 0) {
      
      cost_f[i] <- "F"
      
    } else { cost_f[i] <- "" }
    
    
    vector_desc <- df %>% filter(y == rows[i]) %>%
      filter(code == FALSE & cost == FALSE & cost_F == FALSE) %>%
      select(text) %>%
      pull()
    
    description[i] <- paste0(vector_desc, collapse = " ")
    
  }
  
  df <- tibble(code = code,
               description = description,
               cost = cost,
               cost_f = cost_f)
  
  df <- df %>% mutate(cost = as.numeric(cost))
  
  return(df)
  
}

pdf_to_table <- function(files_all){
  
  list_final <- list()
  
  for(i in 1:length(files_all)){
    
    files <- files_all[i]
    
    # pdf <- pdf_text(files)
    data <- pdf_data(files)
    
    list <- lapply(data, dedup_data)
    # automate subsetting list if df is empty
    list <- list[!lapply(list, nrow) == 0]
    list <- lapply(list, make_table)
    
    df <- bind_rows(list)
    
    df <- df %>% mutate(cost = cost*1.2)
    
    list_final[[i]] <- df
    
  }
  
  df <- bind_rows(list_final, .id = "id")
  
  return(df)
  
}



