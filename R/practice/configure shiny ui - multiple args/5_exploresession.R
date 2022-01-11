ui <- fluidPage()

server <- function(input, output, session) {
  
  test <- list(session)
  return(test)
}


shinyApp(ui = ui, server = server)



mylist <- list("hello", "hi")
secondlist <- list("goodbye")
anotherlist <- c(mylist, secondlist)
