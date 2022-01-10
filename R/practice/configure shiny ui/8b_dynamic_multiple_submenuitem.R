# 7) final
library(shiny)
library(shinydashboard)
library(tidyverse)

source("R/funcs_config.R")
build_sidebar_menu <- function(ns, config){
  
  menuitems_needed <- config %>% filter(sidebar_type == "menuItem") %>% select(tabname) %>% pull()

  # 1) menuitems without submenuItems ---------------------------
  config_without <- config %>% filter(sidebar_type == "menuItem" & sidebar_parent == "N")
  build_sidebar_menu_item <- function(x,y) { menuItem(text = x, tabName = y) }
    
  list_menuItems_without <- mapply(build_sidebar_menu_item, 
                           config_without$sidebar_text, 
                           config_without$tabname,
                           SIMPLIFY = F,
                           USE.NAMES = F)
  
  # 2) menuitems with submenuItems ----------------------------------
  config_with <- config %>% filter(sidebar_type == "menuItem" & sidebar_parent == "Y")
  config_subitems <- config %>% filter(sidebar_type == "menuSubItem")
  
  list_menuItems_with <- build_sidebar_menu_subitems(config_with, config_subitems)
  
  # bring together
  list_menuItems <- c(list_menuItems_without, list_menuItems_with)
  
  # make final list
  list_menuItems <- c(id = ns("tabs"), list_menuItems)
  
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

# check this works -----------------------

mod_bbos_ui <- function(id, config){
  
  ns <- NS(id)
  
  # Sidebar -------------------------------------
  sidebar <- dashboardSidebar(
    
    do.call(sidebarMenu, build_sidebar_menu(ns, config))
  )
  
  body <- dashboardBody()

  tagList(dashboardPage(dashboardHeader(title = "BBTools"),
                        sidebar = sidebar,
                        body = body))
  
}

mod_bbos_server <- function(id, config){}

config <- read_config() 
ui <- function(){ mod_bbos_ui("bbos", config) }
server <- function(input, output, session){ mod_bbos_server("bbos", config) }
shinyApp(ui = ui, server = server)

