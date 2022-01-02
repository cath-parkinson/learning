ui <- fluidPage(
  selectInput("type", "type", c("Normal", "Uniform")),
  actionButton("go", "go"),
  plotOutput("plot")
)

server <- function(input, output, session){
  
  r <- reactiveValues(numbers = NULL)
  
  observeEvent(input$go,{ 
    
    if(input$type == "Normal") { r$numbers <- rnorm(100) }
    if(input$type == "Uniform") { r$numbers <- runif(100) }
    
     })
  
  output$plot <- renderPlot({ 
    
    # require is checking for this to be true
    req(input$go)
    
    # if(is.null(r$numbers)) return()
    hist(r$numbers) 
    
    }) 
  
}

shinyApp(ui = ui, server = server)