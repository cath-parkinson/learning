# code to install our package
# remotes::install_bitbucket(repo = "brightblueconsulting/mm.reoptimise",
#                            password = "2DTrYyCjqQBd8BpCRWTR",
#                            auth_user = "workstation_read_only")

library(shiny)
library(shinyjs)
library(shinyWidgets)
library(shinydashboard)

# FUNCTION

convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  if(length(mi$attribs$class)>0 && mi$attribs$class=="treeview"){
    mi$attribs$class=NULL
  }
  mi
}


actionBttn_os <- function(inputId, 
                          label = NULL, 
                          icon = NULL, 
                          style = "material-flat",
                          color = "success",
                          size = "sm", 
                          block = FALSE,
                          no_outline = TRUE, 
                          my_additional_style = "height:55px") {
  value <- shiny::restoreInput(id = inputId, 
                               default = NULL)
  style <- match.arg(
    arg = style,
    choices = c("simple", "bordered", "minimal", "stretch", "jelly",
                "gradient", "fill", "material-circle", "material-flat",
                "pill", "float", "unite")
  )
  color <- match.arg(
    arg = color,
    choices = c("default", "primary", "warning", "danger", "success", "royal")
  )
  size <- match.arg(arg = size, choices = c("xs", "sm", "md", "lg"))
  
  tagBttn <- htmltools::tags$button(
    id = inputId,
    type = "button", 
    class = "action-button bttn", 
    `data-val` = value,
    class = paste0("bttn-", style), 
    class = paste0("bttn-", size),
    class = paste0("bttn-", color), 
    list(icon, label),
    class = if (block) "bttn-block",
    class = if (no_outline) "bttn-no-outline",
    style = my_additional_style
  )
  shinyWidgets:::attachShinyWidgetsDep(tagBttn, "bttn")
}



## UI: sidebar --------------------

sidebar <- dashboardSidebar(
  
  # move this back
  sidebarMenu(
    id = "mastertabs",
    # 
    # Side panel -----------------------------
    convertMenuItem(menuItem(text = "CONFIGURE SCENARIO", 
                             tabName = "mmm_master", 
                             icon = icon("wrench"),
                             
                             style = "white-space: normal; style = 'color:black;",
                             
                             menuItem(text = "Manage scenarios",
                                      tabName = "mmm_master_scenarios",
                                      
                                      tagList(
                                        
                                        # fluidRow(
                                          # column(width = 6,
                                                 uiOutput(outputId = ("selected_scenario")),
                                                 # )),
                                        
                                        # br(),
                                        
                                        # uiOutput(outputId = ("bttn_save")),
                                        # uiOutput(outputId = ("bttn_save_as")),
                                        # uiOutput(outputId = ("bttn_new")),
                                        
                                        
                                        
                                        # Use fluidRow to ensure buttons are side by side
                                        fluidRow(
                                          column(width = 3
                                                 ,
                                                 uiOutput(outputId = ("bttn_save_as"))
                                                 ),
                                          column(width = 3
                                                 ,
                                                 offset = 2,
                                                 uiOutput(outputId = ("bttn_save"))
                                                 ),
                                          column(width = 3
                                                 # ,
                                                 # offset = 3,
                                                 # uiOutput(outputId = ("bttn_new"))
                                                 )
                                          ),
                                        
                                        # fluidRow(
                                        #   column(width = 3,
                                        #          uiOutput(outputId = ns("bttn_new")))
                                        # ),
                                        # 
                                        uiOutput(outputId = ("load_scenario")))
                                      )), 
                    tabName ="mmm_master")
  )    
)

## UI: body 
body <- dashboardBody(
  
)

## Run app ------------------------------------------

ui <- dashboardPage(dashboardHeader(title = "TOOLS"),
                    sidebar,
                    body,
                    skin = "blue"
                    # skin = "black"
)


server <- function(input, output, session){
  
  output$selected_scenario <- renderUI({
    
    div(
      # br(),
      
      HTML(
        # HTML('&emsp;'), # html for tab - ensures text starts at some place as the buttons
        paste(strong("Selected: "),
              toupper("WHATEVER MY NAME IS WHAT IF IT'S VERY LONG"))
      ),
      
      # br(),
      
      # style = 'color:black'
      )
    
  })
  
  
  # Save buttons - conditional ------------------------------
  
  output$bttn_new <- renderUI({
    
    actionBttn_os(inputId = ("create_new_scenario"),
                  label = "NEW",
                  color = "default",
                  # size = "xs"
                  # ,
                  # my_additional_style = 'width: 50%;'
    )
    
    
  })
  
  output$bttn_save <- renderUI({
    
    actionBttn_os(inputId = ("save_scenario"),
                  label = "SAVE",
                  color = "default",
                  # size = "xs"
                  # ,
                  # my_additional_style = 'display: inline-block; vertical-align:top;'
    )

    
  })
  
  output$bttn_save_as <- renderUI({
    
    actionBttn_os(inputId = ("save_as_scenario"),
                  label = "SAVE AS",
                  color = "default",
                  # size = "xs"
                  # ,
                  # my_additional_style = 'display: inline-block; vertical-align:top;'
    )
    
    
  })
  
  
  
  # Load previous scenarios - conditional
  
  output$load_scenario <- renderUI({
    
      
      selectInput(inputId = ("load_scenario"),
                  label = "Load scenario:",
                  choices = "scenario_names" )
      
  })
  
}

## run app ----------------------------------

shinyApp(ui, server)



