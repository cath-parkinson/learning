# shiny dashboard successfully decomposed into modules

library(shiny)
library(shinydashboard)

# mod bbos ui -------------------------------------------
mod_bbos_ui <- function(id){
  
  ns <- NS(id)
  
  # Sidebar -------------------------------------
  sidebar <- dashboardSidebar(
    
    sidebarMenu(id = ns("tabs"),
                menuItem(text = "home",tabName = ns("home")),
                menuItem(text = "data", tabName = ns("data")))
  
        )
  
  # Body -------------------------------------------
  body <- dashboardBody(
    
    # css
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
    ),
    
    tabItems(
      tabItem(tabName = ns("home"), home_ui("home1")),
      tabItem(tabName = ns("data"), home_ui("data1")))
  )
  
  # return dashboard ------------------------------------------
  
  tagList(dashboardPage(dashboardHeader(title = "BBTools"),
                        sidebar = sidebar,
                        body = body))
  
}


# module bbos server ----------------------
mod_bbos_server <- function(id){
  
  home_server("home1")
  home_server("data1")
  
  moduleServer(id, function(input, output, session){
    
  })
  
  
}

# call app ----------------------------------------------

# config <- c("home", "data", "nesting", "wewin" ,"ithnk")
ui <- function(){ mod_bbos_ui("bbos"
                              # , 
                              # config
                              ) }
server <- function(input, output, session){ mod_bbos_server("bbos"
                                                            # , config
                                                            ) }

shinyApp(ui = ui, server = server)