# update values module -------------------------------------

update_values_ui <- function(id){
  
  ns <- NS(id)
  tagList(
    
    actionButton(inputId = ns("update_value"),
                 label = "Update value"),
    textOutput(outputId = ns("show_mylist")),
    textOutput(outputId = ns("show_new_value"))
  )
  
}

update_values_server <- function(id, mylist){
  
  moduleServer(id, function(input, output, session){
    
    output$show_mylist <- renderText({ mylist$mylist })
    
    mylist$mylist <- eventReactive(input$update_value, {

      mylist$mylist <- 2

    })


    # this works 
    new_value <- eventReactive(input$update_value, {
      
      mylist$mylist + 5
      
    })
    
    output$show_new_value <- renderText({ new_value() })
    
  })
}

# master module --------------------------------------------

mod_ui <- function(id){
  
  ns <- NS(id)
  fluidPage(
    update_values_ui(ns("ex1"))
    # textOutput(ns("show_scenarios"))
    
  )
  
}

mod_server <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    mylist <- reactiveValues(mylist = 1)
    
    update_values_server("ex1", mylist) # do I pass mylist or mylist$mylist?
    
    # output$show_scenarios <- renderText({
    #   
    #   list_out_scenarios(reop_master_list$reop_master_list)
    #   
    # })
    
  })
  
}

# call app
ui <- function() { fluidPage( mod_ui("reop")) }
server <- function(input, output, session) { mod_server("reop") }

shinyApp(ui = ui, server = server)