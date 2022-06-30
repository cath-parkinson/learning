# Main module that creates the shiny dashboard

# todo - add the correct styling here

# mod os ui -------------------------------------------
mod_os_ui <- function(id, config){
  
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


# module os server ----------------------
mod_os_server <- function(id, config, session){
  
  build_mod_server(config, session)
  
  moduleServer(id, function(input, output, session){
    
    
  })
  
  
}
