library(shiny)
library(rhandsontable)

set.seed(1234)

# Data and a couple utility functions
nrow <- 1000
DF <- data.frame(a = 1:nrow,b = abs(rnorm(nrow)), c = abs(rnorm(nrow)))
lastrow <- 1

getrowfromDF <- function(idx) {
  return(DF[idx,])
}

putrowintoDF <- function(rowdf,idx) {
  # browser()
  for (ic in 1:ncol(DF)) {
    DF[idx,ic] <<- rowdf[1,ic]
    print(DF[idx,ic])

  }
  
  print("reset")
}




# App
u <- shinyUI(fluidPage(
  numericInput("row",
               "row to filter",
               value = lastrow,
               min = 1,
               max = nrow(DF)),
  verbatimTextOutput("rowstat"),
  rHandsontableOutput("hot"),
  actionButton("debug", "DEBUG"),
  textOutput("rs"),
  uiOutput("allDF")
))

s <- shinyServer(function(input,output,session) {
  
  # reactive row status
  rs <- reactiveValues()
  rs$lstrow <- rs$currow <- 1 # start both values at 1
  
  # record changes from user editing here
  observeEvent(input$hot, {
    if (!is.null(input$hot)) {
      ndf <- data.frame(input$hot$data)  # convert from list
      
      # version 1 from stack overflow - does allow you to play around with the first column (wth!)
      putrowintoDF(ndf,rs$currow)   # original - has inconsistency issue when
      # you change rows without closing edit
      # with enter key in rhandsontable grid input$hot
      # this version 
      
      # version 2 in stack overflow - doesn't allow you to play around with the first column
      # putrowintoDF(ndf,ndf[1,1])     # new, consistent, but relies on editable data for state
    }
  })
  
  # slide the row to the new position here
  observeEvent(input$row, {
    rs$lstrow <<- rs$currow
    rs$currow <<- input$row
  })
  
  
  # render handsontable output
  output$hot <- renderRHandsontable({
    ndf <- getrowfromDF(rs$currow)
    rhandsontable(ndf)
  })
  
  # just for debug
  output$rowstat <- renderPrint({ sprintf("rowstat: current:%d previous:%d",rs$currow,rs$lstrow) })
  
  observeEvent(input$debug, {
    
    browser()
    
  })
  
  output$rs <- renderText({
    
    paste(rs$lstrow, rs$currow)
    
  })
  
  myDF <- reactive({
    
    DF
  })
  
  output$allDF <- renderTable({
    
    myDF()
    
  })
  
})
shinyApp(ui = u,server = s)