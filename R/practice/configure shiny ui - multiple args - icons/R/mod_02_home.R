
#### UI ####
mod_02_home_01_ui <- function(id) {
  ns <- NS(id)
  
 tagList( h2("Welcome to the Operating System!!!!"),
          br(),
          h4(strong("Start New Project")),
          actionButton(label = "Start",
                       inputId = ns("new_project"), icon = icon("play"),),
          br(),
          fileInput(label = h4(strong("Load Existing Project")),
                    inputId = ns("existing_project"),
                    placeholder = "No project selected")
 )
  
}

##### Server #####
mod_02_home_01_server <- function(id,parentsession) {

    moduleServer(id,
                 function(input, output, session){
                   
                   observeEvent(input$new_project,{
                     
                     # browser()
                     
                     shinyalert(title = "You're Underway....",
                                text = "well done you clicked a button",
                                type = "success")
                     
                     updateTabItems(session = parentsession,
                                    inputId = "tabs",
                                    # selected = "downloads", #works
                                    # selected = "data"  # does not work
                                    selected = "database" #works
                                    )
                     
                   })
                   
              
                 })

  }