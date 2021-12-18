library(shiny)

ui <- fluidPage(
  
  h1("My Shiny App"),
  p(style = "font-family:Impact", "See other apps in the ", 
    a(href = "http://www.rstudio.com/products/shiny/shiny-user-showcase/", 
      "Shiny Showcase"), "OK yer", "it's all good")
  
)

server <- function(input, output){}

shinyApp(ui, server)