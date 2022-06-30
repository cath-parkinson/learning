# problem - how to I access the value of modelling_type when it has been created in the server without the ns function

mod_04_modellingtool_26_ui <- function(id){
  
  ns <- NS(id)
  
  # fluidpage provides a nice wrapper for the ui whearas tag list is a basic html thing
  fluidPage(
    
    "Test",
    
    # # select modelling type
    actionButton(inputId = ns("saved_model"),
                 label = "Save model"),
    uiOutput(outputId = ns("modelling_type_ui"))
  )
    
  
}


mod_04_modellingtool_26_server <- function(id,parentsession){
  
  moduleServer(id,
               function(input, output, server){
                 
                 
                 output$modelling_type_ui = renderUI({
                   
                   print(input$modelling_type_ui)
                   print(input$modelling_type) # this should not be null
                   
                   radioButtons(
                     # inputId = "modelling_type", # name space not needed here because it's passing straight to the modelling_type_ui through shiny
                     inputId = parentsession$ns("modelling_type"), 
                     "Choose a modelling technique",
                     choices = c("OLS",
                                 "Bayesian",
                                 "Test"),
                     selected = "OLS")
                   
                   

                 })
                 
                 
                 
               })
  
  
}
