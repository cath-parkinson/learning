ymdDateUI <- function(id, label) {
  label <- paste0(label, " (yyyy-mm-dd)")
  
  fluidRow(
    textInput(NS(id, "date"), label),
    textOutput(NS(id, "error"))
  )
}

ymdDateServer <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    error_message <- reactive({
      
      mydate <- strptime(input$date, format = "%Y-%m-%d")
      
      if(is.na(mydate)) { "Not a correct date" }
      else { error_message <- paste("Correct date!", format(mydate, format = "%d %B %Y")) }
      
    }) 
    
        
    
    output$error <- renderText(error_message())
    
  })
  
}


ui <- function(){
  
  fluidPage(
    ymdDateUI("date", "Enter a date:")
  )
  
}

server <- function(input, output, session){
  
  ymdDateServer("date")
}

shinyApp(ui = ui, server = server)

# testing 

# x <- "1989-08-07"
# x <- "19890807"
# x <- ""
# y <- strptime(x, "%Y-%m-%d")
# attributes(y)
# is.na(y)
# y
# class(y)
# typeof(y)
