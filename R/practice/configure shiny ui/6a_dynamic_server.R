# 6) programmatically create the server elements needed

library(shiny)
library(shinydashboard)
library(tidyverse)
source("R/funcs_config.R")
source("R/mod_home.R")
config <- read_config()

build_mod_server <- function(config){
  
  mapply(function(x,y){ do.call(x, list(y))}, config$server_ui, config$id)
  
}

mod_bbos_server <- function(id, config){
  
  build_mod_server(config)
  
  moduleServer(id, function(input, output, session){})
  
}

# working --------------------------------------------

mod_bbos_server_working <- function(id, config){
  
  home_server("home1")
  home_server("data1")
  home_server("modelling tool1")
  home_server("nesting1")
  home_server("reoptimise1")
  
  moduleServer(id, function(input, output, session){})
  
}
