ui <- fluidPage(
  
  selectInput("my_input", 
              "select an option", 
              choices = list("EC"  = list("NY", "NJ", "CT"),
                             "WC" = list("WA", "OR", "CA")))
)

server <- function(input, output, session){
  
  
}

shinyApp(ui = ui, server = server)