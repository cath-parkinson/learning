library(shiny)
library(shinyFeedback)
library(shinydashboard)
library(tidyverse)

# update values module -------------------------------------

module_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyWidgets::pickerInput(
      inputId = ns("select_metrics"),
      label = "Choose 4 Metrics:",
      choices = letters[c(1:7)],
      multiple = T,
      width = "75%"
    ),
    
    # shiny::selectInput(
    #   inputId = ns("select_metrics"),
    #   label = "Choose 4 Metrics:",
    #   choices = letters[c(1:7)],
    #   multiple = F,
    #   width = "75%"
    # 
    # ),

    
    textOutput(outputId = ns("test_select_metrics_value"))
    
    )
}

module_server <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    observeEvent(input$select_metrics, {
      
      req(input$select_metrics)
      
      print(length(input$select_metrics))
      print(length(input$select_metrics) > 4)
      
      if(length(input$select_metrics) > 4){
      # if("c" %in% input$select_metrics){
        
        shinyFeedback::showFeedbackWarning(inputId = "select_metrics",
                                           text = "Warning: You have selected more than 4 metrics"
                                           )
        
        print("feedback applied")
        
      } else {

        shinyFeedback::hideFeedback(inputId = "select_metrics")
        
        print("feedback not applied")
        
      }
      
    })
    
    
  output$test_select_metrics_value <- renderText({
    
    # "TESTING"
    
    input$select_metrics %>% length()
    
    
  })
    
  })
  
  
}

# UI  --------------------------------------------

sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "mastertabs",
    menuItem(
      text = "Page 1",
      tabName = "page1"
    ),
    menuItem(
      text = "Page 2",
      tabName = "page2")
  ))

body <- dashboardBody(
  
  useShinyFeedback(),
  
  tabItems(
    tabItem(
      tabName = "page1",
      fluidPage(module_ui("mymodule"))
    )))

ui <- dashboardPage(
  dashboardHeader(title = "PRACTICE"),
  sidebar,
  body
)

# Server ---------------------------

server <- function(input, output, session){
  
  module_server("mymodule")
  
}

shinyApp(ui = ui, server = server)