# Operating system functions 


# configuration function
# to do - in future we'll need functions that check the input for this is correct, and don't let you start the app if not
# to do - git developer needs to be tracked, git user should be ignored

# helper functions ----------------------------------------

#' Read in configuration files and return one summary tibble of all information
#'
#' @param path path to where configuration excels are saved
#' @return a summary tibble (tibble)
#' @examples
#' read_config()

read_config <- function(path = ""){
  
  df_user <- readxl::read_xlsx(paste0(path,"bbos_user_config.xlsx"))
  df_developer <- readxl::read_xlsx(paste0(path,"bbos_developer_config.xlsx"))
  
  # final table
  df <- df_user %>% 
    left_join(df_developer, by = c("module", "version")) %>% 
    filter(required == "Y") %>% 
    select(-version, -required) %>%
    mutate(ui_param = convert_to_list_column(ui_param)) %>% 
    mutate(server_param = convert_to_list_column(server_param))
  
  return(df)
}

#' Convert column into a list column
#'
#' @param column pass the column you want to convert
#' @return a column
#' @examples
#' read_config(path) %>% mutate(new_col = convert_to_list_column(ui_param))

convert_to_list_column <- function(column){
  
  column <- lapply(column, as.list, T)
  return(column)
  
}

# os ui funcs  -----------------------------------------------

#' Build the shiny dashboard sidebar menu item
#'
#' @param ns name space function (created using usual shiny module procedure)
#' @param config the configuration tibble containing information to build the dashboard
#' @return list of arguments ready to be passed to the sidebarMenu function
#' @examples
#' do.call(sidebarMenu, build_sidebar_menu(ns,config))

build_sidebar_menu <- function(ns, config){
  
  menuitems_needed <- config %>% filter(sidebar_type == "menuItem") %>% select(tabname) %>% pull()
  
  # 1) menuitems without submenuItems ---------------------------
  config_without <- config %>% filter(sidebar_type == "menuItem" & sidebar_parent == "N")
  build_sidebar_menu_item <- function(x,y,z) { menuItem(text = x, tabName = y, icon = icon(z)) }
  
  if(nrow(config_without)>0){
    
    list_menuItems_without <- mapply(build_sidebar_menu_item, 
                                     config_without$sidebar_text, 
                                     config_without$tabname,
                                     config_without$icon,
                                     SIMPLIFY = F,
                                     USE.NAMES = F) 
    
    # used later to sort the order
    names(list_menuItems_without) <- config_without$module 
    
    } else { list_menuItems_without <- list() }
  
  # 2) menuitems with submenuItems ----------------------------------
  config_with <- config %>% filter(sidebar_type == "menuItem" & sidebar_parent == "Y")
  config_subitems <- config %>% filter(sidebar_type == "menuSubItem")
  
  if(nrow(config_with)>0){
    
    list_menuItems_with <- build_sidebar_menu_subitems(config_with, config_subitems) 
    
    # used later to sort the order
    names(list_menuItems_with) <- config_with$module 
    
    } else {
      
      list_menuItems_with <- list()
    }
  
  # bring together
  list_menuItems <- c(list_menuItems_without, list_menuItems_with)
  
  # order the list as per the original file - remember to unname list
  actual_order_menuItems <- config %>% pull(module) %>% unique()
  list_menuItems <- list_menuItems[actual_order_menuItems]
  list_menuItems <- unname(list_menuItems)
  
  # make final list
  list_menuItems <- c(id = "tabs", list_menuItems)
  
  return(list_menuItems)
}

#' Build the shiny dashboard sidebar menu SUB items
#'
#' @param config_with configuration tibble filtered to only contain menuItems that have submenuitem children
#' @param config_subitems configuration tibble filtered to only contain menusubItems
#' @return list of menuItems (each of which contain the relevant submenuItems)
#' @examples
#' list_menuItems_with <- build_sidebar_menu_subitems(config_with, config_subitems)

build_sidebar_menu_subitems <- function(config_with, config_subitems){
  
  list_menuItems_with <- list()
  
  # loop over each menuitem we need to make
  for (i in 1:nrow(config_with)){
    
    # get the tabname and text needed
    tabname_i <- config_with %>% slice(i) %>% select(tabname) %>% pull()
    text_i <- config_with %>% slice(i) %>% select(sidebar_text) %>% pull()
    
    # get the icon needed
    icon_i <- config_with %>% slice(i) %>% select(icon) %>% pull()
    
    # get the corresponding table of subitems that we need to addinto the menuitem
    config_subitems_i <- config_subitems %>% filter(sidebar_parent_tabname == tabname_i)
    
    # create list of subitems
    list_menuSubItems <- mapply(function(x,y,z){ menuSubItem(text = x, tabName = y, icon = icon(z))},
                                x = config_subitems_i$sidebar_text, 
                                y = config_subitems_i$tabname,
                                z = config_subitems_i$icon,
                                SIMPLIFY = F,
                                USE.NAMES = F)
    
    # pass the list of sub menus into the 
    menuItem_args <- c(text = text_i,
                       tabName = tabname_i,
                       icon = list(icon(icon_i)),
                       startExpanded = T,
                       list_menuSubItems)
    
    # make the menuItem!
    list_menuItems_with[[i]] <- do.call(menuItem, menuItem_args)
    
  }
  
  return(list_menuItems_with)
}

#' Build the shiny dashboard body tab items
#'
#' @param config the configuration tibble containing information to build the dashboard
#' @return list of arguments ready to be passed to the tabItems function
#' @examples
#' do.call(tabItems, build_body_tabItems(config))

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

# os server funcs  -----------------------------------------------

#' Build the shiny dashboard server calls
#'
#' @param config the configuration tibble containing information to build the dashboard
#' @return all the server functions with arguments ready to be executed in the app
#' @examples
#' build_mod_server(config)

build_mod_server <- function(config, session){
  
  # TO DO add the session as a default
  session_list <- list(session)
  
  mapply(function(x,y){ 
    
    y <- c(y, session_list)
    do.call(x, y)
    
  }, 
  config$mod_server, 
  config$server_param)
  
}

