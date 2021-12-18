library(shiny)

ui <- fluidPage(
  
  sliderInput(inputId = "num", 
    label = "Choose a number", 
    value = 25, min = 1, max = 100),
  
  actionButton("update", "update"),
  
  plotOutput("hist")
  
  
)

server <- function(input, output) {
  
  number <- eventReactive(input$update, {return(input$num)})
  
  output$hist <- renderPlot({
    hist(rnorm(number()))
  })
}

shinyApp(ui = ui, server = server)