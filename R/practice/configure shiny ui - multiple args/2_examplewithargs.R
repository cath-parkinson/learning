# 2) break out example with multiple args
library(shiny)
library(shinydashboard)
library(tidyverse)

source("R/funcs_config.R")
source("R/mod_test_01.R")

# amend function to accept list
build_body_tabItems <- function(config) {
  
  build_body_tabItem <- function(x,y,z) { tabItem(tabName = x, do.call(y, z))
    }
  
  # parameter z is now a list! so we dont need to define a list above
  list_tabItems <- mapply(build_body_tabItem,
                          x = config$tabname,
                          y = config$mod_ui,
                          z = config$ui_param,
                          SIMPLIFY = F,
                          USE.NAMES = F)
  
  return(list_tabItems)
  
}

config <- tibble(tabname = c("home", "data"),
                 mod_ui = c("mod_test_01_ui","mod_test_01_ui"),
                 mod_server = c("mod_test_01_server", "mod_test_01_server"),
                 ui_param = list(list("home1"), list("data1")),
                 server_param = list(list("home1"), list("data1"))
)

example <- build_body_tabItems(config)


# amend server function to accept lists - won't run here ---------------

build_mod_server <- function(config){
  
  mapply(function(x,y){ do.call(x, y)}, config$mod_server, config$server_param)
  
}

example <- build_mod_server(config)


