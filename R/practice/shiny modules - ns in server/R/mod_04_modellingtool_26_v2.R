# problem - how to I access the value of modelling_type when it has been created in the server without the ns function
# make a reproducible example!

mod_04_modellingtool_26_ui_v2 <- function(id){
  
  ns <- NS(id)
  
  # fluidpage provides a nice wrapper for the ui whearas tag list is a basic html thing
  fluidPage(
    
    "Test",
    
    # # select modelling type
    actionButton(inputId = ns("saved_model"),
                 label = "Save model"),
    
    uiOutput(outputId = ns("modelling_type_ui")),
    
    textOutput(outputId = ns("text")),
    
    textOutput(outputId = ns("capture"))
    
  )
    
  
}


mod_04_modellingtool_26_server_v2 <- function(id, parentsession){
  
 
  
  moduleServer(id,
               function(input, output, server){
                 
                 ns <- parentsession$ns
                 
                 output$modelling_type_ui = renderUI({
                   
                   print(input$modelling_type_ui)
                   print(input$modelling_type) # this should not be null
                   
                   # browser()
                   
                   radioButtons(
                     # inputId = "modelling_type", # name space not needed here because it's passing straight to the modelling_type_ui through shiny
                     inputId = ns("modelling_type"), # name space not needed here because it's passing straight to the modelling_type_ui through shiny
                     label = "Choose a modelling technique",
                     choices = c("OLS",
                                 "Bayesian",
                                 "Test"),
                     selected = "OLS")
                   
                 })
                 
                 text <- eventReactive(input$saved_model, { 
                   
                   
                   # browser()
                   print(input$modelling_type)
                   
                   return("well done you clicked a button") })
                 output$text <- renderText({ text() })
                 text_model <- eventReactive(input$saved_model, { 
                   # input$modelling_type 
                   input$modelling_type_ui 
                   
                   
                   })
                 
                 output$capture = renderText({ modelling_type })
                 
                 
               })
  
  
}
