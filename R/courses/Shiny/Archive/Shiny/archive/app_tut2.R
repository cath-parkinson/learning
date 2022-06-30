library(shiny)

#playing around with side/main pabels, and html tags
#side barlayout function creates two bits to your app - the side bar, and the mai
#you populate them as you like

ui <- fluidPage(
  
  titlePanel(strong("My Shiny App")),
  sidebarLayout(
    sidebarPanel(h1("Installation"), 
                 p("Shiny is available on CRAN, so you can install it in the usual way from your R console:"), 
                 a("hyperlink text")), 
    mainPanel(h1("More info"), h2("And some widgets", align = "left"), 
              actionButton("actionbutton", label = "Action"),
              sliderInput("slider", label = "Pick a value", min = 0, max = 100, value = c(10,60), dragRange = F), 
              selectInput("input", label = "Pick an option", choices = c("1", "2", "3")), 
              textOutput("textoutput"),
              textOutput("rangeoutput")
              )
  )
)

#sidebarLayout must take two arguments!
#you can move it to the right or left

#add html tags like h1 and h2 

server <- function(input,output){
  
  output$textoutput <- renderText(({
    paste("You selected this:", input$input)
  }))
  
  output$rangeoutput <- renderText(({
    paste("You have chosen a range that goes from", input$slider[1], "to", input$slider[2])
  }))
  
   }

shinyApp(ui=ui,server=server)
?navbarPage
?sliderInput
