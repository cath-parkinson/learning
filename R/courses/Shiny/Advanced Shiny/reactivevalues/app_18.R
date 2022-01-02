ui <- fluidPage(
  actionButton("rnorm", "Normal"),
  actionButton("runif", "Uniform"),
  # textOutput("text_rnorm"),
  # textOutput("text_runif"),
  plotOutput("plot")
)

server <- function(input, output, session){
  
  r <- reactiveValues(numbers = NULL)
  
  observeEvent(input$rnorm, { r$numbers <- rnorm(100) })
  observeEvent(input$runif, { r$numbers <- runif(100) })
  
  output$text_rnorm <- renderText({ input$rnorm })
  output$text_runif <- renderText({ input$runif })
  
  output$plot <- renderPlot({ 
    
    # require is checking for this to be true
    req(input$rnorm | input$runif)
    
    # if(is.null(r$numbers)) return()
    hist(r$numbers) 
    
    }) 
  
}

shinyApp(ui = ui, server = server)