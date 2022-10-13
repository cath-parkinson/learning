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
    
    myvals <- eventReactive(input$mybutton, {
      
      myvals() + myinteger()
      
    })
    
  return(myvals)
    
  })
}

ui <- fluidPage(
  
  mymod_ui("one"),
  mymod_ui("two"),
  textOutput(outputId = "val"),
  actionButton("debug", "Debug")
  
)

server <- function(input, output, session){
  
  # initialise value
  myvals <- reactive({ 0 })
  
  output$val <- renderText({ myvals() })
  
  myvals <- mymod_server("one", myvals())
  mymod_server("two", myvals)
  
  observeEvent(input$debug, {
    
    browser()
  })
  
}

shinyApp(ui = ui, server = server)