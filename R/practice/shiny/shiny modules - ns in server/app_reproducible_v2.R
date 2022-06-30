# libraries

library(shiny)
library(shinyalert)
library(shinydashboard)
library(shinyjs)
library(tidyverse)

# how do I access the value of a radioButtons that are created in the 


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
               function(input, output, server){
                 
                 ns <- parentsession$ns
                 
                 output$modelling_type_ui = renderUI({
                   
                   print(input$modelling_type) # this should not be null
                   
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
