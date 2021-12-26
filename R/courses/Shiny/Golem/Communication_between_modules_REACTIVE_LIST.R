# Module 1, which will allow to select a number
choice_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Add a slider to select a number
    sliderInput(ns("choice"), "Choice", 1, 10, 5)
  )
}


choice_server <- function(id, r) {
  moduleServer(
    id,
    function(input, output, session) {
      # Whenever the choice changes, the value inside r is set
      observeEvent( input$choice , {
        r$number_from_first_mod <- input$choice
      })
      
    }
  )
}

# Module 2, which will display the number
printing_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Insert the number modified in the first module
    verbatimTextOutput(ns("print"))
  )
}

printing_server <- function(id, r) {
  moduleServer(
    id,
    function(input, output, session) {
      # We evaluate the reactiveValue element modified in the 
      # first module
      output$print <- renderPrint({
        r$number_from_first_mod
      })
    }
  )
}

# Application
library(shiny)
app_ui <- function() {
  fluidPage(
    choice_ui("choice_ui_1"),
    printing_ui("printing_ui_2")
  )
}

app_server <- function(input, output, session) {
  # both servers take a reactiveValue,
  #  which is set in the first module
  # and printed in the second one.
  # The server functions don't return any value per se
  r <- reactiveValues()
  choice_server("choice_ui_1", r = r)
  printing_server("printing_ui_2", r = r)
}

shinyApp(app_ui, app_server)
