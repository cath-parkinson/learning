# Module 1, which will allow to select a number
choice_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Add a slider to select a number
    sliderInput(ns("choice"), "Choice", 1, 10, 5)
  )
}


choice_server <- function(id) {
  moduleServer( id, function(input, output, session) {
    # We return a reactive function from this server, 
    # that can be passed along to other modules
    return(
      reactive({
        input$choice
      })
    )
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

printing_server <- function(id, number) {
  moduleServer(id, function(input, output, session) {
    # We evaluate the reactive function 
    # returned from the other module
    output$print <- renderPrint({
      number()
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
  # choice_server() returns a value that is then passed to 
  # printing_server()
  number_from_first_mod <- choice_server("choice_ui_1")
  printing_server(
    "printing_ui_2", 
    number = number_from_first_mod
  )
}

shinyApp(app_ui, app_server)
