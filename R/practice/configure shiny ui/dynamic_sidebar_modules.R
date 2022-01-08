library(shiny)
library(shinydashboard)

# https://stackoverflow.com/questions/51104554/is-there-a-way-in-which-we-can-make-the-sidebarmenu-menuitems-dynamic
# https://stackoverflow.com/questions/32741169/r-shinydashboard-dynamic-menuitem



# list <- c("home", "data", "nesting", "wewin")

# bbos ui functions

build_sidebar_menu <- function(ns, config){
  
  list_menuItems <- lapply(config, function(x){
    
    menuItem(text = x, tabName = x) 
    
  })
  
  list_menuItems <- c(id = ns("tabs"), list_menuItems)
  
  return(list_menuItems)
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
    
    
    tabItems(
      tabItem(tabName ="home"))
  )
  
  # return dashboard ------------------------------------------
  
  tagList(dashboardPage(dashboardHeader(title = "BBTools"),
                        sidebar = sidebar,
                        body = body))
  
}


# module bbos server ----------------------
mod_bbos_server <- function(id, config){
  
  moduleServer(id, function(input, output, session){
    
    
  })
  
  
}

# call app ----------------------------------------------

config <- c("home", "data", "nesting", "wewin" ,"ithnk")
ui <- function(){ mod_bbos_ui("bbos", config) }
server <- function(input, output, session){ mod_bbos_server("bbos", config) }

shinyApp(ui = ui, server = server)