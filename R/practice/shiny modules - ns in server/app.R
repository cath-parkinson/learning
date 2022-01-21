# libraries

library(shiny)
library(shinyalert)
library(shinydashboard)
library(shinyjs)
library(tidyverse)

# run app
ui <- function(){ mod_04_modellingtool_26_ui("mt") }
server <- function(input, output, session){ mod_04_modellingtool_26_server("mt", parentsession) } # this can't be named session or it breaks

shinyApp(ui = ui, server = server)
