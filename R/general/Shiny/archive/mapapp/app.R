#install.packages(c("maps", "mapproj"))
library(maps, mapproj)
library(shiny)
setwd("C:/Users/Catherine/OneDrive/Documents/R/Shiny")
counties <- readRDS("counties.rds")
source("helpers.R")
#percent_map(counties$white, "darkgreen", "% White")
  
#source("helpers.R")
  #counties <- readRDS("data/counties.rds"),
  #library(maps),
  #library(mapproj),
  #percent_map(counties$white, "darkgreen", "% White")

ui <- fluidPage(
  titlePanel("censusVis"),
  sidebarLayout(
    sidebarPanel(("Create demographic maps with information from the 2010 US Census."),
                 selectInput("selection", label = "Choose a variable to display", 
                             choices = c("Percent White", "Percent Black", "Percent Hispanic", "Percent Asian")),
                 sliderInput("slider", label = "Range of interest:", 
                             min = 0, max = 100, value = c(0,100), dragRange = F)),
    mainPanel(textOutput("optionselected"),
              textOutput("rangeselected"), 
              plotOutput("map"))
  )
)

server <- function(input,output){
  
  output$optionselected <- renderText(({
    paste("You selected this:", input$selection)
  }))
  
  output$rangeselected <- renderText(({
    paste("You have chosen a range that goes from", input$slider[1], "to", input$slider[2])
  }))
  
  output$map <- renderPlot({
    data <- switch(input$selection, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$selection, 
                     "Percent White" = "darkgreen",
                     "Percent Black" = "orange",
                     "Percent Hispanic" = "yellow",
                     "Percent Asian" = "red")
    
    percent_map(var = data, color = color, legend.title = input$selection, 
                max = input$slider[2],
                min = input$slider[1])
    
  })
  
}

shinyApp(ui,server)