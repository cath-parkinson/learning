# libraries

library(shiny)
library(shinyalert)
library(shinydashboard)
library(shinyjs)
library(tidyverse)


source("R/mod_04_modellingtool_26_v2.R")

# run app
ui <- function(){ mod_04_modellingtool_26_ui_v2("mt") }
server <- function(input, output, session){ mod_04_modellingtool_26_server_v2("mt", session) } # this can't be named session or it breaks

options(shiny.trace = TRUE)
shinyApp(ui = ui, server = server)
