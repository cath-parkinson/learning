ui <- fluidPage(
  
  textInput("name", label = NULL, placeholder = "Your name"),
  textOutput("greeting"),
  sliderInput("my_slider", "When should we deliver?", 
              min = as.Date("2020-09-16"), 
              max = as.Date("2020-09-23"), 
              value = as.Date("2020-09-19"))
  
)

server <- function(input, output, session){
  
  output$greeting <- renderText({
    paste0("Hello ", input$name)
  })
  
  
}

shinyApp(ui = ui, server = server)