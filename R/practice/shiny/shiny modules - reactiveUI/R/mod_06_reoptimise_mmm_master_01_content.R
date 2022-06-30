# module

# module

# ui --------------------------------------

mod_06_reoptimise_mmm_master_01_content_ui <- function(id){
  
  ns <- NS(id)
  
  fluidPage(
    
    tagList(
      "some content", 
      textOutput(outputId = ns("media_bttn")),
      actionButton(inputId = ns("test_button"),
                   label = "test"),
      textOutput(outputId = ns("test_bttn"))
    )
    
  # fluidRow(
  #   div(
  #     id = ns("overview_panel"),
  #     column(
  #       width = 12,
  #       tabBox(
  #         id = "overview_all",
  #         width = NULL,
  #         height = 400,
  #         tabPanel(title = "Topline Results")))
  #   )),
  # 
  # fluidRow(
  #   div(
  #     id = ns("media_panel"),
  #     column(
  #       width = 12,
  #       tabBox(
  #         id = "media",
  #         width = NULL,
  #         height = 400,
  #         tabPanel(title = "Media",
  #                  "some content",
  #                  textOutput(outputId = ns("media_bttn"))))
  #   ))
  
  # )
  )
}

# server ------------------------------------------

mod_06_reoptimise_mmm_master_01_content_server <- function(id
                                                           ,
                                                            input_bttn_1,
                                                            input_bttn_2,
                                                            input_bttn_3
                                                           ){
  
  moduleServer(id, function(input, output, session){
    
    # observeEvent(input$media_bttn, {
    #   showElement("media_panel")
    #   hideElement("overview_panel")
    # })
    # 
    output$media_bttn <- renderText({

      # input$media_bttn
      # paste0("media button output ", input$media_bttn)
      paste0("media button output ", input_bttn_2)
      # paste0("media button output")

    })


    output$test_bttn <- renderText({
      
      paste0("test button output ", input$test_button)
      # input$test_button
      
    })
    
    
  })
  
}