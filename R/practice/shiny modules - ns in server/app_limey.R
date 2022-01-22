library(shiny)
library(tidyverse)

mod_ui <- function(id){
  ns <- NS(id)
  fluidPage(
    uiOutput(outputId = ns("modelling_type_ui")),
    textOutput(outputId = ns("capture"))
  )
}

mod_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session){
      ns <- session$ns
      
      output$modelling_type_ui = renderUI({
        radioButtons(
          inputId = ns("modelling_type"),
          label = "Choose a modelling technique",
          choices = c("OLS","Bayesian"), 
          selected = "OLS"
        )
      })
      
      output$capture <- renderText({
        paste0("modelling type selected: ", input$modelling_type)
      })
      
      # rv <- reactive({
      #   input$modelling_type
      # })
      # 
      # return(rv)
    }
  )
}

ui <- function() { 
  fluidPage(
    mod_ui("mt"),
    # textOutput("returnValue")
  )
}

server <- function(input, output, session) { 
  # modValue <- 
  mod_server("mt") 
  
  # output$returnValue <- renderText({
  #   paste0("The value returned by the module is ", modValue())
  # })
}

shinyApp(ui = ui, server = server)