library(shiny)
library(shinydashboard)

# update values module -------------------------------------

module_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(inputId = ns("navigate"),
                 label = "Go to page 2"))
}

module_server <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    return(reactive(input$navigate))
    
  })

}

# UI  --------------------------------------------

sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "mastertabs",
    menuItem(
      text = "Page 1",
      tabName = "page1"
      ),
    menuItem(
      text = "Page 2",
      tabName = "page2")
  ))

body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "page1",
      fluidPage(module_ui("mymodule"))
    )))

ui <- dashboardPage(
  dashboardHeader(title = "PRACTICE"),
  sidebar,
  body
)

# Server ---------------------------

server <- function(input, output, session){
  
  navigation_values <- module_server("mymodule")
  
  observeEvent(navigation_values(), {

    updateTabsetPanel(session, inputId = "mastertabs", selected = "page2")

  })

}

shinyApp(ui = ui, server = server)