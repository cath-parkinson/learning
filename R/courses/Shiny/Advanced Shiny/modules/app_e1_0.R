# 19.3.7 excercise 1
# https://mastering-shiny.org/scaling-modules.html
library(shiny)

# helper function
find_vars <- function(data, filter) {
  stopifnot(is.data.frame(data))
  stopifnot(is.function(filter))
  names(data)[vapply(data, filter, logical(1))]
}




# new ui module making use of inputSelect()

# bring it together in an app
myselectVarApp <- function(filter = is.numeric) {
  ui <- fluidPage(
    combined_selectVarInput("data", is.data.frame,"var"),
    verbatimTextOutput("out")
  )
  server <- function(input, output, session) {
    data <- combined_selectVarServer("data", "var", data, filter = filter)[[1]]
    var <- combined_selectVarServer("data", "var", data, filter = filter)[[2]]
    output$out <- renderPrint(var())
  }
  
  shinyApp(ui, server)
}

myselectVarApp()

