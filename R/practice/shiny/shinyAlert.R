# Note - this is more powerful than shinywidgets version which doesn't allow you to assign an inputID
library(shiny)
library(shinyalert)

# Customise our own shiny alert

#' @param myinputId name the input - namespace if neccesary
#' @param mytitle  title of alert
#' @param mytext "" or "name-desc" or "desc-inputname"
#'
#' @return A shiny alert function.
mm_shinyalert <- function(myinputId,
                            mytitle,
                            mytext = c(""),
                            myconfirmButtonText = "ENTER",
                            confirmButtonCol = "#28b78d"){
  
  if(mytext == "name-desc") { tagList(HTML(paste(strong("PIPE IN NAME:"), "pipe in desc"))) }
  
  if(mytext == "desc-inputname") { tagList(
    
    HTML(
      
      paste(strong("Description:"), "pipe in desc")),
    
    textInput(inputId = "user_name_scenario",
              label = "",
              width = "100%",
              placeholder = "Give your scenario a name")) }
  
  shinyalert(inputId = myinputId,
             title = mytitle,
             text = mytext,
             type = "",
             confirmButtonText = myconfirmButtonText,
             cancelButtonText = "CANCEL",
             showCancelButton = TRUE,
             showConfirmButton = TRUE,
             confirmButtonCol = "#001D38",
             html = TRUE)
  
}



ui <- fluidPage(
  actionButton(inputId = "button",
               label = "GO"),
  actionButton(inputId = "button_save",
               label = "SAVE"),
  actionButton(inputId = "button_save_as",
               label = "SAVE AS"),
  actionButton(inputId = "button_new",
               label = "NEW"),
  actionButton(inputId = "mybutton",
               label = "TEST")
  
)
server <- function(input, output, session) {
  
  observeEvent(input$button, {
    
    shinyalert(inputId = "mmm_run_user_confirm",
               title = "SCENARIO LOADED",
               text = tagList(HTML(paste(strong("PIPE IN NAME:"), "pipe in desc"))), 
               type = "",
               confirmButtonText = "RUN",
               cancelButtonText = "CANCEL",
               showCancelButton = TRUE,
               showConfirmButton = TRUE,
               confirmButtonCol = "#28b78d",
               html = TRUE)
    
  })
  
  observeEvent(input$button_save, {
    
    shinyalert(inputId = "mmm_run_user_confirm",
               title = "SAVE SCENARIO",
               text = tagList(HTML(paste(strong("PIPE IN NAME:"), "pipe in desc"))), 
               type = "",
               confirmButtonText = "SAVE",
               cancelButtonText = "CANCEL",
               showCancelButton = TRUE,
               showConfirmButton = TRUE,
               confirmButtonCol = "#001D38",
               html = TRUE)
    
  })
  
  
  observeEvent(input$button_save_as, {
    
    shinyalert(inputId = "mmm_run_user_confirm",
               title = "SAVE SCENARIO",
               text = tagList(
                 
                 HTML(
                 
                 paste(strong("Description:"), "pipe in desc")),
                 
                 textInput(inputId = "user_name_scenario",
                           label = "",
                           width = "100%",
                           placeholder = "Give your scenario a name")),
               type = "",
               confirmButtonText = "SAVE",
               cancelButtonText = "CANCEL",
               showCancelButton = TRUE,
               showConfirmButton = TRUE,
               confirmButtonCol = "#001D38",
               html = TRUE)
    
  })
  
  
  observeEvent(input$button_new, {
    
    shinyalert(inputId = "mmm_run_user_confirm",
               title = "NEW SCENARIO",
               text = "",
               type = "",
               confirmButtonText = "CREATE",
               cancelButtonText = "CANCEL",
               showCancelButton = TRUE,
               showConfirmButton = TRUE,
               confirmButtonCol = "#001D38",
               html = TRUE)
    
  })
  
  observeEvent(input$mybutton, {
    
    reop_shinyalert(myinputId = "mynewbutton",
                    mytitle = "MY TEST",
                    mytext = "")
      })
  
  
  
}
shinyApp(ui, server)