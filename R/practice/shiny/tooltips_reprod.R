
# Load required packages
library(shinydashboard)
library(shinyBS)

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Simple Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                div(id = "box1",
                    box(
                  title = "Value 1",
                  valueBoxOutput("valueBox1"),
                  div(id = "textbox1", textOutput("text1"))
                )),
                bsTooltip(id = "valbox1", "Not working"),
                bsTooltip(id = "textbox1", "Working as expected"),
              ),
              fluidRow(
                div(id = "box2",
                    box(
                      title = "Value 2",
                      valueBox(32,
                               div(id = "valbox2", "Value 2")),
                      div(id = "textbox2", textOutput("text2"))

                    )),
                bsTooltip(id = "valbox2", "Working as expected"),
                bsTooltip(id = "textbox2", "Working as expected"),
                
              ),
              fluidRow(
                box(
                  actionButton("testButton", "TEST")
                )
              ),
              bsTooltip(id = "testButton", "Working as expected")
      )
    )
  )
)

# Define server
server <- function(input, output, session) {
  # Generate dummy data
  data <- data.frame(
    Value1 = sample(1:100, 1)
  )
  
  # Update value boxes when the action button is clicked
  observeEvent(input$testButton, {
    data$Value1 <- sample(1:100, 1)
    output$valueBox1 <- renderValueBox({
      valueBox(data$Value1,
               div(id = "valbox1", "Value 1"))
    })
    output$text1 <- renderText({
      "More info on Value 1"
    })
  })
  
  output$text2 <- renderText({
    "More info on Value 2"
  })
}

# Run the app
shinyApp(ui = ui, server = server)