library(shiny)

#playing around with side/main pabels, and html tags

ui <- fluidPage(
  
  titlePanel("title panel"),
  sidebarLayout(
    sidebarPanel("sidebar panel"), 
    mainPanel(h1("main panel"), h2("second header", align = "center")), 
    position = "right"
  )
)

#sidebarLayout must take two arguments!
#you can move it to the right or left

#add html tags like h1 and h2 

server <- function(input,output){
  
}

shinyApp(ui=ui,server=server)
?navbarPage
