library(shiny)

#sets this up with different tabs at the top so you can have multiple pages

ui <- fluidPage(
  
  navbarPage(title = "Hello!", tabPanel("1"), tabPanel("2"), tabPanel("3")
             )
  )

#sidebarLayout must take two arguments!
#you can move it to the right or left

server <- function(input,output){
  
}

shinyApp(ui=ui,server=server)