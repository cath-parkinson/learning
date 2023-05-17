library(shiny)
library(shinyWidgets)
library(plotly)
library(mm.reoptimise)
library(tidyverse)


# remotes::install_github("cath-parkinson/mm.reoptimise",
#                         ref = "v0.2.993",
#                         auth_token = "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",
#                         force = T,
#                         INSTALL_opts=c("--no-multiarch")) # stop it checking for 32 and 64 bit installation


# install.packages(file.path("../../Work/MeasureMonks/", "mm.reoptimise_0.2.9997.zip"))

# set this up to be a colour vector that you then pass through the script
os_colors <- c("#4F24EE", # "Vibrant Blue"
               "#FF245B", # "Vibrant Red"
               "#FFCB16", # "Vibrant Yellow"
               "#7D26C9", # "Vibrant Purple"
               "#00DC7C", # "Vibrant Green"
               "#FB961F", # "Vibrant Orange"
               "#4DBAC1", # "Vibrant Teal"
               "#A6A6A6", # "Gray"
               # "#000000", # "Black"
               # "#FFFFFF", # "White"
               # "#CBF6FF", # "Pastel Blue"
               "#FFA6BC", # "Pastel Red"
               # "#FFEAA2", # "Pastel Yellow"
               "#CAA2EE", # "Pastel Purple"
               "#8AFFCD",# "Pastel Green"
               # "#FED6A5", # "Pastel Orange"
               # "#B7E3E6", # "Pastel Teal"
               "#D9D9D9" # "Pastel Gray"
               # "#001D38"  # "Tinted Blue"
)






# Chart function
read_in_reop_master_list <- readRDS("reop_master_list-aviva-v2.RDS")


one_plot <- function(one_data,
                     yaxis_showticklabel = TRUE,
                     xaxis_range = NULL,
                     chart_title,
                     bar_color,
                     units){
  
  
  label_units <- switch(units,
                        # Used for response or spend - the % denotes that we're pulling a variable
                        "dollars" = paste0(mm.reoptimise::currency_string_to_symbol(units), "%{x:.2s}"),
                        "pounds" = paste0(mm.reoptimise::currency_string_to_symbol(units), "%{x:.2s}"),
                        "euros" = paste0(mm.reoptimise::currency_string_to_symbol(units), "%{x:.2s}"),
                        "volume_none" = "%{x:.2s}", 
                        "percentage" = "%{x:.2%}", # The 2 here means 2 decimal places
                        # Used for the performance indicator
                        "dollars_decimal" = paste0(mm.reoptimise::currency_string_to_symbol("dollars"), "%{x:.2f}"),
                        "pounds_decimal" = paste0(mm.reoptimise::currency_string_to_symbol("pounds"), "%{x:.2f}"),
                        "euros_decimal" = paste0(mm.reoptimise::currency_string_to_symbol("euros"), "%{x:.2f}"))
  
  # We need to reverse the order of the rows to ensure the chart shows in the correct order
  one_data <- one_data %>% dplyr::arrange(desc(row_number()))
  
  one_data %>% 
    # A bar chart is ordered by the y axis, and therefore will be alphabetical if y is a character or sorted how you like if y is a factor
    # We want to retain the order of the original data frame
    # Plotly automatically applies dplyr statements to the underlying data
    dplyr::mutate(label = factor(label,
                                 levels = unique(label))) %>% 
    plotly::plot_ly(
      y = ~label,
      x = ~value,
      # Turn it side ways
      orientation = "h") %>%
    
    # Make it a bar chart
    plotly::add_bars(
      # Add the data labels
      text = ~value,
      # % is used to specify a variable, 2s is a type of autoformatting e.g. it automatically does 2m or 100k 
      texttemplate = label_units,
      # Tries to put the text inside (with auto white font, or outside, if not possible). Helps with the label overlapping problem
      textposition = "auto",
      marker = list(color = bar_color),
      # Stop the labels cutting off when they hit the edge of the plot
      cliponaxis = FALSE,
      # This sets the name of the 'trace' so it appears nicely when it gets passed into subplot()
      name = chart_title,
      hoverinfo = "x"
    ) %>% 
    plotly::layout(
      xaxis = list(showgrid = FALSE, 
                   # Always hide the x axis as we have added the data labels instead
                   showticklabels = FALSE, 
                   zeroline = FALSE,
                   range = xaxis_range,
                   title = ""),
      yaxis = list(title = "", 
                   showgrid = FALSE, 
                   zeroline = FALSE, 
                   # Show or hide the y axis labels
                   showticklabels = yaxis_showticklabel,
                   showgrid = FALSE,
                   autorange = TRUE
      ),
      uniformtext = list(minsize=8, mode='hide'),
      # Set the margin around the chart so there is room for the title
      margin = list(
        # left, right, bottom, top in pixels
        # l = 50, r = 50, b = 50, t = 75),
        # l = 55, r = 55, b = 55, t = 75),
        pad = 15, # Puts padding around the axis labels so they are a neat distance from the chart
        l = 10, r = 10, b = 0, t = 75 # The top 75 pixels here is key! It leaves space for a rectangle of height 40px
        ),
      # Put a grey box around the chart title
      shapes = list(
        type = "rect",
        x0 = 0,
        x1 = 1,
        xref = "paper",
        y0 = 0, 
        y1 = 40,
        yanchor = 1,
        yref = "paper",
        # this means the y references should be interpretted as pixels i.e. the height of the grey box is 40px
        ysizemode = "pixel",
        # fillcolor = toRGB("gray80"),
        fillcolor = os_colors[12],
        line = list(color = "transparent")
      ),
      # Stop the legend showing when we combine plots with subplot()
      showlegend = FALSE,
      # Force the font of the plot
      font = list(family = "Calibri",
                  size = 14,
                  color = "#0D0D0D")
    ) %>%
    # plotly::add_annotations(
    #   text = chart_title,
    #   # Position of the chart title, x=0.5 means it's in the middle, y = 1.1 will place it just above the top
    #   x = 0.5, y = 1.04,
    #   # Paper means that the x/y number should be interpreted as the distance from the lhs or bottom of the chart
    #   xref = "paper",
    #   yref = "paper",
    #   showarrow = FALSE
    #   ,
    #   yanchor = "bottom",
    #   xanchor = "center",
  #   # color = "white"
  #   # font_color = "#FFFFFF"
  #   font = list(color = "white")
  # ) %>%
  plotly::add_annotations(
    text = chart_title,
    # Position of the chart title, x=0.5 means it's in the middle, y = 1.1 will place it just above the top
    x = 0.5, 
    y = 1, 
    yshift = 30,
    # Paper means that the x/y number should be interpreted as the distance from the lhs or bottom of the chart
    xref = "paper",
    yref = "paper",
    showarrow = FALSE
    ,
    yanchor = 1,
    xanchor = "center",
    # color = "white"
    # font_color = "#FFFFFF"
    font = list(color = "black")
  ) 
  # %>%
  #   plotly::add_annotations(
  #     text = chart_title,
  #     # Position of the chart title, x=0.5 means it's in the middle, y = 1.1 will place it just above the top
  #     x = 0.5, 
  #     y0 = 0,
  #     y1 = 40,
  #     # Paper means that the x/y number should be interpreted as the distance from the lhs or bottom of the chart
  #     xref = "paper",
  #     yref = "paper",
  #     ysizemode = "pixel",
  #     showarrow = FALSE
  #     ,
  #     yanchor = 1,
  #     xanchor = "center",
  #     # color = "white"
  #     # font_color = "#FFFFFF"
  #     font = list(color = "white")
  #   )
}

mod_06_reop_mmm_master_01_comparison_chart_ui <- function(id){
  
  ns <- NS(id)
  
  tagList(
    
    # plotlyOutput(ns("plotly_chart")),
    actionButton(inputId = ns("debug"),
                 label = "DEBUG"),
    uiOutput(ns("plotly_chart_output")),
    splitLayout(
      cellWidths = c("0em", "4em"),
      # Needed as the parent div of the dropdown menu has an overflow: auto style, which blocks the dropdown menu
      tags$head(
        tags$style(
          HTML(".shiny-split-layout > div {
                                overflow: visible;
                                }")
        )
      ),
      dropMenu(
        # inputId = ns("control_filter"),
        actionButton(ns("go0"), 
                     # "See what"
                     label = icon("filter", 
                                  class = "opt")
        ),
        tagList(
          selectInput(ns("scenario_name1"),
                      "Choose Scenario 1",
                      choices = NULL),
          selectInput(ns("scenario_name2"),
                      "Choose Scenario 2",
                      choices = NULL),
          selectInput(ns("kpi1"),
                      "Choose KPI 1",
                      choices = NULL),
          selectInput(
            ns("grouping"),
            "Choose Grouping",
            choices = c(
              "channel_name",
              "channel.group.level1_name",
              "channel.group.level2_name",
              "period_level1",
              "period_level2.name",
              "channel_name - period_level2.name"
            )
          )
        ),
        size = "xs",
        icon = icon("filter", class = "opt"),
        up = TRUE
      )
      # ,
      # dropdown(
      #   inputId = ns("button_download"),
      #   downloadButton(
      #     outputId = ns("download_results"),
      #     label = "Results Data"
      #   ),
      #   size = "xs",
      #   icon = icon("download", class = "opt"),
      #   up = TRUE
      # )
    ) # end of split layout
    
  )
  
}


mod_06_reop_mmm_master_01_comparison_chart_server <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    reop_master_list <- reactiveValues(
      reop_master_list = read_in_reop_master_list$reop_master_list,
      reop_master_list_all_results = read_in_reop_master_list$reop_master_list_all_results,
      reop_master_currency_string = read_in_reop_master_list$reop_master_currency_string
    )
    
    # Get and organise data based off user selection
    chart_comparison_list <- reactiveValues()
    
    observeEvent(list(input$scenario_name1, input$scenario_name2, input$kpi1, input$grouping),{
      
      chart_comparison_list$data <- mm.reoptimise::get_chart_comparison_data_for_both_scenarios(all_results_table = reop_master_list$reop_master_list_all_results,
                                                                                                chosen_scenario1 = input$scenario_name1,
                                                                                                chosen_scenario2 = input$scenario_name2,
                                                                                                chosen_kpi = input$kpi1,
                                                                                                chosen_grouping = input$grouping)
      
      
      # browser()
      
      number_of_rows <- chart_comparison_list$data[[1]] %>% nrow()
      # 75px to match the margin I'd added at the top!!
      px <- 75 + number_of_rows*44
      
      chart_comparison_list$plotly_height <- paste0(px, "px")
      
      
      # chart_comparison_list %>% lapply(one_plot) %>% subplot(nrows = 1)
      chart_comparison_list$no_of_scenarios <- switch(length(chart_comparison_list$data),
                                                      NA, #1
                                                      "one_bh", #2
                                                      "one", #3
                                                      NA, #4
                                                      NA, #5
                                                      "two_bh", #6
                                                      NA, #7
                                                      "two") #8
      
      chart_comparison_list$set_yaxis_tick_labels <- switch(chart_comparison_list$no_of_scenarios,
                                                            "one" = list(TRUE, FALSE, FALSE),
                                                            "two" = list(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
                                                            "one_bh" = list(TRUE, FALSE),
                                                            "two_bh" = list(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE))
      
      
      chart_comparison_list$color_of_bars <- switch(chart_comparison_list$no_of_scenarios,
                                                    "one" = list(os_colors[2],
                                                                 os_colors[5],
                                                                 os_colors[7]),
                                                    "two" = list(os_colors[2],
                                                                 os_colors[2],
                                                                 os_colors[12],
                                                                 os_colors[5],
                                                                 os_colors[5],
                                                                 os_colors[12],
                                                                 os_colors[7],
                                                                 os_colors[7]),
                                                    "one_bh" = list(os_colors[2],
                                                                    os_colors[5]),
                                                    "two_bh" = list(os_colors[2],
                                                                    os_colors[2],
                                                                    os_colors[5],
                                                                    os_colors[5]))
      
      chart_comparison_list$units <- switch(chart_comparison_list$no_of_scenarios,
                                            "one" = list(reop_master_list$reop_master_currency_string,
                                                         # Call this from scenario zero - will be the same through out
                                                         get_units(input$kpi1,
                                                                   reop_master_list$reop_master_list[[1]]$all_units),
                                                         # Always currency matching whatever the spend variable is in
                                                         paste0(reop_master_list$reop_master_currency_string, "_decimal")),
                                            "two" = list(reop_master_list$reop_master_currency_string,
                                                         reop_master_list$reop_master_currency_string,
                                                         reop_master_list$reop_master_currency_string,
                                                         get_units(input$kpi1,
                                                                   reop_master_list$reop_master_list[[1]]$all_units),
                                                         get_units(input$kpi1,
                                                                   reop_master_list$reop_master_list[[1]]$all_units),
                                                         get_units(input$kpi1,
                                                                   reop_master_list$reop_master_list[[1]]$all_units),
                                                         paste0(reop_master_list$reop_master_currency_string, "_decimal"),
                                                         paste0(reop_master_list$reop_master_currency_string, "_decimal")),
                                            "one_bh" = list(reop_master_list$reop_master_currency_string,
                                                            get_units(input$kpi1,
                                                                      reop_master_list$reop_master_list[[1]]$all_units)),
                                            "two_bh" = list(reop_master_list$reop_master_currency_string,
                                                            reop_master_list$reop_master_currency_string,
                                                            reop_master_list$reop_master_currency_string,
                                                            get_units(input$kpi1,
                                                                      reop_master_list$reop_master_list[[1]]$all_units),
                                                            get_units(input$kpi1,
                                                                      reop_master_list$reop_master_list[[1]]$all_units),
                                                            get_units(input$kpi1,
                                                                      reop_master_list$reop_master_list[[1]]$all_units)))
      
      
      if(chart_comparison_list$no_of_scenarios %in% c("two", "two_bh")){
      
      spend_max <- max(max(chart_comparison_list$data[[1]]$value),
                       chart_comparison_list$data[[2]]$value)
      
      response_max <- max(max(chart_comparison_list$data[[4]]$value),
                       chart_comparison_list$data[[5]]$value)

      perf_max <- max(max(chart_comparison_list$data[[7]]$value),
                      chart_comparison_list$data[[8]]$value)
      
      }
      
      chart_comparison_list$set_xaxis_range <- switch(chart_comparison_list$no_of_scenarios,
                                              "one" = list(NULL,
                                                           NULL,
                                                           NULL),
                                              "two" = list(c(0, spend_max),
                                                           c(0, spend_max),
                                                           c(-spend_max, spend_max),
                                                           c(0, response_max),
                                                           c(0, response_max),
                                                           c(-response_max, response_max),
                                                           c(0, perf_max),
                                                           c(0, perf_max)),
                                              "one_bh" = NULL,
                                              "two_bh" = NULL)
      
      # chart_comparison_list$chart_titles <- switch(chart_comparison_list$no_of_scenarios,
      #                                              "one" = names(chart_comparison_list$data),
      #                                              "two" = c(0.10625, 0.13125, 0.13125, 0.13125, 0.13125, 0.13125, 0.13125, 0.10625),
      #                                              "one_bh" = list(TRUE, FALSE),
      #                                              "two_bh" = list(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE))
      # 
      # chart_comparison_list$shift_chart_title <- switch("one" = list(30, 30, 30),
      #                                                   "two" = c(0.10625, 0.13125, 0.13125, 0.13125, 0.13125, 0.13125, 0.13125, 0.10625),
      #                                                   "one_bh" = list(TRUE, FALSE),
      #                                                   "two_bh" = list(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE))
      # 
      
      chart_comparison_list$widths <- switch(chart_comparison_list$no_of_scenarios,
                                                            "one" = c(0.3333, 0.33333, 0.333333),
                                                            "two" = c(0.10625, 0.13125, 0.13125, 0.13125, 0.13125, 0.13125, 0.13125, 0.10625),
                                                            "one_bh" = list(TRUE, FALSE),
                                                            "two_bh" = list(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE))
      
      
      
    },
    ignoreInit = TRUE)
    
    
    # Make chart 
    
    
    ns <- session$ns
    
    observeEvent(input$debug,{ browser() })
    
    output$plotly_chart <- renderPlotly({  
      
      mapply(one_plot,
             chart_comparison_list$data,
             # yaxis_showticklabel = list(TRUE, FALSE, FALSE),
             yaxis_showticklabel = chart_comparison_list$set_yaxis_tick_labels,
             # chart_title = list("SPEND", "RESP <BR> ONSE", "ROI"),
             xaxis_range = chart_comparison_list$set_xaxis_range,
             chart_title = names(chart_comparison_list$data),
             bar_color = chart_comparison_list$color_of_bars,
             # Always currency
             units = chart_comparison_list$units,
             SIMPLIFY = FALSE) %>%
        subplot(nrows = 1,
                titleX = FALSE,
                shareY = TRUE,
                # Needed otherwise subplot does not share the widths equally between the plots :///
                widths = chart_comparison_list$widths
                # margin = c(0.25,0.25,0.25,0.25)
                  ) %>% 
          config(modeBarButtons = list(list("toImage")), 
                 displaylogo = FALSE, 
                 toImageButtonOptions = list(filename = "plotOutput"))
        # %>% 
      # partial_bundle() Now we are calling the plotly via render UI in the server, this causes an error
      
    })
    
    output$plotly_chart_output <- renderUI({
      
      # browser()
      
      plotlyOutput(ns("plotly_chart"),
                   # height = "100%")
                   height = chart_comparison_list$plotly_height)
      
    })
    
    observe({
      updateSelectInput(
        session = session, 
        inputId = "scenario_name1",
        choices = reop_master_list$reop_master_list_all_results$scenario_name %>% unique()
      )})
    
    observe({
      updateSelectInput(
        session = session, 
        inputId = "scenario_name2",
        choices = reop_master_list$reop_master_list_all_results$scenario_name %>% unique()
      )})
    
    observe({
      updateSelectInput(
        session = session, 
        inputId = "kpi1",
        choices = reop_master_list$reop_master_list_all_results$kpi_label %>% unique()
      )})
    
    
    
    
    
    
  })}


ui <- fluidPage(
  
  mod_06_reop_mmm_master_01_comparison_chart_ui("example")
  
)

server <- function(input, output, session){
  
  mod_06_reop_mmm_master_01_comparison_chart_server("example")
  
}

shinyApp(ui, server)

