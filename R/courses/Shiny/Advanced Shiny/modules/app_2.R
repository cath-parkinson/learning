# 19.3.2
# https://mastering-shiny.org/scaling-modules.html
library(shiny)


# dataset module ui
datasetInput <- function(id, filter = NULL) {
  
  ns <- NS(id)
  names <- ls("package:datasets")
  # produces a list of names in the datasets package that is a dataframe
    if (!is.null(filter)) {
    data <- lapply(names, get, "package:datasets")
    names <- names[vapply(data, filter, logical(1))]
  }
  
  selectInput(ns("dataset"), "Pick a dataset", choices = names)
}

# dataset module server 
datasetServer <- function(id) {
  # input$dataset is the name of the dataset selected
  # get passes back the actual dataframe
  moduleServer(id, function(input, output, session) {
    reactive(get(input$dataset, "package:datasets"))
  })
}

# helper function
# pass the dataframe
# pass the filter function you want e.g. is.numeric, is.character, is.factor
# passes back a list of variables that match the dataset and filter

find_vars <- function(data, filter) {
  stopifnot(is.data.frame(data))
  stopifnot(is.function(filter))
  names(data)[vapply(data, filter, logical(1))]
}

# module ui
selectVarInput <- function(id) {
  ns <- NS(id)
  selectInput(ns("var"), "Variable", choices = NULL) 
}


# module server that returns a name and a value
selectVarServer <- function(id, data, filter = is.numeric) {
  
  stopifnot(is.reactive(data))
  stopifnot(!is.reactive(filter))
  
  moduleServer(id, function(input, output, session) {
    observeEvent(data(), {
      updateSelectInput(session, "var", choices = find_vars(data(), filter))
    })
    
    reactive(data()[[input$var]])
  })
}

# bring it together in an app
selectVarApp <- function(filter = is.numeric) {
  ui <- fluidPage(
    datasetInput("data", is.data.frame),
    selectVarInput("var"),
    verbatimTextOutput("out")
  )
  server <- function(input, output, session) {
    data <- datasetServer("data")
    var <- selectVarServer("var", data, filter = filter)
    output$out <- renderPrint(var())
  }
  
  shinyApp(ui, server)
}

selectVarApp()
