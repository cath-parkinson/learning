ui <- fluidPage(
  
  tagList(
    
    uiOutput(outputId = "selected_scenario"),
    uiOutput(outputId = "selected_scenario2")
             
  )
  
  
)

server <- function(input, output, session){
  
  output$selected_scenario <- renderUI({
    
    list(
      
    div(
      br(),
      "Selected:",
      style = 'color:black; font-weight:bold;'),

    div("NEW",
        style = 'color:black')
    )
    
    
  })
  
  output$selected_scenario2 <- renderUI({
    
    div(
      br(),
    
    HTML(
      paste(strong("Selected: "),
            "NEW")
    )
    )
  })
  
  
  
}

shinyApp(ui = ui, server = server)