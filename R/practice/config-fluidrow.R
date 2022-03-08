library(shiny)
library(shinydashboard)

#do.call is not needed! You can just pass a list of column objects fluidrow
# https://github.com/rstudio/shiny/issues/809

item1 <- column(2,
               valueBox(
                 paste0("TEST:"),
                 # value = "",
                 subtitle = strong(toupper("Annual, £38M, Profit")),
                 color = "navy",
                 width = NULL))


item2 <- column(4,
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
  
  uiOutput(outputId = "boxes")
  
))

server <- function(input, output, session) {
  
  output$boxes <- renderUI({
    
    fluidRow(
      
      mylist
      
    )
    
    
  })
  
}

shinyApp(ui, server)