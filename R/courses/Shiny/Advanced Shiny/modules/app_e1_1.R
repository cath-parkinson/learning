# 19.3.7 excercise 1
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
  moduleServer(id, function(input, output, session) {
    reactive(get(input$dataset, "package:datasets"))
  })
}

filterInput <- function(id){
  
  ns <- NS(id)
  selectInput(ns("filter"), "Filter", choices = c("numeric", "character", "factor"))
  
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
selectVarInput <- function(id, name) {
  ns <- NS(id)
  selectInput(ns("var"), name, choices = NULL) 
}


# returns a list of variables
selectVarServer <- function(id, data, filter, type) {
  
  stopifnot(is.reactive(data))
  # this will be changed to be reactive
  stopifnot(is.reactive(filter))
  
  moduleServer(id, function(input, output, session) {
    
    observeEvent(data(), {
      # update this to update the select input associated with whichever is
     updateSelectInput(session, id, choices = find_vars(data(), filter()))
    })
      
    
    })
}

# bring it together in an app
selectVarApp <- function() {
  ui <- fluidPage(
    datasetInput("data", is.data.frame),
    filterInput("filter"),
    selectVarInput("var", name = "Variable"),
    verbatimTextOutput("out")
  )
  server <- function(input, output, session) {
    data <- datasetServer("data")
    # add filter here 
    # filter <- selectVarServer("filter", data)
    var <- selectVarServer("var", data, is.numeric, type = "var")
    output$out <- renderPrint(var())
  }
  
  shinyApp(ui, server)
}

selectVarApp()
