ui <- fluidPage(
  numericInput("x", "x", value = 50, min = 0, max = 100),
  actionButton("capture", "capture"),
  textOutput("out")
)




server <- function(input, output, session){
  
  answer <- eventReactive(input$capture, { input$x })
  output$out <- renderText({ answer() })
  
  
}

shinyApp(ui = ui, server = server)
