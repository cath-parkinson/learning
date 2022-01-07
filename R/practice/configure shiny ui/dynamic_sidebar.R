library(shiny)
library(shinydashboard)

# https://stackoverflow.com/questions/51104554/is-there-a-way-in-which-we-can-make-the-sidebarmenu-menuitems-dynamic
# https://stackoverflow.com/questions/32741169/r-shinydashboard-dynamic-menuitem



list <- c("home", "data", "nesting", "wewin")

build_sidebar_menu <- function(list){
  
  mylist <- lapply(list, function(x){
    
    menuItem(text = x, tabName = x) 
    
  })
  
  mylist <- c(id = "tabs", mylist)
  
  return(mylist)
}

# Sidebar -------------------------------------
menuitems_created <- build_sidebar_menu(list)

sidebar <- dashboardSidebar(
  
  do.call(sidebarMenu, menuitems_created)
  
  
  # sidebarMenu(id = "tabs",
  #             menuItem(text = "home", tabName = "home"),
  #             menuItem(text = "data", tabName = "data"))
  )

# Body -------------------------------------------
body <- dashboardBody(
  
  # css
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
  ),
  
  
  tabItems(
    tabItem(tabName ="home"))
)


ui <- function()(
  
  dashboardPage(dashboardHeader(title = "BBTools"),
                      sidebar = sidebar,
                      body = body)
  )

server <- function(input, output, session) {
  
  
}


shinyApp(ui = ui, server = server)