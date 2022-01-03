randomUI <- function(id) {
  tagList(
    verbatimTextOutput(NS(id, "val")),
    actionButton(NS(id, "go"), "Go!")
  )
}
randomServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    rand <- eventReactive(input$go, sample(100, 1))
    output$val <- renderPrint(rand())
  })
}

ui <- fluidPage(
  
  randomUI("one"),
  randomUI("two"),
  randomUI("three"),
  randomUI("four"))

server <- function(input, output, session){ 
  
  randomServer("one") 
  randomServer("two") 
  randomServer("three") 
  randomServer("four") 
  
  }

shinyApp(ui = ui, server = server)
