# Create a reactivevalues list of navigation values
# Return that to the main app so we can use it to navigate

library(shiny)
library(shinydashboard)

# update values module -------------------------------------

module_ui <- function(id){
  
  ns <- NS(id)
  tagList(
    
    actionButton(inputId = ns("navigate"),
                 label = "Navigate"),
    textOutput(outputId = ns("show_mylist"))
  )
  
}

module_server <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    # output$show_mylist <- renderText({ mylist$mylist })
    # 
    # observeEvent(input$update_value, { # we need to update reactiveValues using a observe event
    # 
    #   mylist$mylist <- mylist$mylist + 1
    # 
    # })
    # 
    # return(mylist)
    # 
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
  
)

ui <- dashboardPage(
  
  dashboardHeader(title = "PRACTICE"),
  sidebar,
  body
)

server <- function(input, output, session){}


shinyApp(ui = ui, server = server)