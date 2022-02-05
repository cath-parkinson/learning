# packages for portal 


library(shiny)
library(shinyjs)
library(shinyWidgets)
library(shinydashboard)
library(tidyr)

# new libraries not in dashboard
library(dashboardthemes)
library(shinyBS)

## UI: sidebar --------------------

sidebar <- dashboardSidebar(
  
  # move this back
  sidebarMenu(
    id = "mastertabs",
    actionBttn_os(
      inputId = "run", 
      label = "RUN SCENARIO",
      color = "primary"),
    convertMenuItem(menuItem(text = "CREATE SCENARIO", 
                             tabName = "mmm_master", 
                             icon = icon("wrench"),
             menuItem(text = "Choose time frame", 
                         tabName = "mmm_master_timeframe",
                         selectInput(inputId = "set_timeframe",
                                     label = "",
                                     choices = "")),
             menuItem(text = "Set KPI", 
                         tabName = "mmm_master_setkpi"),
             menuItem(text = "Set budget", 
                         tabName = "mmm_master_setbudget"),
             menuItem(text = "Manage scenarios",
                         tabName = "mmm_master_scenarios")), "mmm_master"),
    menuItem(text = "ADVANCED SETTINGS", tabName = "advanced_settings", icon = icon("search-minus")), # add in functionality to hide this
    menuItem(text = "MTA OPTIMISE", tabName = "mta_optimiser", icon = icon("chart-bar")),
    menuItem(text = "REFORECAST", tabName = "reforecast", icon = icon("chart-bar")))
)

## UI: body 
body <- dashboardBody(
  
  custom_theme,
  
  tabItems(
    
    tabItem(tabName = "mmm_master",
            fluidPage(mod_06_reoptimise_mmm_master_01_ui("reop_mmm"))
    )

  )
  
)

## Run app ------------------------------------------

ui <- dashboardPage(dashboardHeader(title = "BB TOOLS"),
                    sidebar,
                    body,
                    skin = "blue")


server <- function(input, output, session){
  
  mod_06_reoptimise_mmm_master_01_server("reop_mmm")

}

## run app ----------------------------------

shinyApp(ui, server)



