# module

# ui --------------------------------------

mod_06_reoptimise_mmm_master_01_overview_ui <- function(id){
  
  ns <- NS(id)
  
  fluidRow(
    div(
      id = "overview",
    column(
      width = 12,
      tabBox(
        id = "overview_all",
        width = NULL,
        height = 400,
        tabPanel(title = "Topline Results")))
    ))
  
}

# server ------------------------------------------

mod_06_reoptimise_mmm_master_01_overview_server <- function(id){
  
  moduleServer(id, function(input, output, session){

    
  })

}