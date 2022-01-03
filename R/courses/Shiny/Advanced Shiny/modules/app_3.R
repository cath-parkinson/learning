# 19.3.5
# https://mastering-shiny.org/scaling-modules.html
library(shiny)


# helper function
find_vars <- function(data, filter) {
  stopifnot(is.data.frame(data))
  stopifnot(is.function(filter))
  names(data)[vapply(data, filter, logical(1))]
}



# dataset module ui
datasetInput <- function(id, filter = NULL) {
  names <- ls("package:datasets")
  ns <- NS(id)
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



# module ui - histogram
histogramOutput <- function(id) {
  
  ns <- NS(id)
  tagList(
    numericInput(ns("bins"), "bins", 10, min = 1, step = 1),
    plotOutput(ns("hist"))
  )
}

# module server - histogram
histogramServer <- function(id, x, title = reactive("Histogram")) {
  stopifnot(is.reactive(x))
  stopifnot(is.reactive(title))
  
  moduleServer(id, function(input, output, session) {
    output$hist <- renderPlot({
      req(is.numeric(x()))
      main <- paste0(title(), " [", input$bins, "]")
      hist(x(), breaks = input$bins, main = main)
    }, res = 96)
  })
}

# bring together in app function
histogramApp <- function() {
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        datasetInput("data", is.data.frame),
        selectVarInput("var"),
      ),
      mainPanel(
        histogramOutput("hist")    
      )
    )
  )
  
  server <- function(input, output, session) {
    data <- datasetServer("data")
    x <- selectVarServer("var", data)
    histogramServer("hist", x)
  }
  shinyApp(ui, server)
} 

histogramApp()

