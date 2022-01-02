ui <- fluidPage(
  actionButton("up", "up"),
  actionButton("down", "down"),
  textOutput("n")
)
server <- function(input, output, session) {
  r <- reactiveValues(n = 0)
  observeEvent(input$up, {
    r$n <- r$n + 1
  })
  observeEvent(input$down, {
    r$n <- r$n - 1
  })
  
  output$n <- renderText(r$n)
}

shinyApp(ui = ui, server = server)