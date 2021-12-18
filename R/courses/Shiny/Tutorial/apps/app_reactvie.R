library(shiny) 

ui <- fluidPage("Hello World",
                
                # two main types of ui functions - input and output
                # inputs are things the user toggles
                # all inputs have inputId and label
                
                sliderInput(inputId = "num",  # the name you give the input object
                            label = NULL, # the display label the user sees 
                            value = 2, min = 0, max = 100, step = 1), # additional arguments
                
                # outputs are things the users sees - plots, tables, text, image
                # outputs just have outputI
                # this creates a space in the app for our plot - but we need to use the server function, to produce the content i.e. the type of graph we want
                
                plotOutput(outputId = "hist")
                
                # separate arguments in the ui with commas
                
                ) 

# tell the server how to assemble inputs into outputs
# three rules for using the server function

# if you are building an output object, you need to save the output object to "output$hist"
# both input and out must appear in your server function as arguments
# and they are both list like objects
# use input values with "input$num"

# what you save into output must be something build with a render function
# render functions create your output

server <- function(input, output) {
  
  # renderplot is a reactive function
  # it's designed to take reactive values, and react - it knows what to do with them
  # "input$num" is a reactive value, because it changes as the user moves the slider
  # you need to pair reactive functions with reactive values!
  output$hist <- renderPlot({
    hist(rnorm(input$num))
    })
  
} 

shinyApp(ui = ui, server = server)
