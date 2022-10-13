# Q. Do we need to return the value from the inner module to the outer module?
# A. When, using reactive values ...NO

mymod_ui <- function(id){
  
  ns <- NS(id)
  tagList(
    actionButton(inputId = ns("mybutton"), label = paste("add", id))
  )

}

mymod_server <- function(id, myvals){
  moduleServer(id, function(input, output, session){
    
    myinteger <- reactive({

      if(id == "one"){ 1 } else { 2 }

    })
    
    observeEvent(input$mybutton, {

      myvals$master <- myvals$master + myinteger()

    })
    
  # return(reactive(myval()))
    
  })
}

ui <- fluidPage(
  
  mymod_ui("one"),
  mymod_ui("two"),
  textOutput(outputId = "val")
  
)

server <- function(input, output, session){
  
  # initialise value
  myvals <- reactiveValues()
  myvals$master <- 0
  
  output$val <- renderText({ myvals$master })
  
  mymod_server("one", myvals)
  mymod_server("two", myvals)
  
}

shinyApp(ui = ui, server = server)