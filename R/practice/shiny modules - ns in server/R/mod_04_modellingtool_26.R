mod_04_modellingtool_26_ui <- function(id){
  
  ns <- NS(id)
  
  # tagList
  fluidPage(
    
    "Test",
    
    # # select modelling type
    uiOutput(outputId = ns("modelling_type_ui"))
  )
    
  
}


mod_04_modellingtool_26_server <- function(id,parentsession){
  
  moduleServer(id,
               function(input, output, server){
                 
                 output$modelling_type_ui = renderUI({

                   radioButtons(
                     "modelling_type", # name space not needed here because it's passing straight to the modelling_type_ui through shiny
                     "Choose a modelling technique",
                     choices = c("OLS",
                                 "Bayesian",
                                 "Test"),
                     selected = "OLS")

                 })
                 
               })
  
  
}
