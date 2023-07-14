library(shiny)
library(ggplot2)
library(shinyWidgets)
library(readxl)
library(dplyr)
library(highcharter)
library(tidyr)

# Highcharter theme -----------------------------

mm_highcharter_theme <- hc_theme(
  chart = list(
    backgroundColor = NULL, 
    style = list(
      fontFamily = "Calibri" # Make all fonts Calibri
    )),
    legend = list(
      itemStyle = list(
        color = "#CBF6FF" # Make the legend text the right color
      )),
    dataLabels = list(style = list(color = "#CBF6FF")
  ),
  yAxis = list(
    gridLineWidth = 0,
    lineWidth = 1,
    lineColor = "#CBF6FF",
    labels = list(style = list(color = "#CBF6FF")),
    ticks = list(display = TRUE)
  ),
  xAxis = list(
    labels = list(style = list(color = "#CBF6FF")),
    lineColor = "#CBF6FF",
    minorTickLength = 0,
    tickLength = 0
  )
)

# Read data --------------------------------

data <- readxl::read_xlsx("data.xlsx")

sales <- data %>% 
  dplyr::filter(date > "2022-07-01") 

# UI ------------------------

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
  
  # shinyWidgets::actionBttn(inputId = "debug",
  #                          label = "DEBUG"),
  
  fluidRow(
    column(width = 12,
           h4("Dial up or down the key drivers on the LHS to see the resulting forecast on the RHS. Click into each driver to explore in more detail")
    )
  ),
  br(),
  
  fluidRow(
    column(width = 6,
           uiOutput("driver_ui"),
    ),
    
    column(width = 6,
           fluidRow(
             column(width = 6,
                    shinyWidgets::actionBttn(inputId = "runButton", 
                                             label = "RUN",
                                             style = "pill",
                                             color = "success",
                                             size = "lg")
             ),
             column(width = 6,
                    shinyWidgets::actionBttn(inputId = "resetButton", 
                                             label = "RESET",
                                             style = "pill",
                                             color = "success",
                                             size = "lg")
             )
           ),
           br(),
           highchartOutput("chart", height = "300px")
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$debug,{ browser() })
  
  
  # Store data ---------------------
  
  sales_data <- reactiveValues()
  sales_data$df <- sales
  
  # Store slider values ---------------------------
  
  # Initalise value - reactive values seems to be the most natural way to do this
  slider_vals <- reactiveValues()
  slider_vals$label <- c("MEDIA", "SEASONALITY", "ECONOMY", "PROMOS", "PRICE", "COMPETITOR", "BASE")
  
  observe({
    
    slider_vals$df <- tibble::tibble(slider = slider_vals$label,
                                     slider_value = rep(1,7))
    
  })
  
  # Update the table when the user moves the slider
  lapply(1:7, function(i){
    
    observeEvent(input[[paste0("slider_", slider_vals$label[i])]], {
      
      slider_vals$df[["slider_value"]][i] <- input[[paste0("slider_", slider_vals$label[i])]]
      
    })
    
  })
  
  
  # Slider UI -------------------------
    
  output$driver_ui <- renderUI({
    
    sliders <- lapply(1:7, function(i) {
      div(fluidRow(
        align = "center",
        column(width = 4,
               shinyWidgets::actionBttn(paste0("button_", slider_vals$label[i]),
                                        label = slider_vals$label[i],
                                        style = "pill",
                                        color = "danger",
                                        size = "lg")
        ),
        column(width = 8,
               shinyWidgets::noUiSliderInput(paste0("slider_", slider_vals$label[i]), "",
                               min = 0,
                               max = 2,
                               value = 1,
                               tooltips = FALSE, # it's harder to get to the value you need if this is set to FALSE
                               update_on = c("end"),
                               step = 0.1,
                               color = "#A6A6A6",
                               width = "100%")
        )
      ),
      br())
    })
    
    tagList(sliders)
  })
  
  
  # Reset values
  observeEvent(input$resetButton, {

    # Sliders
    lapply(1:7, function(i){
      
      updateNoUiSliderInput(inputId = paste0("slider_", slider_vals$label[i]),
                            value = 1)

    })
    
    # Data
    sales_data$df <- sales_data$df %>%
      dplyr::mutate(weight = 1) %>% 
      dplyr::mutate(weighted_value = value*weight) 
  })
  
  # Run data
  
  observeEvent(input$runButton, {
    
    sales_data$df <- sales_data$df %>%
      dplyr::left_join(slider_vals$df, by = c("series_name" = "slider")) %>%
      dplyr::mutate(weight = dplyr::if_else(is.na(slider_value), weight, slider_value)) %>% 
      dplyr::mutate(weighted_value = value*weight) %>% 
      dplyr::select(-slider_value)
    
  })
  
  
  # Charts -------------------------
  
  output$chart <- renderHighchart({
    
    highcharter::highchart() %>%
      highcharter::hc_add_series(data = sales_data$df %>% 
                                   dplyr::group_by(model, date) %>% 
                                   dplyr::summarise(weighted_value0 = sum(weighted_value0)) %>%
                                   dplyr::mutate(month = datetime_to_timestamp(date)
                                   ),
                                 name = "Benchmark",
                                 hcaes(x = month, 
                                       y = weighted_value0),
                                 type = "line", 
                                 dashStyle = "dash",
                                 color = "#4F24EE") %>% 
      highcharter::hc_add_series(data = sales_data$df %>% 
                                   dplyr::group_by(model, date) %>% 
                                   dplyr::summarise(weighted_value = sum(weighted_value)) %>%
                                   dplyr::mutate(month = datetime_to_timestamp(date)
                                   ),
                                 name = "Forecast",
                                 hcaes(x = month, 
                                       y = weighted_value),
                                 type = "line", 
                                 color = "#4F24EE") %>% 
      highcharter::hc_xAxis(type = "datetime",
                            style = list(color = "#4F24EE"),
                            plotLines = list(list(color = "#CBF6FF",
                                                  value = datetime_to_timestamp(as.Date("2023-07-01")),
                                                  dashStyle = "shortdash",
                                                  width = 3
                                                  # ,
                                                  # label = list(text = "Forecast starts",
                                                               # rotation = 0,
                                                               # style = list(color = "#CBF6FF"))
                                                  ))) %>%
      highcharter::hc_yAxis(min = 0) %>% 
      highcharter::hc_add_theme(mm_highcharter_theme)
    
  })
  
  
  
  
  
}

shinyApp(ui, server)