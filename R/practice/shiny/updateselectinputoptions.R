library(shiny)
library(shinyjs)
library(tibble)

test <- tibble(project = c("Justin", "Corey","Sibley"),
               april_2021 = c(10, 100, 101),
               may_2021 = c(1, 4, 7))

ui <- fluidPage(
  useShinyjs(),
  
  sidebarLayout(
    sidebarPanel(
      div(id = "project_inputs",
          selectizeInput(inputId = "filter_by_project",
                         label = "Filter by Project",
                         choices = sort(unique(test$project)), 
                         multiple = TRUE,
                         selected = unique(test$project)[1] )),
      
      #I can't figure out the remove_all button
      actionButton(inputId = "remove_all", 
                   label = "Unselect All Projects", style = "color: #FFFFFF; background-color: #CA001B; border_color: #CA001B"),
      actionButton(inputId = "add_all", 
                   label = "Select All Projects", style = "color: #FFFFFF; background-color: #CA001B; border_color: #CA001B"),
    ),
    
    mainPanel(
    )
  )
)

server <- function(input, output, session) {
  
  observeEvent(input$remove_all, {
    updateSelectizeInput(session,
                         "filter_by_project",
                         choices=sort(unique(test$project)), 
                         selected=NULL, 
                         options = list(placeholder="Please Select at Least One Project")
    )
  })
  observeEvent(input$add_all, {
    updateSelectizeInput(session,
                         "filter_by_project",
                         choices=sort(unique(test$project)), 
                         selected=sort(unique(test$project)) )
  })
}

shinyApp(ui = ui, server = server)