# how do I access the value of a radioButtons that are created in the server


# libraries

library(shiny)
library(shinyalert)
library(shinydashboard)
library(shinyjs)
library(tidyverse)

# modules ------------------------------------------

mod_ui <- function(id){
  
  ns <- NS(id)
  
  fluidPage(
    
    uiOutput(outputId = ns("modelling_type_ui")),
    
    textOutput(outputId = ns("capture"))
    
  )
  
}

mod_server <- function(id, parentsession){
  
  moduleServer(id,
               function(input, output, session){ # this was incorrectly labelled as server
                 
                 # ns <- parentsession$ns # this was incorrectly labelled as parentsession
                 ns <- session$ns
                  
                 output$modelling_type_ui = renderUI({
                   
                   # print(input$modelling_type) # this causes lots of problems!
                   # it is trying to print something that doesn't exist yet
                   # it causes the code block to be reexecuted every time input$modelling_type changes
                   # which is whenever the the user selects it
                   
                   radioButtons(
                     inputId = ns("modelling_type"), 
                     label = "Choose a modelling technique",
                     choices = c("OLS",
                                 "Bayesian"),
                     selected = "OLS")
                   
                 })
               
                 output$capture = renderText({ paste0("modelling type selected:", input$modelling_type) })
                 
                 })
  
  }


# call app ---------------------------------------

# run app
ui <- function(){ mod_ui("mt") }
server <- function(input, output, session){ mod_server("mt", session) }

shinyApp(ui = ui, server = server)
