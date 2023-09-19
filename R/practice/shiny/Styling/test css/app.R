library(shiny)
library(ggplot2)
library(shinyWidgets)
library(readxl)
library(dplyr)
library(highcharter)
library(tidyr)

# Helper functions
actionBttn_os <- function(inputId, 
                          label = NULL, 
                          icon = NULL, 
                          style = "material-flat",
                          color = "success",
                          size = "md", 
                          block = FALSE,
                          no_outline = TRUE, 
                          my_additional_style = "") {
  value <- shiny::restoreInput(id = inputId, 
                               default = NULL)
  style <- match.arg(
    arg = style,
    choices = c("simple", "bordered", "minimal", "stretch", "jelly",
                "gradient", "fill", "material-circle", "material-flat",
                "pill", "float", "unite")
  )
  color <- match.arg(
    arg = color,
    choices = c("default", "primary", "warning", "danger", "success", "royal")
  )
  size <- match.arg(arg = size, choices = c("xs", "sm", "md", "lg"))
  
  tagBttn <- htmltools::tags$button(
    id = inputId,
    type = "button", 
    class = "action-button bttn", 
    `data-val` = value,
    class = paste0("bttn-", style), 
    class = paste0("bttn-", size),
    class = paste0("bttn-", color), 
    list(icon, label),
    class = if (block) "bttn-block",
    class = if (no_outline) "bttn-no-outline",
    style = my_additional_style
  )
  shinyWidgets:::attachShinyWidgetsDep(tagBttn, "bttn")
}



# UI ------------------------

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        font-family: Calibri;
        background-color: #EAE8E4;
        color: #000000;
      }
    ")),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  titlePanel("Test UI elements"),
  splitLayout(
    cellWidths = c("33%", "33%"),
    selectInput(
      inputId = "scenario_name2",
      label = "Choose Scenario",
      choices = NULL
    ),
    actionBttn_os(
      inputId = "reset_filter",
      label = "Reset Filters",
      color = "primary",
      style = "minimal",
      size = "sm"
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$debug,{ browser() })
  
  
}

shinyApp(ui, server)