# Re-usable module
choice_ui <- function(id) {
  # This ns <- NS structure creates a 
  # "namespacing" function, that will 
  # prefix all ids with a string
  ns <- NS(id)
  tagList(
    sliderInput(
      # This looks the same as your usual piece of code, 
      # except that the id is wrapped into 
      # the ns() function we defined before
      inputId = ns("choice"), 
      label = "Choice",
      min = 1, max = 10, value = 5
    ),
    actionButton(
      # We need to ns() all ids
      inputId = ns("validate"),
      label = "Validate Choice"
    )
  )
}

choice_server <- function(id) {
  # Calling the moduleServer function
  moduleServer(
    # Setting the id
    id,
    # Defining the module core mechanism
    function(input, output, session) {
      # This part is the same as the code you would put 
      # inside a standard server
      observeEvent( input$validate , {
        print(input$choice)
      })
    }
  )
}


# Main application
library(shiny)
app_ui <- function() {
  fluidPage(
    # Call the UI  function, this is the only place 
    # your ids will need to be unique
    choice_ui(id = "choice_ui1"),
    choice_ui(id = "choice_ui2")
  )
}

app_server <- function(input, output, session) {
  # We are now calling the module server functions 
  # on a given id that matches the one from the UI
  choice_server(id = "choice_ui1")
  choice_server(id = "choice_ui2")
}

shinyApp(app_ui, app_server)