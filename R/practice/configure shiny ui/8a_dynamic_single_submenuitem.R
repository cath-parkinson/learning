# 7) final
library(shiny)
library(shinydashboard)
library(tidyverse)

source("R/funcs_config.R")

config <- read_config() %>% 
  filter(module == "reoptimise")

config_subitems <- read_config() %>% 
  filter(module == "reoptimise") %>% 
  filter(sidebar_type == "menuSubItem")


list_menuSubItems <- mapply(function(x,y){ menuSubItem(text = x, tabName = y)},
                            config_subitems$sidebar_text, 
                            y = config_subitems$tabname,
                            SIMPLIFY = F,
                            USE.NAMES = F)

list_menuSubItems <- c(text = "re:optimise",
                       tabName = "reoptmise",
                       list_menuSubItems)

# we now need a do.call as we're passing a list of arguments!
menuItem_programmed <- do.call(menuItem, list_menuSubItems)

# manual -----------------------------

menuItem_manual <- menuItem(text = "re:optimise", 
                            tabName = "reoptimise", 
                            menuSubItem(text = "Set up", tabName = "reoptimise_setup"),
                            menuSubItem(text = "Optimise", tabName = "reoptimise_optimise"),
                            menuSubItem(text = "Compare", tabName = "reoptimise_compare"))



# check this works -----------------------

sidebar <- dashboardSidebar(sidebarMenu(menuItem_programmed))
body <- dashboardBody()

ui <- function()(
  
  dashboardPage(dashboardHeader(title = "BBTools"),
                sidebar = sidebar,
                body = body)
)

server <- function(input, output, session) {}
shinyApp(ui = ui, server = server)

