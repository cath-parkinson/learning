# two ways of making a list of menu items
# is this resulting in different information being passed?

library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinyalert)



source("R/funcs_01_os.R")

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

# first way - make a menuitem without children ----------------------------------

# 1) menuitems without submenuItems ---------------------------
config_without <- config %>% filter(sidebar_type == "menuItem" & sidebar_parent == "N") %>% slice(1)

menuItem_without <- menuItem(text = config_without$sidebar_text,
                     tabName = config_without$tabname,
                     icon = icon(config_without$icon))

# these are the missing pieces
# data-toggle
menuItem_without$children[[1]]$attribs['data-toggle']
menuItem_without$children[[1]]$attribs['data-toggle'] %>% typeof()
menuItem_without$children[[1]]$attribs['data-toggle'] %>% class()
# data-value
menuItem_without$children[[1]]$attribs['data-value']
menuItem_without$children[[1]]$attribs['data-value'] %>% typeof()


# 2) menuitems with submenuItems

config_with <- config %>% filter(sidebar_type == "menuItem" & sidebar_parent == "Y") %>% slice(1)
config_subitems <- config %>% filter(sidebar_type == "menuSubItem")

menusubItem_with <- menuSubItem(text = config_subitems$sidebar_text, 
                                tabName = config_subitems$tabname, 
                                icon = icon(config_subitems$icon)) 

menuItem_args <- c(text = config_with$sidebar_text,
                   tabName = config_with$tabname,
                   icon = list(icon(config_with$icon)),
                   startExpanded = T,
                   menusubItem_with)

# this is the only method where I use do.call to make menuItem!
menuItem_with <- do.call(menuItem, menuItem_args)

menuItem_with$children[[1]]
#These are the missing pieces - we will need to set these (
# this will always be set to "tab"
menuItem_with$children[[1]]$attribs['data-toggle'] <- "tab"
menuItem_with$children[[1]]$attribs['data-toggle'] %>% class()
# this wants to contain the tabname
menuItem_with$children[[1]]$attribs['data-value'] <- config_with$tabname
menuItem_with$children[[1]]$attribs['data-value'] %>% class()
