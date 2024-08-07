library(shiny)
library(ggplot2)
library(shinyWidgets)
library(readxl)
library(dplyr)
library(highcharter)
library(tidyr)

# CSS options for the noUI slider ---------------------

# https://refreshless.com/nouislider/examples/#section-hiding-tooltips


# Basic color theme for app -----------------------

background <- "#001D38" # grey
# highlight2 <- "#4F24EE" # vib blue
highlight2 <- "#000000" # black
# highlight4 <- "#7D26C9" # vib purble
highlight4 <- "#FF2CE4" # bright clarity pink
highlight3 <- "#00DC7C" # vib green
# highlight1 <- "#4DBAC1" # vib teal
highlight1 <- "#7F7F7F" # darker grey
# highlight1 <- "#001D38" # master blue
# neutral1 <- "#CBF6FF" # pas blue
neutral1 <- "#000000" # black


# Highcharter theme -----------------------------

mm_highcharter_theme <- hc_theme(
  title = list(style = list(
    color = neutral1
  )),
  chart = list(
    backgroundColor = NULL, 
    style = list(
      fontFamily = "Calibri" # Make all fonts Calibri
    )),
    legend = list(
      itemStyle = list(
        color = neutral1,# Make the legend text the right color
        fontWeight = "normal" 
      )),
    dataLabels = list(style = list(color = neutral1)
  ),
  yAxis = list(
    gridLineWidth = 0,
    lineWidth = 1,
    lineColor = neutral1,
    labels = list(style = list(color = neutral1)),
    ticks = list(display = TRUE)
  ),
  xAxis = list(
    labels = list(style = list(color = neutral1)),
    lineColor = neutral1,
    minorTickLength = 0,
    tickLength = 0
  )
)

# Read data --------------------------------

data <- readxl::read_xlsx("data.xlsx")
categories <- c("AD-SPEND", "CREATIVE-SCORE", "MEDIA-MIX", "PROMOS", "PRICE", "COMPETITOR","ECONOMY", "SEASONALITY")

sales <- data %>% 
  dplyr::filter(date > "2022-07-01") %>% 
  dplyr::mutate(weight = NA) %>% 
  dplyr::mutate(weighted_value = NA)%>%
  # Ensure when we chart the data it does in the order specified here
  dplyr::mutate(series_name = factor(series_name,
                                     levels = c(categories, "PRODUCT-LAUNCH", "BASE")))

# UI ------------------------

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        font-family: Calibri;
        background-color: #EAE8E4;
        color: #000000;
      }
    ")),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  titlePanel("FORECASTER"),
  
  # shinyWidgets::actionBttn(inputId = "debug",
                           # label = "DEBUG"),
  
  fluidRow(
    column(width = 12,
           h4("Dial up or down the key drivers on the LHS to see the resulting forecast on the RHS. Click into each driver to explore in more detail")
    )
  ),
  br(),
  
  fluidRow(
    column(width = 4,
           uiOutput("driver_ui"),
           br(),
           uiOutput("run_ui")
    ),
    
    column(width = 8,
           fluidRow(column(width = 4,
                           highchartOutput("chart2",
                                           height = "480px"
                                           )),
                    column(width = 8,
                           highchartOutput("chart"
                                           , height = "240px"
                                           ),
                           highchartOutput("chart3"
                                           , height = "240px"
                                           ))
                    # ,
                    # column(width = 8,
                           # ))
           
    )))
)

server <- function(input, output) {
  
  observeEvent(input$debug,{ browser() })
  
  
  # Store data ---------------------
  
  sales_data <- reactiveValues()
  sales_data$df <- sales
  
  # Store slider values ---------------------------
  
  # Initalise value - reactive values seems to be the most natural way to do this
  slider_vals <- reactiveValues()
  
  slider_vals$label <- categories
  slider_vals$color <- c("primary", "primary", "primary", "warning", "warning", "warning", "danger", "danger")
  
  observe({
    
    slider_vals$df <- tibble::tibble(slider = slider_vals$label,
                                     slider_value = rep(1,8))
    
  })
  
  # Update the table when the user moves the slider
  lapply(1:8, function(i){
    
    observeEvent(input[[paste0("slider_", slider_vals$label[i])]], {
      
      slider_vals$df[["slider_value"]][i] <- input[[paste0("slider_", slider_vals$label[i])]]
      
    })
    
  })
  
  
  # Slider UI -------------------------
    
  output$driver_ui <- renderUI({
    
    sliders <- lapply(1:8, function(i) {

      div(id = "bttn-slider-row",
          # h4("Media drivers:"),
          fixedRow(
        # align = "center",
        column(width = 4,
               div(id = "bttn-row",
                 shinyWidgets::actionBttn(paste0("button_", slider_vals$label[i]),
                                        label = gsub("-", " ", slider_vals$label[i]),
                                        style = "pill",
                                        color = slider_vals$color[i],
                                        size = "sm"))
        ),
        column(width = 8,
               div(id = "slider-row",
                   shinyWidgets::noUiSliderInput(paste0("slider_", slider_vals$label[i]), "",
                                                 min = 0,
                                                 max = 2,
                                                 value = 1,
                                                 # label = slider_vals$label[i],
                                                 tooltips = TRUE, 
                                                 update_on = c("end"),
                                                 step = 0.1,
                                                 color = "#7F7F7F",
                                                 width = "100%"
                                                 # ,
                                                 # height = "100%"
                                                 )
               )
        )
      )
      # ,
      # br()
      )
    })
    
    tagList(sliders)
  })
  
  
  # Reset values
  observeEvent(input$resetButton, {

    # Sliders
    lapply(1:8, function(i){
      
      updateNoUiSliderInput(inputId = paste0("slider_", slider_vals$label[i]),
                            value = 1)

    })
    
    # Data
    sales_data$df <- sales_data$df %>%
      # Set to NAs so the forecast line disappears from the chart
      dplyr::mutate(weight = NA) %>% 
      dplyr::mutate(weighted_value = NA) 
  })
  
  # Run data
  
  observeEvent(input$runButton, {
    
    sales_data$df <- sales_data$df %>%
      dplyr::mutate(weight = weight0,
                    weighted_value = weighted_value0) %>% 
      dplyr::left_join(slider_vals$df, by = c("series_name" = "slider")) %>%
      dplyr::mutate(weight = dplyr::if_else(is.na(slider_value), weight, slider_value)) %>% 
      # Force the first week of the forecast to be the same as the "actual"
      dplyr::mutate(weight = dplyr::if_else(date == as.Date("2023-07-01"), 1, weight)) %>% 
      dplyr::mutate(weighted_value = value*weight) %>% 
      dplyr::select(-slider_value) %>% 
      # We don't want to show the forecast in the "actual" period
      dplyr::mutate(weighted_value = replace(weighted_value, date < as.Date("2023-07-01"), NA))
    
  })
  
  # Run UI ----------------------------
  
  output$run_ui <- renderUI({
    
    fluidRow(column(width = 9,
                    shinyWidgets::actionBttn(inputId = "runButton", 
                                             label = "Calculate my scenario",
                                             style = "pill",
                                             color = "success",
                                             size = "sm")),
             column(width = 3,
                    shinyWidgets::actionBttn(inputId = "resetButton", 
                                             label = "Reset",
                                             style = "pill",
                                             color = "royal",
                                             size = "sm")))
    
  })
  
  
  # Charts -------------------------
  
  
  output$chart2 <- renderHighchart({
    
    total_data <- sales_data$df %>%
      dplyr::filter(date > "2023-07-01") %>% 
      dplyr::summarise("Benchmark" = sum(weighted_value0),
                       "My Scenario" = sum(weighted_value)) %>%
                       # "My Scenario" = 705000) %>% 
      tidyr::pivot_longer(cols = c("Benchmark", "My Scenario"),
                          names_to = "series",
                          values_to = "value")
    
    total_data %>%
      highcharter::hchart(type = "bar", 
                          # The group is essential for allowing us to use a different color for each bar
               hcaes(x = "series", y = "value", group = "series"), color = c(highlight1, highlight2)) %>%
      # Then this stacking = normal also formats the now colored series, groups correctly on the chart
      highcharter::hc_plotOptions(series = list(stacking = "normal"
                                                # dataLabels = list(enabled = TRUE)
                                                )) %>% 
      highcharter::hc_add_theme(mm_highcharter_theme) %>% 
      hc_yAxis(title = "") %>% 
      hc_xAxis(title = "") %>% 
      highcharter::hc_title(text = "Total Sales",
                            align = "left") %>% 
      hc_legend(enabled = T)
    
  })
  
  output$chart <- renderHighchart({


    highcharter::highchart() %>%
      highcharter::hc_title(text = "Weekly Sales",
                            align = "left") %>%
      highcharter::hc_add_series(data = sales_data$df %>%
                                   dplyr::group_by(model, date) %>%
                                   dplyr::summarise(weighted_value0 = sum(weighted_value0)) %>%
                                   dplyr::mutate(month = datetime_to_timestamp(date)
                                   ),
                                 name = "Benchmark",
                                 hcaes(x = month,
                                       y = weighted_value0),
                                 zoneAxis = "x",
                                 zones = list(list(value = datetime_to_timestamp(as.Date("2023-07-01")),
                                             dashStyle = "solid")),
                                 type = "line",
                                 dashStyle = "dash",
                                 color = highlight1) %>%
      highcharter::hc_add_series(data = sales_data$df %>%
                                   dplyr::group_by(model, date) %>%
                                   dplyr::summarise(weighted_value = sum(weighted_value)) %>%
                                   dplyr::mutate(month = datetime_to_timestamp(date)
                                   ),
                                 name = "My Scenario",
                                 hcaes(x = month,
                                       y = weighted_value),
                                 type = "line",
                                 dashStyle = "dash",
                                 color = highlight2) %>%
      highcharter::hc_xAxis(type = "datetime",
                            # style = list(color = "#4F24EE"),
                            plotLines = list(list(color = highlight1,
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
  
  # Tom additions
  
  output$chart3 <- renderHighchart({
    
    category_data <- sales_data$df %>%
      dplyr::filter(date > "2023-07-01") %>% 
      dplyr::rename("Benchmark" = weighted_value0, "My Scenario" = weighted_value) %>%
      dplyr::select(series_name, 'Benchmark', 'My Scenario') %>%
      pivot_longer(cols = -series_name, names_to = "type") %>%
      dplyr::group_by(series_name, type) %>%
      dplyr::summarise(value = sum(value)) %>%
      dplyr::filter(!series_name == "PRODUCT-LAUNCH") %>%
      dplyr::filter(!series_name == "BASE") %>%
      dplyr::mutate(series_name = gsub("-", " ", series_name))

       
    category_data %>%
      highcharter::hchart(type = "column", 
                          # The group is essential for allowing us to use a different color for each bar
                          hcaes(x = series_name, y = value, group = type), color = c(highlight1, highlight2)) %>%
      # Then this stacking = normal also formats the now colored series, groups correctly on the chart
      # highcharter::hc_plotOptions(series = list(stacking = "normal"
      #                                           # dataLabels = list(enabled = TRUE)
      # )) %>% 
      highcharter::hc_add_theme(mm_highcharter_theme) %>% 
      hc_yAxis(title = "") %>% 
      hc_xAxis(title = "") %>% 
      highcharter::hc_title(text = "Sales Breakdown",
                            align = "left") %>% 
      hc_legend(enabled = T)
    
  })
  
  
}

shinyApp(ui, server)