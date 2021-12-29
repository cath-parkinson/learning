ui <- fluidPage(
  selectInput("language", "Language", choices = c("", "English", "Maori")),
  textInput("name", "Name"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  greetings <- c(
    English = "Hello", 
    Maori = "Kia ora"
  )
  output$greeting <- renderText({
    
    # add require to ensure that shiny doesn't try to execute before we've selected the language
    req(input$language, input$name)
    paste0(greetings[[input$language]], " ", input$name, "!")
  })
}


shinyApp(ui = ui, server = server)

