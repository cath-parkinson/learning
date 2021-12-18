library(shiny)

ui <- fluidPage(
  
  # name field
  textInput(inputId = "text_input",label = "input name",value = ""),
  
  # button to update greeting output
  actionButton(inputId = "update",label = "update"),
  
  # text output containing greeting
  textOutput(outputId = "text_output")
  
)

server <- function(input, output, session) {
  
  # greeting function
 greeting <- eventReactive(
   
    input$update ,{
   
    # get name input string
    name = input$text_input
    
    # concatenate string
    message = paste0("Hello there, ",name)
    
    # return message
    return(message)
  })
  
  # render text output
  output$text_output <- renderText({
    
    # use greeting function
    greeting()
  
  })
  
}

shinyApp(ui, server)