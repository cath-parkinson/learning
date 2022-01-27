# Pass and return reactive values from the modules
# Crikey I think it's working

# update values module -------------------------------------

update_values_ui <- function(id){
  
  ns <- NS(id)
  tagList(
    
    actionButton(inputId = ns("update_value"),
                 label = "Update value"),
    textOutput(outputId = ns("show_mylist"))
  )
  
}

update_values_server <- function(id, mylist){
  
  moduleServer(id, function(input, output, session){
    
    output$show_mylist <- renderText({ mylist$mylist })
    
    observeEvent(input$update_value, { # we need to update reactiveValues using a observe event

      mylist$mylist <- mylist$mylist + 1

    })
    
    return(mylist)
    
  })

}

# master module --------------------------------------------

mod_ui <- function(id){
  
  ns <- NS(id)
  fluidPage(
    update_values_ui(ns("ex1")),
    update_values_ui(ns("ex2")),
    textOutput(ns("value_outside_mod"))
    
  )
  
}

mod_server <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    mylist <- reactiveValues(mylist = 1)
    mylist <- update_values_server("ex1", mylist) # I pass and return the whole mylist object
    mylist <- update_values_server("ex2", mylist) # I pass and return the whole mylist object
    
    output$value_outside_mod <- renderText({

      mylist$mylist/10

    })
    
  })
  
}

# call app
ui <- function() { fluidPage( mod_ui("reop")) }
server <- function(input, output, session) { mod_server("reop") }

shinyApp(ui = ui, server = server)