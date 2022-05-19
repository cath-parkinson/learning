# Create a reactivevalues list of navigation values
# Return that to the main app so we can use it to navigate

# https://shiny.rstudio.com/articles/modules.html
# The goal is not to prevent modules from interacting with their containing 
# apps, but rather, to make these interactions explicit. If a module needs to 
# use a reactive expression, the outer function should take the reactive 
# expression as a parameter. If a module wants to return reactive expressions 
# to the calling app, then return a list of reactive expressions from the 
# function.

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

module_server <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    # Strategy 2 ---------------------------------
    navigation_values <- reactiveValues()
    
    # Strategy 2b -----------------------------------
    # navigation_values$button1 = reactive(input$navigate)
    
    # Strategy 2c ---------------------------------------------
    observeEvent(input$navigate, {

      navigation_values$button1 = input$navigate

    })

    
    
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
  
  navigation_values <- module_server("mymodule")
  
  # Strategy 1: The Hack ----------------------------------
  
  # observeEvent(input[["mymodule-navigate"]], {
  # 
  # updateTabsetPanel(session, inputId = "mastertabs", selected = "page2")
  # 
  # })

  # Strategy 2a: Return the reactive value of the button explicitly --------
  
  # Haven't coded this as it feels more cumbersome than creating a
  # reactive values list - as it would make it harder to keep track
  # of all the values we need to do this for
  
  # Strategy 2b: Return a reactive values list ------------------------
  
  # Makes it easy to "keep track" of all the buttons we need to watch
  # across what is a pretty sizeable app
  
  # observeEvent(navigation_values$button1(), {
  # 
  #   updateTabsetPanel(session, inputId = "mastertabs", selected = "page2")
  # 
  # })

  # Strategy 2c: As per 2 - but with an observeEvent rather than a reactive() -----------
  
  observeEvent(navigation_values$button1, {

    updateTabsetPanel(session, inputId = "mastertabs", selected = "page2")

  })

}


shinyApp(ui = ui, server = server)