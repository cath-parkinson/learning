library(shiny)
library(ggplot2)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        font-family: Calibri;
        background-color: #001D38;
        color: #CBF6FF;
      }
    ")),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  titlePanel("FORECASTER"),
  
  fluidRow(
    column(width = 12,
           "Dial up or down the key drivers on the LHS to see the resulting forecast on the RHS. Click into each driver to explore in more detail"
    )
  ),
  br(),
  
  fluidRow(
    column(width = 6,
           uiOutput("driver_ui")
    ),
    
    column(width = 6,
           fluidRow(
             column(width = 6,
                    actionButton("runButton", "RUN")
             ),
             column(width = 6,
                    actionButton("resetButton", "RESET")
             )
           ),
           br(),
           plotOutput("chart", height = "300px")
    )
  )
)

server <- function(input, output) {
  
  output$chart <- renderPlot({
    # Dummy data for the line chart
    df <- data.frame(
      Month = seq(as.Date("2022-01-01"), by = "month", length.out = 12),
      Value = sample(1:100, 12)
    )
    
    ggplot(df, aes(x = Month, y = Value)) +
      geom_line() +
      labs(title = "EXPECTED FORECAST")
  })
  
  output$driver_ui <- renderUI({
    sliders <- lapply(1:7, function(i) {
      fluidRow(
        column(width = 3,
               actionButton(paste0("button", i), "DRIVER")
        ),
        column(width = 9,
               sliderInput(paste0("slider", i), "", 
                           min = 0, 
                           max = 2, 
                           value = 1,
                           step = 0.1)
        )
      )
    })
    
    tagList(sliders)
  })
  
}

shinyApp(ui, server)