library(shiny)
library(shinydashboard)
library(rhandsontable)

ui <- dashboardPage(
  header = dashboardHeader(title = 'Title'),
  body = dashboardBody(
    rHandsontableOutput('mytableoutput'),
  ),
  sidebar = dashboardSidebar()
)

server <- function(input, output, session) {
  output$mytableoutput = renderRHandsontable({
    mtcars %>% 
      rhandsontable(
                    height = 400) # Just setting the height fixed this
  })
}

shinyApp(ui, server)