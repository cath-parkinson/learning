library(shiny)

ui <- fluidPage(
  
  titlePanel("Hello Shiny!"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "bins", 
                  label = "Select the number of bins", 
                  min =1,
                  max = 100,
                  value = 50)
    ),
    mainPanel(
      plotOutput(outputId = "disPlot")
    )
  )
)
  
server <- function(input,output) {
  output$disPlot <- renderPlot({
    
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins +1)
    hist(x, breaks = bins, col = "#75AADB", border = "white", 
         xlab = "Waiting time", main = "Histogram")
    
  })
  
}

shinyApp(ui=ui, server=server)

#the sequence defines by bins, creates the number of bars for the bar chart?!
#also known as break points!


#min(faithful$waiting)
#max(faithful$waiting)
#?seq
#seq(43,96,length.out = 51)
