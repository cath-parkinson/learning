library(shiny)
library(ggplot2)
library(shinyWidgets)
library(readxl)
library(dplyr)
library(highcharter)
library(tidyr)

# CSS options for the noUI slider ---------------------

# https://refreshless.com/nouislider/examples/#section-hiding-tooltips


# Basic color theme for app -----------------------

background <- "#001D38" # grey
# highlight2 <- "#4F24EE" # vib blue
highlight2 <- "#000000" # black
# highlight4 <- "#7D26C9" # vib purble
highlight4 <- "#FF2CE4" # bright clarity pink
highlight3 <- "#00DC7C" # vib green
# highlight1 <- "#4DBAC1" # vib teal
highlight1 <- "#7F7F7F" # darker grey
# highlight1 <- "#001D38" # master blue
# neutral1 <- "#CBF6FF" # pas blue
neutral1 <- "#000000" # black


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
  
  titlePanel("EXAMPLE"),
  
  # shinyWidgets::actionBttn(inputId = "debug",
                           # label = "DEBUG"),
  
  fluidRow(
    column(width = 4,
           uiOutput("driver_ui"),
           uiOutput("run_ui")
    ),
    
    column(width = 8, ""
    ))
)

server <- function(input, output) {
  
  observeEvent(input$debug,{ browser() })
  
  
  # Slider UI -------------------------
    
  output$driver_ui <- renderUI({
    
    sliders <- lapply(1:1, function(i) {
      
      div(id = "bttn-slider-row",
          fixedRow(
        column(width = 4,
               div(id = "bttn-row",
                 shinyWidgets::actionBttn(paste0(i, "MY BUTTON"),
                                        label = "MY BUTTON",
                                        color = "success",
                                        style = "pill",
                                        size = "sm"))
        ),
        column(width = 8,
               div(id = "slider-row",
                   shinyWidgets::noUiSliderInput(paste0(i, "MY SLIDER"),
                                                 min = 0,
                                                 max = 2,
                                                 value = 1,
                                                 tooltips = TRUE, 
                                                 update_on = c("end"),
                                                 step = 0.1,
                                                 color = "#7F7F7F",
                                                 width = "100%"
                                                 )
               )
        )
        
      ),
      br()
    )
    })
    
    tagList(sliders)
  })
  
  
}

shinyApp(ui, server)