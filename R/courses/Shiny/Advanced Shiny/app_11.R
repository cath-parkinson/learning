ui <- fluidPage(
  checkboxInput("error", "error?"),
  textOutput("result")
)
server <- function(input, output, session) {
  a <- reactive({
    if (input$error) {
      # stop("Errooooooor!")
      req(input$error, cancelOutput = TRUE)
      
      } else {
      1
    }
  })
  b <- reactive(a() + 1)
  c <- reactive(b() + 1)
  output$result <- renderText(c())
}

shinyApp(ui = ui, server = server)

