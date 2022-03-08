library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Value boxes"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      # A static valueBox
      valueBox(paste0("£", 300000), "SPEND", icon = icon("credit-card"),
               width = 2),
      
      # Dynamic valueBoxes
      valueBoxOutput("progressBox",
                     width = 2),
      
      valueBoxOutput("approvalBox",
                     width = 2),
      
      valueBox(40, "A second Box",
               width = 2),
      
      valueBox(50, "Another box",
               width = 2)
    ),
    fluidRow(
      # Clicking this will increment the progress amount
      box(width = 4, actionButton("count", "Increment progress"))
    )
  )
)

server <- function(input, output) {
  output$progressBox <- renderValueBox({
    valueBox(
      paste0(25 + input$count, "%"), "Progress", icon = icon("list"),
      color = "purple"
    )
  })
  
  output$approvalBox <- renderValueBox({
    valueBox(
      "80%", "Approval", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
}

shinyApp(ui, server)