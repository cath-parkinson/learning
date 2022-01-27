# update values module -------------------------------------


update_values_ui <- function(id){
  
  ns <- NS(id)
  tagList(
    
    textOutput(outputId = ns("show_mylist"))
  )
  
}

update_values_server <- function(id, mylist){
  
  moduleServer(id, function(input, output, session){
    
    output$show_mylist <- renderText({ mylist$mylist })
    
  })
}

# master module --------------------------------------------

mod_ui <- function(id){
  
  ns <- NS(id)
  fluidPage(
    "Prove that we can call the scenario table module twice",
    update_values_ui(ns("ex1"))
    # textOutput(ns("show_scenarios"))
    
  )
  
}

mod_server <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    mylist <- reactiveValues(mylist = 1)
    
    update_values_server("ex1"
                         , mylist
                         ) # do I pass mylist or mylist$mylist?
    
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