# 7) final
library(shiny)
library(shinydashboard)
library(tidyverse)

source("R/funcs_config.R")

# funcs_bbos_ui ----------------------------------

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

# funcs_bbos_server

build_mod_server <- function(config){
  
  mapply(function(x,y){ do.call(x, list(y))}, config$mod_server, config$id)
  
}


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
    
    # body
    do.call(tabItems, build_body_tabItems(config))
    
  )
  
  # return dashboard ------------------------------------------
  
  tagList(dashboardPage(dashboardHeader(title = "BBTools"),
                        sidebar = sidebar,
                        body = body))
  
}


# module bbos server ----------------------
mod_bbos_server <- function(id, config){
  
  build_mod_server(config)
  
  moduleServer(id, function(input, output, session){
    
    
  })
  
  
}

# call app ----------------------------------------------

config <- read_config()
ui <- function(){ mod_bbos_ui("bbos", config) }
server <- function(input, output, session){ mod_bbos_server("bbos", config) }

shinyApp(ui = ui, server = server)

# run in display mode
# myApp <- shinyApp(ui = ui, server = server)
# runApp(myApp, display.mode = "showcase")
