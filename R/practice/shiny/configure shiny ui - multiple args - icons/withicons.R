library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinyalert)

# source("R/funcs_01_os.R")

# call app ----------------------------------------------

# config <- read_config()
# 
# config <- tibble(tabname = c("home", "database"),
#                  module = c("home", "data"),
#                  mod_ui = c("mod_02_home_01_ui","mod_02_home_01_ui"),
#                  mod_server = c("mod_02_home_01_server", "mod_02_home_01_server"),
#                  ui_param = list(list("home1"), list("database1")),
#                  server_param = list(list("home1"), list("database1")),
#                  sidebar_type = c("menuItem", "menuItem"),
#                  sidebar_text = c("Home", "Data"),
#                  sidebar_parent = c("N", "N"),
#                  sidebar_parent_tabname = c("home", "database"),
#                  icon = c("home", "table"))

config <- tibble(tabname = c("home", "database", "database2"),
                 module = c("home", "data", "data"),
                 mod_ui = c("mod_02_home_01_ui","mod_02_home_01_ui", "mod_02_home_01_ui"),
                 mod_server = c("mod_02_home_01_server", "mod_02_home_01_server", "mod_02_home_01_server"),
                 ui_param = list(list("home1"), list("database1"), list("database2")),
                 server_param = list(list("home1"), list("database1"), list("database2")),
                 sidebar_type = c("menuItem", "menuItem", "menuSubItem"),
                 sidebar_text = c("Home", "Data", "Data2"),
                 sidebar_parent = c("N", "Y", "N"),
                 sidebar_parent_tabname = c("home", "database", "database"),
                 icon = c("home", "table", "table"))


ui <- function(){ mod_os_ui("os", config) }
server <- function(input, output, session){ mod_os_server("os", config, session) }

shinyApp(ui = ui, server = server)
