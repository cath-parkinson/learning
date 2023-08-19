library(shiny)
library(shinydashboard)
library(shinyWidgets)

# Helper function 
convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  if(length(mi$attribs$class)>0 && mi$attribs$class=="treeview"){
    mi$attribs$class=NULL
  }
  mi
}


# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Demo"),
  dashboardSidebar(
    sidebarMenu(
      convertMenuItem(
        menuItem(text = "Option1", 
                 tabName = "opt1",
                 shinyWidgets::pickerInput(inputId = "picker",
                                           label = "Select:",
                                           choices = c("Pick 1", "Pick 2", "Pick 3", "Pick 4", "Pick 5", "Pick 6"),
                                           selected = c(""),
                                           multiple = TRUE,
                                           options = list(`actions-box` = TRUE, 
                                                          `dropdownAlignRight` = TRUE,
                                                          `dropupAuto` = TRUE))),
        tabName = "opt1-outer"),
      menuItem("Option2", tabName = "opt2"),
      menuItem("Option3", tabName = "opt3")
    )
  ),
  dashboardBody(
    tags$style(HTML("
      /* Add your custom CSS styles here */
      #sidebarItemExpanded {
        height: 800px;
      }
    "))
  )
)
# Define server logic
server <- function(input, output) {
  
}

# Run the application
shinyApp(ui = ui, server = server)