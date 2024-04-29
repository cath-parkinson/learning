library(shiny)
library(shinyWidgets)

ui <- fluidPage(
  titlePanel("Currency Symbol Demo"),
  sidebarLayout(
    sidebarPanel(
      h4("Generated in UI"),
      # If you comment this section back in, the server generated autonumericInput starts working
      # autonumericInput("input1", "Pound (£)", value = 0, currencySymbol = "£"),
      # autonumericInput("input2", "Dollar ($)", value = 0, currencySymbol = "$"),
      # autonumericInput("input3", "Euro (€)", value = 0, currencySymbol = "€"),
      h4("Generated in Server"),
      uiOutput("currencyInputs")
    ),
    mainPanel(
      h3("Currency Input Values:"),
      # verbatimTextOutput("output1"),
      # verbatimTextOutput("output2"),
      # verbatimTextOutput("output3"),
      verbatimTextOutput("output4"),
      verbatimTextOutput("output5"),
      verbatimTextOutput("output6")
    )
  )
)

server <- function(input, output) {
  output$currencyInputs <- renderUI({
    tagList(
      autonumericInput("input4", "Pound (£)", value = 0, currencySymbol = "£"),
      autonumericInput("input5", "Dollar ($)", value = 0, currencySymbol = "$"),
      autonumericInput("input6", "Euro (€)", value = 0, currencySymbol = "€")
    )
  })
  
  output$output1 <- renderText({
    paste("Pound (£) Value (Generated in UI):", input$input1)
  })
  
  output$output2 <- renderText({
    paste("Dollar ($) Value (Generated in UI):", input$input2)
  })
  
  output$output3 <- renderText({
    paste("Euro (€) Value (Generated in UI):", input$input3)
  })
  
  output$output4 <- renderText({
    paste("Pound (£) Value (Generated in Server):", input$input4)
  })
  
  output$output5 <- renderText({
    paste("Dollar ($) Value (Generated in Server):", input$input5)
  })
  
  output$output6 <- renderText({
    paste("Euro (€) Value (Generated in Server):", input$input6)
  })
}

shinyApp(ui, server)