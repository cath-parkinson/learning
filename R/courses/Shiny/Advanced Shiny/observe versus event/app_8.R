ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)
# server <- function(input, output, server) {
#   output$greeting <- renderText(paste0("Hello ", input$name))
# }

server <- function(input, output, server) {
  
  greeting <- reactive(paste0("Hello ", input$name))
  output$greeting <- renderText(greeting())
  
  var <- reactive(df[[input$var]])
  range <- reactive(range(var(), na.rm = TRUE))
  
}
# 
# server <- function(input, output, server) {
#   output$greeting <- renderText(paste0("Hello ", input$name))
# }

shinyApp(ui = ui, server = server)