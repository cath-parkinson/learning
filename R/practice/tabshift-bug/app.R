library(shiny)
library(shinydashboard)
library(tidyverse)

# input data -----------------------------------------------------
config <- tibble(tabname = c("home", "database", "database2"),
                 mod_ui = c("mod_02_home_01_ui","mod_02_home_01_ui", "mod_02_home_01_ui"),
                 mod_server = c("mod_02_home_01_server", "mod_02_home_01_server", "mod_02_home_01_server"),
                 ui_param = list(list("home1"), list("database1"), list("database2")),
                 server_param = list(list("home1"), list("database1"), list("database2")),
                 sidebar_type = c("menuItem", "menuItem", "menuSubItem"),
                 sidebar_text = c("Home", "Data1", "Data2"),
                 sidebar_parent = c("N", "Y", "N"),
                 sidebar_parent_tabname = c("home", "database", "database"))

# functions ---------------------------------------------------------
build_sidebar_menu <- function(config){
  
  menuitems_needed <- config %>% filter(sidebar_type == "menuItem") %>% select(tabname) %>% pull()
  
  # 1) menuitems without submenuItems ---------------------------
  config_without <- config %>% filter(sidebar_type == "menuItem" & sidebar_parent == "N")
  build_sidebar_menu_item <- function(x,y,z) { menuItem(text = x, tabName = y) }
  
  list_menuItems_without <- mapply(build_sidebar_menu_item, 
                                   config_without$sidebar_text, 
                                   config_without$tabname,
                                   SIMPLIFY = F,
                                   USE.NAMES = F) 
  
  # 2) menuitems with submenuItems ----------------------------------
  config_with <- config %>% filter(sidebar_type == "menuItem" & sidebar_parent == "Y")
  config_subitems <- config %>% filter(sidebar_type == "menuSubItem")
  
  list_menuItems_with <- build_sidebar_menu_subitems(config_with, config_subitems) 
    
  # 3) bring together in final list
  list_menuItems <- c(id = "tabs", list_menuItems_without, list_menuItems_with)
  
  return(list_menuItems)
}

#' Build the shiny dashboard sidebar menuSubitems
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
    list_menuSubItems <- mapply(function(x,y,z){ menuSubItem(text = x, tabName = y)},
                                x = config_subitems_i$sidebar_text, 
                                y = config_subitems_i$tabname,
                                SIMPLIFY = F,
                                USE.NAMES = F)
    
    # pass the list of sub menus into the 
    menuItem_args <- c(text = text_i,
                       tabName = tabname_i,
                       startExpanded = T,
                       list_menuSubItems)
    
    # make the menuItem!
    list_menuItems_with[[i]] <- do.call(menuItem, menuItem_args)
    
    # temporary fix for known problem with shiny menuItem
    list_menuItems_with[[i]]$children[[1]]$attribs['data-toggle'] <- "tab"
    list_menuItems_with[[i]]$children[[1]]$attribs['data-value'] <- tabname_i
  }
  
  return(list_menuItems_with)
}

#' Build the shiny dashboard body tabItems
build_body_tabItems <- function(config) {
  
  build_body_tabItem <- function(x,y,z) { tabItem(tabName = x, do.call(y, z))}
  
  # parameter z is now a list! so we dont need to define a list above
  list_tabItems <- mapply(build_body_tabItem,
                          x = config$tabname,
                          y = config$mod_ui,
                          z = config$ui_param,
                          SIMPLIFY = F,
                          USE.NAMES = F)
  
  return(list_tabItems)
  
}

build_mod_server <- function(config, session){
  
  session_list <- list(session)
  
  mapply(function(x,y){ 
    
    y <- c(y, session_list)
    do.call(x, y)
    
  }, 
  config$mod_server, 
  config$server_param)
  
}

# modules -------------------------------------------------------------------------------

mod_02_home_01_ui <- function(id) {
  
  ns <- NS(id)
  
  tagList(actionButton(label = "Start",
                       inputId = ns("new_project")))
  
}

##### Server #####
mod_02_home_01_server <- function(id,parentsession) {
  
  moduleServer(id, function(input, output, session){
    
                 observeEvent(input$new_project,{
                   
                     updateTabItems(session = parentsession,
                                  inputId = "tabs",
                                  selected = "database1")
                   })
               })
  }

mod_os_ui <- function(id, config){
  
  sidebar <- dashboardSidebar(do.call(sidebarMenu, build_sidebar_menu(config)))
  body <- dashboardBody(do.call(tabItems, build_body_tabItems(config)))
  
  tagList(dashboardPage(dashboardHeader(),
                        sidebar = sidebar,
                        body = body))
  
}

mod_os_server <- function(id, config, session){
  
  build_mod_server(config, session)
  moduleServer(id, function(input, output, session){})
  
}


# call app ----------------------------------------------------------------------

ui <- function(){ mod_os_ui("os", config) }
server <- function(input, output, session){ mod_os_server("os", config, session) }

shinyApp(ui = ui, server = server)


