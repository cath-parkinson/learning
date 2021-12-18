#install.packages(c("maps", "mapproj"))
#library(maps, mapproj)
library(shiny)
#setwd("C:/Users/Catherine/OneDrive/Documents/R/Shiny")
#counties <- readRDS("counties.rds")
#head(counties)
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
                             choices = c("Percent White", "Other options")),
                 sliderInput("slider", label = "Range of interest:", 
                             min = 0, max = 100, value = c(0,100), dragRange = F)),
    mainPanel(plotOutput("map"))
  )
)

server <- function(input,output){
  
}

shinyApp(ui,server)