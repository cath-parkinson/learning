# 5) programmatically create the item list needed for body

library(shiny)
library(shinydashboard)
library(tidyverse)
source("R/funcs_config.R")
source("R/mod_home.R")
config <- read_config()

build_body_tabItems <- function(config) {
  
  build_body_tabItem <- function(x,y,z) { 
    
    tabItem(tabName = x, do.call(y, list(z)))}

  list_tabItems <- mapply(build_body_tabItem,
                          x = config$tabname,
                          y = config$mod_ui,
                          z = config$id,
                          SIMPLIFY = F,
                          USE.NAMES = F)
  
  return(list_tabItems)

}

body_test <- dashboardBody(
  
  # css
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
  ),
  
  # body
  do.call(tabItems, build_body_tabItems(config))
  
)




# this works ------------------------------

body <- dashboardBody(
  
  # css
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
  ),
  
  
  tabItems <- tabItems(
    tabItem(tabName = "home", home_ui("home1")),
    tabItem(tabName = "data", home_ui("data1")),
    tabItem(tabName = "modelling tool", home_ui("modelling tool1")),
    tabItem(tabName = "nesting", home_ui("nesting")),
    tabItem(tabName = "reoptimise", home_ui("reoptimise")))

)
