# 5) programmatically create one menu Item

library(shiny)
library(shinydashboard)
library(tidyverse)
source("R/funcs_config.R")
source("R/mod_home.R")


menuItem <- tabItem(tabName = "home", home_ui("home1"))

# this works because do.call is another will accept a function name in text as the first argument
# the second argument has to be a list!
mymenuItem <- tabItem(tabName = "home", do.call("home_ui", list("home1")))

mytabItems <- do.call(tabItems, list(menuItem))

