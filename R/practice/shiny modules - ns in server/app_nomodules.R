library(shiny)
library(shinyalert)
library(shinydashboard)
library(shinyjs)
library(tidyverse)

# this does not work- when you try and change a value it basically says no


ui <- function(){
  
  fluidPage(
  
  "Test",
  
  # # select modelling type
  actionButton(inputId = "saved_model",
               label = "Save model"),
  uiOutput(outputId = "modelling_type_ui"),
  uiOutput(outputId = "capture")
  
  )
  }

server <- function(input,output, session){
  
  output$modelling_type_ui = renderUI({
    
    print(input$modelling_type_ui)
    print(input$modelling_type) # this should not be null
    
    radioButtons(
      "modelling_type", # name space not needed here because it's passing straight to the modelling_type_ui through shiny
      "Choose a modelling technique",
      choices = c("OLS",
                  "Bayesian",
                  "Test"),
      selected = "OLS")
    
    })
  
  output$capture = renderText({ 
    
    # input$modelling_type 
    paste0("modelling type selected:", input$modelling_type)
    })
  
}

shinyApp(ui = ui, server = server)

