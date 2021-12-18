library(shiny)
library(shinydashboard)
library(rhandsontable)
library(readxl)
library(dplyr)
library(tidyverse)
library(highcharter)
library(lubridate)
library(formattable)
library(scales)

# Combined ------------------------

# source("reoptimise.R")
source("histogram.R")


## UI: sidebar --------------------

sidebar <- dashboardSidebar(
  
  sidebarMenu(
    id = "tabs",
    menuItem("Info", tabName = "info", icon = icon("info")),
    menuItem("re:Optimise MMM", tabName = "reoptimiseMMM", icon = icon("bullseye")),
    menuItem("re:Forecast", tabName = "reforecast", icon = icon("sliders-h"))
  )
)

## UI: body --------------------------
body <- dashboardBody(
  
  # css
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
  ),
  
  tabItems(
    
    tabItem(tabName = "info",
            fluidPage(histogramUI("hist1"))),
    
    tabItem(tabName = "reoptimiseMMM",
            fluidPage()),
    
    tabItem(tabName = "reforecast",
            fluidRow())
  )
  
)

## Run app ------------------------------------------

ui <- dashboardPage(dashboardHeader(title = "BB tools"),
                    sidebar,
                    body)


server <- function(input, output, session){
  
  histogramServer("hist1")
  
}

shinyApp(ui, server)



