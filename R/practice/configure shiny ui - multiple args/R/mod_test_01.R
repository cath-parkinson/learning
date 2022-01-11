
#### UI ####
mod_test_01_ui <- function(id) {
  
  ns <- NS(id)
  
  tagList( h2("Welcome to the Operating System!"),
           br(),
           h4(strong("Start New Project")),
           actionButton(label = "Start",
                        inputId = ns("new_project"), icon = icon("play"),),
           br(),
           textOutput(outputId = ns("text")),
           # fileInput(label = h4(strong("Load Existing Project")),
           #           inputId = ns("existing_project"),
           #           placeholder = "No project selected")
           sliderInput(inputId = ns("slider"),
                       label = "test", min = 0, max = 10, value = 1),
           textOutput(outputId = ns("answer")),
           textOutput(outputId = ns("tellmeid"))
           
  )
  
}

##### Server #####
mod_test_01_server <- function(id) {

    moduleServer(id,
                 function(input, output, session){
                   
                   # observeEvent(input$new_project,{
                   #   
                   #   shinyalert(title = "You're Underway....",
                   #              text = "well done you clicked a button",
                   #              type = "success")
                   #   
                     # updateTabItems(session = parentsession,inputId = "tabs",selected = "database")
                     
                   # })
                   
                   text <- eventReactive(input$new_project, { return("well done you clicked a button") })
                   output$text <- renderText({ text() })
                   output$answer <- renderText({ input$slider })
                   output$tellmeid <- renderText({ id })
                   
                   
              
                 })

}

# test module home working

# ui <- fluidPage(home_ui("home1"))
# server <- function(input, output, session){ home_server("home1")}
# 
# shinyApp(ui = ui, server = server)



