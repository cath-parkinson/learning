# 4) get the home module working with "session" passed to the sever
# can accept multiple arg
# session must be passed

library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinyalert)

source("R/funcs_config.R")

# funcs_bbos_ui ----------------------------------
build_sidebar_menu <- function(ns, config){
  
  menuitems_needed <- config %>% filter(sidebar_type == "menuItem") %>% select(tabname) %>% pull()
  
  # 1) menuitems without submenuItems ---------------------------
  config_without <- config %>% filter(sidebar_type == "menuItem" & sidebar_parent == "N")
  build_sidebar_menu_item <- function(x,y) { menuItem(text = x, tabName = y) }
  
  if(nrow(config_without)>0){
    
    list_menuItems_without <- mapply(build_sidebar_menu_item, 
                                     config_without$sidebar_text, 
                                     config_without$tabname,
                                     SIMPLIFY = F,
                                     USE.NAMES = F) } else { list_menuItems_without <- list() }
  
  # 2) menuitems with submenuItems ----------------------------------
  config_with <- config %>% filter(sidebar_type == "menuItem" & sidebar_parent == "Y")
  config_subitems <- config %>% filter(sidebar_type == "menuSubItem")
  
  if(nrow(config_with)>0){
    
    list_menuItems_with <- build_sidebar_menu_subitems(config_with, config_subitems) } else {
      
      list_menuItems_with <- list()
    }
  
  # bring together
  list_menuItems <- c(list_menuItems_without, list_menuItems_with)
  
  # make final list
  list_menuItems <- c(
    # id = ns("tabs"), 
    id = "tabs", 
    list_menuItems)
  
  return(list_menuItems)
}



build_sidebar_menu_subitems <- function(config_with, config_subitems){
  
  list_menuItems_with <- list()
  
  # loop over each menuitem we need to make
  for (i in 1:nrow(config_with)){
    
    # get the tabname and text needed
    tabname_i <- config_with %>% slice(i) %>% select(tabname) %>% pull()
    text_i <- config_with %>% slice(i) %>% select(sidebar_text) %>% pull()
    
    # get the corresponding table of subitems that we need to addinto the menuitem
    config_subitems_i <- config_subitems %>% filter(sidebar_parent_tabname == tabname_i)
    
    # create list of subitems
    list_menuSubItems <- mapply(function(x,y){ menuSubItem(text = x, tabName = y)},
                                config_subitems_i$sidebar_text, 
                                y = config_subitems_i$tabname,
                                SIMPLIFY = F,
                                USE.NAMES = F)
    
    # pass the list of sub menus into the 
    menuItem_args <- c(text = text_i,
                       tabName = tabname_i,
                       list_menuSubItems)
    
    # make the menuItem!
    list_menuItems_with[[i]] <- do.call(menuItem, menuItem_args)
    
  }
  
  return(list_menuItems_with)
}


build_body_tabItems <- function(config) {
  
  build_body_tabItem <- function(x,y,z) { tabItem(tabName = x, do.call(y, z))
  }
  
  # parameter z is now a list! so we dont need to define a list above
  list_tabItems <- mapply(build_body_tabItem,
                          x = config$tabname,
                          y = config$mod_ui,
                          z = config$ui_param,
                          SIMPLIFY = F,
                          USE.NAMES = F)
  
  return(list_tabItems)
  
}


# funcs_bbos_server

build_mod_server <- function(config, session){
  
  session_list <- list(session)
  
  mapply(function(x,y){ 
    
    y <- c(y, session_list)
    do.call(x, y)
    
    }, 
    config$mod_server, 
    config$server_param)
  
}



# mod bbos ui -------------------------------------------
mod_bbos_ui <- function(id, config){
  
  ns <- NS(id)
  
  # Sidebar -------------------------------------
  sidebar <- dashboardSidebar(
    
    do.call(sidebarMenu, build_sidebar_menu(ns, config))
    
    )
  
  # Body -------------------------------------------
  body <- dashboardBody(
    
    # css
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
    ),
    
    # body
    do.call(tabItems, build_body_tabItems(config))
    
  )
  
  # return dashboard ------------------------------------------
  
  tagList(dashboardPage(dashboardHeader(title = "BBTools"),
                        sidebar = sidebar,
                        body = body))
  
}


# module bbos server ----------------------
mod_bbos_server <- function(id, config, session){
  
  build_mod_server(config, session)
  
  moduleServer(id, function(input, output, session){
    
    
  })
  
  
}

# call app ----------------------------------------------

config <- tibble(tabname = c("home", "data"),
                 mod_ui = c("home_ui","home_ui"),
                 mod_server = c("home_server", "home_server"),
                 ui_param = list(list("home1"), list("data1")),
                 server_param = list(list("home1"), list("data1")),
                 sidebar_type = c("menuItem", "menuItem"),
                 sidebar_text = c("Home", "Data"),
                 sidebar_parent = c("N", "N"),
                 sidebar_parent_tabname = c("home", "data"))

ui <- function(){ mod_bbos_ui("bbos", config) }
server <- function(input, output, session){ mod_bbos_server("bbos", config, session) }

shinyApp(ui = ui, server = server)

# run in display mode
# myApp <- shinyApp(ui = ui, server = server)
# runApp(myApp, display.mode = "showcase")


