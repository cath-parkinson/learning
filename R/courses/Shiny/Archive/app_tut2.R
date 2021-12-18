library(shiny)

#playing around with side/main pabels, and html tags
#side barlayout function creates two bits to your app - the side bar, and the mai
#you populate them as you like

#add action button, slider and selecting tool
#you can also add text holders, called "textOutput", which you can make reactive, by telling the shiny app what to place in them, in the server part

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

#in the below server, you can add reactive parts to the textoutput you've called above

server <- function(input,output){

  #this takes the selection input below, and adds it to this sentence, and then puts it in the "text output" box above in the ui
  output$textoutput <- renderText(({
    paste("You selected this:", input$input)
  }))
  
  output$rangeoutput <- renderText(({
    paste("You have chosen a range that goes from", input$slider[1], "to", input$slider[2])
  }))
  
   }

shinyApp(ui=ui,server=server)
