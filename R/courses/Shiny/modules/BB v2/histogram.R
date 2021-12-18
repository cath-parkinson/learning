histogramUI <- function() {
  tabsetPanel(id = "tabs",
              type = "pills",
              tabPanel("Home", fluidRow(
                selectInput("var", "Variable", choices = names(mtcars)),
                numericInput("bins", "bins", value = 10, min = 1),
                plotOutput("hist")
              )))
}


histogramServer <- function(input, output, session) {
  
  data <- reactive(mtcars[[input$var]])
  
  output$hist <- renderPlot({
    hist(data(), breaks = input$bins, main = input$var)
  }, res = 96)
  
}