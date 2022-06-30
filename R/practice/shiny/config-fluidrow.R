library(shiny)
library(shinydashboard)

#do.call is not needed! You can just pass a list of column objects fluidrow
# https://github.com/rstudio/shiny/issues/809

condition <- T

item1 <- column(3,
               valueBox(
                 paste0("TEST:"),
                 # value = "",
                 subtitle = strong(toupper("Annual, £38M, Profit")),
                 color = "navy",
                 width = NULL))


item2 <- column(3,
               valueBox(
                 paste0("TEST2:"),
                 # value = "",
                 subtitle = strong(toupper("Annual, £38M, Profit")),
                 color = "navy",
                 width = NULL))

mylist <- list(item1, item2)


ui <- dashboardPage(
  dashboardHeader(title = "Value boxes"),
  dashboardSidebar(),
  dashboardBody(
  
  uiOutput(outputId = "boxes_s1"),
  uiOutput(outputId = "boxes_s2"),
  
))

server <- function(input, output, session) {
  
  output$boxes_s1 <- renderUI({
    
    fluidRow(
      
      mylist
      
    )
    
    })
  
  output$boxes_s2 <- renderUI({
    
    if(condition == T){
      
      
      fluidRow(
        
        mylist
      )
      
      
    }
    
    
  })
  
  
  
}

shinyApp(ui, server)