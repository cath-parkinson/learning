# Shiny modules - issue with updatePickerInput with nested modules -------------------------

library(shiny)
library(tidyverse)

# Inner most module - why does my code not update the pickerInput?

mod2_ui <- function(id){
  
  ns <- NS(id)
  tagList(
    shinyWidgets::pickerInput(
      inputId = ns("filter"),
      label = "Filter:",
      choices = NULL,
      selected =  NULL,
      width = "75%"
    ),
    textOutput(ns("text"))
  )
}

mod2_server <- function(id){
  
  moduleServer(
    id,
    function(input, output, session){
      
      observe({
        
        shinyWidgets::updatePickerInput(
          session = session,
          inputId = "filter",
          choices = c("A", "B"),
          selected =  "A"
        )
        
      })
      
      output$text <- renderText({
        "Text works"
      })
      
    })
  
}

mod1_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Call the inner most module from the UI - this works
    # mod2_ui(ns("myapp"))
    
    # Call the inner most module from the server instead
    uiOutput(ns("myui"))
  )
}

mod1_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      ns <- session$ns
      
      # Call the inner most module from the server
      output$myui <- renderUI({
        
        mod2_ui(ns("myapp"))
        
      })
      
      mod2_server("myapp")
    }
  )
}

mod0_ui <- function(id) {
  ns <- NS(id)
  tagList(
    mod1_ui(ns("myapp"))
  )
}

mod0_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      mod1_server("myapp")
    }
  )
}






ui <- function(){
  
  fluidPage(
    mod1_ui("id")
  )
}

server <- function(input, output, session){
  
  mod1_server("id") 
  
}



shinyApp(ui = ui, server = server)