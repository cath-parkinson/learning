# Note - this is more powerful than shinywidgets version which doesn't allow you to assign an inputID
library(shiny)
library(shinyalert)

ui <- fluidPage(
  actionButton(inputId = "button",
               label = "GO")
)
server <- function(input, output, session) {
  
  observeEvent(input$button, {
    
    shinyalert(inputId = "mmm_run_user_confirm",
               title = "SCENARIO LOADED",
               text = tagList(HTML(paste(strong("NEW:"), "pipe in desc"))), 
               type = "",
               confirmButtonText = "RUN",
               cancelButtonText = "CANCEL",
               showCancelButton = TRUE,
               showConfirmButton = TRUE,
               confirmButtonCol = "#28b78d",
               html = TRUE)
    
  })
  
}
shinyApp(ui, server)