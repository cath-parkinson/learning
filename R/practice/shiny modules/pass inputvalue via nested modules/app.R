# Create a reactivevalues list of navigation values
# Return that to the main app so we can use it to navigate

library(shiny)
library(shinydashboard)

# update values module -------------------------------------

module_ui <- function(id){
  
  ns <- NS(id)
  tagList(
    
    actionButton(inputId = ns("navigate"),
                 label = "Go to page 2")
  )
  
}

module_server <- function(id, navigation_values){
  
  moduleServer(id, function(input, output, session){
    
    ns <- session$ns
    
    navigation_values <- reactiveValues()
    
    navigation_values$button1 = reactive(ns(input$navigate))
    
    return(navigation_values)
    
  })

}

# master app --------------------------------------------

sidebar <- dashboardSidebar(
  
  sidebarMenu(
    
    id = "mastertabs",
    
    menuItem(
      text = "Page 1",
      tabName = "page1"
      ),
    
    menuItem(
      text = "Page 2",
      tabName = "page2"
    )
  ))

body <- dashboardBody(
  
  tabItems(
    
    tabItem(
      
      tabName = "page1",
      fluidPage(module_ui("mymodule"))
      
    )
    
  )
  
)

ui <- dashboardPage(
  
  dashboardHeader(title = "PRACTICE"),
  sidebar,
  body
)

server <- function(input, output, session){
  
  navigation_values <- module_server("mymodule", navigation_values)
  
  # Strategy 1: The Hack ----------------------------------
  
  observeEvent(input[["mymodule-navigate"]], {
    
    # updateTabsetPanel(session, inputId = "mastertabs", selected = "page2")
    
  })
  
  # Strategy 2: Pass back a reactive values list ------------------------
  
  # Something about this is wrong
  observeEvent(navigation_values$button1(), {
    
    updateTabsetPanel(session, inputId = "mastertabs", selected = "page2")
    
  })
  
  
  
}


shinyApp(ui = ui, server = server)