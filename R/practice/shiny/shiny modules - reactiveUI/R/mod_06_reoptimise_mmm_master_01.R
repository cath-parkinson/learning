# master module

# ui --------------------------------------

mod_06_reoptimise_mmm_master_01_ui <- function(id){
  
  ns <- NS(id)
  
  fluidPage(
    
    fluidRow(
      column(
        width = 4,
        actionBttn_os(inputId = ns("impact_bttn"), 
                      label = "OVERALL IMPACT", 
                      icon = icon("bullseye"),
                      my_additional_style = "width:100%; margin-bottom:15px")),
      column(
        width = 4,
        actionBttn_os(inputId = ns("media_bttn"), 
                      label = "MEDIA", 
                      icon = icon("bullhorn"),
                      my_additional_style = "width:100%; margin-bottom:15px")),
      column(
        width = 4,
        actionBttn_os(inputId = ns("compare_bttn"), 
                      label = "COMPARISON", 
                      icon = icon("balance-scale"),
                      my_additional_style = "width:100%; margin-bottom:15px"))),
    
    
    tabsetPanel(
      id = ns("mmm_master_panels"), # this must be name spaced
      type = "hidden",
      tabPanelBody("panel1", "some content1"),
      tabPanelBody("panel2", mod_06_reoptimise_mmm_master_01_media_ui("mmm_reop")),
      tabPanelBody("panel3", "some content3")
    )


  )
  
  }

# server ------------------------------------------

mod_06_reoptimise_mmm_master_01_server <- function(id){
    
  mod_06_reoptimise_mmm_master_01_media_server("mmm_reop") # this needs to sit outside the moduleServer
  
      moduleServer(id, function(input, output, session){
    
      observeEvent(input$media_bttn,{
        
        updateTabsetPanel(session = session,
                          inputId = "mmm_master_panels",
                          selected = "panel2")
    
          })
      
      observeEvent(input$compare_bttn,{
        
        updateTabsetPanel(session = session,
                          inputId = "mmm_master_panels",
                          selected = "panel3")
        
      })
      
      observeEvent(input$impact_bttn,{
        
        updateTabsetPanel(session = session,
                          inputId = "mmm_master_panels",
                          selected = "panel1")
        
      })
      


      
      
    
    # core content ------------------------------
    # mod_06_reoptimise_mmm_master_01_overview_server("mmm_reop")
    # 
    
                                                   # ,
                                                   # reactive(input$impact_bttn),
                                                   # reactive(input$media_bttn),
                                                   # reactive(input$compare_bttn)
                                                   # )
    
  })
  
  
}