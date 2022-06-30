# module

# ui --------------------------------------

mod_06_reoptimise_mmm_master_01_media_ui <- function(id){
  
  ns <- NS(id)
  
  fluidRow(
    div(
      id = "media",
    column(
      width = 6,
      tabBox(
        id = "media_1",
        width = NULL,
        height = 400,
        tabPanel(title = "Media Schematic"))),
    column(
      width = 6,
      tabBox(
        id = "media_2",
        width = NULL,
        height = 400,
        tabPanel(title = "Response Curves")
      )
    )
    ))
  
}

# server ------------------------------------------

mod_06_reoptimise_mmm_master_01_media_server <- function(id){
  
  moduleServer(id, function(input, output, session){

    
  })

}