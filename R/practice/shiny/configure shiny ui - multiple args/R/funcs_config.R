# configuration function
# to do - in future we'll need functions that check the input for this is correct, and don't let you start the app if not
# to do - git developer needs to be tracked, git user should be ignored

#' description
#'
#' @param path description
#' @return description
#' @examples
#' example

read_config <- function(path = ""){
  
  df_user <- readxl::read_xlsx(paste0(path,"bbos_user_config.xlsx"))
  df_developer <- readxl::read_xlsx(paste0(path,"bbos_developer_config.xlsx"))
  
  # final table
  df <- df_user %>% 
    left_join(df_developer, by = c("module", "version")) %>% 
    filter(required == "Y") %>% 
    select(-version, -required)
  
  return(df)
}
