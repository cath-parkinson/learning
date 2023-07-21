
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
    
    tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css"),
    
    tabItems(
      tabItem(tabName = "dashboard",
                      div(id = "myvalbox",
                          valueBox(32,
                               "Lorem ipsum dolor sit amet, consectetur adipiscing elit, 
                               sed do eiusmod tempor incididunt ut labore et dolore magna 
                               aliqua. Ut enim ad minim veniam, quis nostrud exercitation
                               ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis 
                               aute irure dolor in reprehenderit in voluptate velit esse 
                               cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat 
                               cupidatat non proident, sunt in culpa qui officia deserunt mollit
                               anim id est laborum.")),
              bsTooltip(id = "myvalbox", title = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
              actionButton(inputId = "debug",
                           label = "DEBUG"))
  )
))

# Define server
server <- function(input, output, session) {
  
  observeEvent(input$debug, {
    
    browser()
    
  })
}

# Run the app
shinyApp(ui = ui, server = server)