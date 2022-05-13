# get list of installed packages
library(tidyverse)

# LIST ----------------------------------

# package_df <- installed.packages() %>% 
#   as.tibble()
# 
# package_df <- package_df %>% filter(is.na(Priority))

make_package_list <- function(){
  
  package_df <- installed.packages() %>% 
    as.tibble()
  
  # remove base R packages and INLA
  package_df <- package_df %>% 
    filter(is.na(Priority)) 
  # %>% 
    # filter(!Package == "INLA")
  
  package_list <- list()
  
  for (i in 1:nrow(package_df)){
    
    package_list[[i]] <- package_df %>% pull(Version) %>% nth(i)
    
  }
  
  names(package_list) <- package_df %>% pull(Package)
  return(package_list)
  
}

package_list <- make_package_list()

# get in format needed for passing to renv.lock file function
test <- list(digest = "0.6.22")

# save ready to use in different project
# pass list to the renv::record() function

saveRDS(package_list, file = "package_list_mt_branch_398_110422.RData")
package_list_check <- readRDS("package_list_mt_branch_398_110422.RData")

# DF -----------------------------------------

make_package_df <- function(){
  
  package_df <- installed.packages() %>% 
    as.tibble()
  
  # remove base R packages and INLA
  package_df <- package_df %>% 
    filter(is.na(Priority)) %>% 
    select(Package, Version)
  # %>% 
  # filter(!Package == "INLA")
  return(package_df)
  
}


package_list <- make_package_df()

