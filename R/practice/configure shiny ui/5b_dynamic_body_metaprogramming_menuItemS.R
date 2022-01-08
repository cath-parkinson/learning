# 5) programmatically create a list of menu items

library(shiny)
library(shinydashboard)
library(tidyverse)
source("R/funcs_config.R")
source("R/mod_home.R")

# as a function
build_body_tabItem <- function(x,y,z) { 
  
  tabItem(tabName = x, do.call(y, list(z)))
  
  }

# list of menu items --------------------------------
config <- read_config()

list_tabItems <- mapply(build_body_tabItem,
                        x = config$tabname,
                        y = config$mod_ui,
                        z = config$id,
                        SIMPLIFY = F,
                        USE.NAMES = F)

mytabItems <- do.call(tabItems, list_tabItems)


# this works ------------------------------

tabItems_working <- tabItems(
  tabItem(tabName = "home", home_ui("home1")),
  tabItem(tabName = "data", home_ui("data1")),
  tabItem(tabName = "modelling tool", home_ui("modelling tool1")),
  tabItem(tabName = "nesting", home_ui("nesting")),
  tabItem(tabName = "reoptimise", home_ui("reoptimise")))





