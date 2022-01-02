ui <- fluidPage(
  textInput("name", "name"),
  actionButton("add", "add"),
  actionButton("del", "delete"),
  textOutput("names")
)
server <- function(input, output, session) {
  r <- reactiveValues(names = character())
  observeEvent(input$add, {
    r$names <- union(r$names, input$name)
    updateTextInput(session, "name", value = "")
  })
  observeEvent(input$del, {
    r$names <- setdiff(r$names, input$name)
    updateTextInput(session, "name", value = "")
  })
  
  output$names <- renderText(r$names)
}

shinyApp(ui = ui, server = server)

# understand setdiff

# all these funtions remove dublicates in different ways

x <- c(sort(sample(1:20,9)), NA)
y <- c(sort(sample(3:23,7)), NA)

#keeps all unique values
union(x,y)

# keeps all dublicate values
intersect(x,y)

# keeps all unique values of x that do not appear in y 
setdiff(x,y)

# keeps all unique values of y that do not appear in x 
setdiff(y,x)

# checks for equality - delivers true or false
setequal(x,y)


