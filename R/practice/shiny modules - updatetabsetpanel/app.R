mod_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(ns("back"), "back")
  )
}

mod <- function(input, output, session,parent_session){
  observeEvent(input$back, {
    print("Button click, go back to home tab")
    updateTabsetPanel(session = parent_session, inputId = "tabs", selected = "home")
  })
}

ui <- navbarPage(
  "example",
  id = "tabs",
  tabPanel(
    "home",
    h4("updateTabsetPanel does not work with modules"),
    h5("But the button below does"),
    actionButton("switch", "switch")
  ),
  tabPanel(
    "secondtab",
    mod_ui("second")
  )
)

server <- function(input, output, session){
  callModule(mod, "second",parent_session = session)
  observeEvent(input$switch, {
    updateTabsetPanel(session = session, inputId = "tabs", selected = "secondtab")
  })
}

shinyApp(ui = ui, server = server)