library(shiny)

ui <- fluidPage(
  titlePanel("censusVis"),
  sidebarLayout(
    
    sidebarPanel("Create demographic maps with information from the 2010 US Census.",
                 selectInput("var", "Choose a variable to display", 
                             c("Percent White", "Percent Black", "Percent Hispanic", "Percent Asian")), 
                 sliderInput("range", "Range of interest:",
                             min = 0,
                             max = 100,
                             value = c(0,100))),
    mainPanel(
      textOutput("var_select"),
      textOutput("range_select")
      )
    
  )
  )

server <- function(input, output){
  
  output$var_select <- renderText({
    
    paste("You have selected", input$var)
    
    })
  
  output$range_select <- renderText({
    
    paste("You have chosen a range that goes from ", input$range[1], "to", input$range[2])
    
  })
  
}

shinyApp(ui, server)