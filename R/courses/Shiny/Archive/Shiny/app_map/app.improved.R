library(shiny)
library(maps)
library(mapproj)
setwd("C:/Users/Catherine/Documents/R/Shiny")

source("app/helpers.R")
counties <- readRDS("app/data/counties.rds")

#percent_map(counties$white, "darkgreen", "% White")

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
      textOutput("range_select"),
      plotOutput("plot")
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
    
    output$plot <- renderPlot({
    
    variable <- switch(input$var, "Percent White" = counties$white,
                       "Percent Black" = counties$black,
                       "Percent Hispanic" = counties$hispanic,
                       "Percent Asian" = counties$asian)
    
    color <- switch(input$var, "Percent White" = "darkgreen",
                    "Percent Black" = "royalblue",
                    "Percent Hispanic" = "tomato",
                    "Percent Asian" = "gray")
    
    percent_map(variable, color, input$var, min = input$range[1], max = input$range[2])
    
    })
  
  }

shinyApp(ui, server)