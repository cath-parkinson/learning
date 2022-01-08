# 4) add in the body and server elements
library(shiny)
library(shinydashboard)
library(tidyverse)
source("R/funcs_config.R")

# funcs_bbos_ui ----------------------------------

# config <- read_config()
# ns <- NS("id")

build_sidebar_menu <- function(ns, config){
  
  build_sidebar_menu_item <- function(x,y) { menuItem(text = x, tabName = y) }
  
  list_menuItems <- mapply(build_sidebar_menu_item, 
                           config$sidebar_text, 
                           config$tabname,
                           SIMPLIFY = F,
                           USE.NAMES = F)
  list_menuItems <- c(id = ns("tabs"), list_menuItems)
  
  return(list_menuItems)
}

# check <- build_sidebar_menu(ns, config)

# mod bbos ui -------------------------------------------
mod_bbos_ui <- function(id, config){
  
  ns <- NS(id)
  
  # Sidebar -------------------------------------
  sidebar <- dashboardSidebar(
    
    do.call(sidebarMenu, build_sidebar_menu(ns, config))
    
        )
  
  # Body -------------------------------------------
  body <- dashboardBody(
    
    # css
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
    ),
    
    
    tabItems(
      tabItem(tabName = "home", home_ui("home1")),
      tabItem(tabName = "data", home_ui("data1")))
  )
  
  # return dashboard ------------------------------------------
  
  tagList(dashboardPage(dashboardHeader(title = "BBTools"),
                        sidebar = sidebar,
                        body = body))
  
}


# module bbos server ----------------------
mod_bbos_server <- function(id, config){
  
  home_server("home1")
  home_server("data1")
  
  moduleServer(id, function(input, output, session){
    
    
  })
  
  
}

# call app ----------------------------------------------

config <- read_config()
ui <- function(){ mod_bbos_ui("bbos", config) }
server <- function(input, output, session){ mod_bbos_server("bbos", config) }

shinyApp(ui = ui, server = server)