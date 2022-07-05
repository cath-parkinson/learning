#https://github.com/rstudio/shinydashboard/issues/347

library(shiny)
library(shinydashboard)
library(shinyjs)

# Functinos

# Ensure we can put content in menuItem
convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  if(length(mi$attribs$class)>0 && mi$attribs$class=="treeview"){
    mi$attribs$class=NULL
  }
  mi
}

# Shiny JS functions

jsCode <- 'shinyjs.hidemenuItem = function(targetid) {var x = document.getElementById(targetid); x.style.display = "none"; x.classList.remove("menu-open");};
shinyjs.showmenuItem = function(targetid) {var x = document.getElementById(targetid); x.style.display = "block"; x.classList.add("menu-open");};'

# Sidebar -------------------------------------
sidebar <- dashboardSidebar(
  
  sidebarMenu(id = "tabs",
              t <- convertMenuItem(menuItem("Dashboard",
                       tabName = "dashboard",
                       icon = icon("dashboard"),
                       "Some content in my sidebar",
                       # startExpanded = T
                       ),
                       tabName = "dashboard"),
              menuItem("Widgets",
                       tabName = "widgets",
                       icon = icon("widget")))
  
)
# Body -------------------------------------------
body <- dashboardBody(
  
  useShinyjs(),
  extendShinyjs(text = jsCode),
  tabItems(
    tabItem(tabName ="dashboard",
            "Dashboard content"),
    tabItem(tabName = "widgets",
            "Widgets content",
            actionButton(inputId = "nav_bttn",
                         label = "press me")))
)

ui <- function()(
  
  dashboardPage(dashboardHeader(title = "BBTools"),
                sidebar = sidebar,
                body = body)
)

server <- function(input, output, session) {
  
  observeEvent(input$nav_bttn,{
   
    updateTabItems(session = session, inputId = "tabs", "dashboard") 
    
  })
  
  observeEvent(input$nav_bttn,{
    
    targetID <- "dashboard"
    js$hidemenuItem(setdiff(c("mainItem1ID", "mainItem2ID"), targetID))
    js$showmenuItem(targetID)
    updateTabItems(session, inputId="sidebarID", selected = paste0("subItem", input$toggleTab%%2+1))
    
    
  })
  
}


shinyApp(ui = ui, server = server)