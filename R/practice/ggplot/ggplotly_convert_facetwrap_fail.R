# original code that makes the chart ---------------------------

get_scenario_summary <- function(all_scenarios_table,
                                 scenario,
                                 kpi1,
                                 kpi1_unit,
                                 group_variable,
                                 colname_spend,
                                 colname_response){
  
  # stop notes when run devtools::check()
  
  scenario_name <- NULL
  response_at_optim <- NULL
  kpi.level1_name <- NULL
  optim_spend <- NULL
  .data <- NULL
  
  scenario_data <- all_scenarios_table %>%
    dplyr::filter(scenario_name == scenario,
                  kpi.level1_name == kpi1,
                  !is.na(optim_spend)) # remove rows with period_level1 not optimised over
  
  scenario_spend <- scenario_data %>%
    dplyr::group_by(.data[[group_variable]]) %>%
    dplyr::summarise(!!colname_spend := sum(optim_spend))
  
  # Currently we are hard coding based on some assumptions ...
  if (kpi1_unit == "percentage"){
    
    # ... we sum the contribution across period level2
    if (group_variable == "period_level2.name"){
      scenario_response <- scenario_data %>%
        dplyr::group_by(.data[[group_variable]]) %>%
        dplyr::summarise(!!colname_response := sum(response_at_optim))
    } else {
      
      # ... as average the contribution across other channels
      scenario_response <- scenario_data %>%
        dplyr::group_by(.data[[group_variable]]) %>%
        dplyr::summarise(!!colname_response := mean(response_at_optim))
    }
  } else {
    scenario_response <- scenario_data %>%
      dplyr::group_by(.data[[group_variable]]) %>%
      dplyr::summarise(!!colname_response := sum(response_at_optim))
  }
  
  return(list(data = scenario_data,
              spend = scenario_spend,
              response = scenario_response))
}


get_comparison_data <- function(all_scenarios_table, scenario1, scenario2,
                                kpi1, kpi1_unit, group_variable,
                                string_kpi1_s1, string_kpi1_s2, string_kpi1_diff,
                                string_perf_ind_s1, string_perf_ind_s2){
  
  # stop notes when run devtools::check()
  `SPEND S1` <- NULL
  `SPEND S2` <- NULL
  metric <- NULL
  
  data_scenario1 <- get_scenario_summary(all_scenarios_table,
                                         scenario1,
                                         kpi1,
                                         kpi1_unit,
                                         group_variable,
                                         "SPEND S1",
                                         string_kpi1_s1)
  
  data_scenario2 <- get_scenario_summary(all_scenarios_table,
                                         scenario2,
                                         kpi1,
                                         kpi1_unit,
                                         group_variable,
                                         "SPEND S2",
                                         string_kpi1_s2)
  
  comparison_spend <- data_scenario1$spend %>%
    dplyr::left_join(data_scenario2$spend, by = group_variable) %>%
    dplyr::mutate(`SPEND (S1 - S2)` = `SPEND S1` - `SPEND S2`)
  
  comparison_response <- data_scenario1$response %>%
    dplyr::left_join(data_scenario2$response, by = group_variable) %>%
    dplyr::mutate(!!string_kpi1_diff := !!rlang::sym(string_kpi1_s1) - !!rlang::sym(string_kpi1_s2))
  
  
  comparison_performance_indicator <- comparison_spend %>%
    dplyr::left_join(comparison_response)
  
  if (kpi1_unit == "percentage"){
    comparison_performance_indicator <- comparison_performance_indicator %>%
      dplyr::mutate(!!string_perf_ind_s1 := `SPEND S1` / !!rlang::sym(string_kpi1_s1),
                    !!string_perf_ind_s2 := `SPEND S2` / !!rlang::sym(string_kpi1_s2))
  } else if (kpi1_unit == "volume") {
    comparison_performance_indicator <- comparison_performance_indicator %>%
      dplyr::mutate(!!string_perf_ind_s1 := 1e6 * `SPEND S1` / !!rlang::sym(string_kpi1_s1),
                    !!string_perf_ind_s2 := 1e6 * `SPEND S2` / !!rlang::sym(string_kpi1_s2))
  } else {
    comparison_performance_indicator <- comparison_performance_indicator %>%
      dplyr::mutate(!!string_perf_ind_s1 := !!rlang::sym(string_kpi1_s1) / `SPEND S1`,
                    !!string_perf_ind_s2 := !!rlang::sym(string_kpi1_s2) / `SPEND S2`)
  }
  
  comparison_performance_indicator <- comparison_performance_indicator %>%
    dplyr::select(1, !!rlang::sym(string_perf_ind_s1), !!rlang::sym(string_perf_ind_s2)) %>%
    tidyr::pivot_longer(cols = -1,
                        names_to = "metric",
                        values_to = "value") %>%
    dplyr::mutate(metric = factor(metric, levels = c(string_perf_ind_s1,
                                                     string_perf_ind_s2)))
  
  comparison_spend <- comparison_spend %>%
    tidyr::pivot_longer(cols = -1,
                        names_to = "metric",
                        values_to = "value") %>%
    dplyr::mutate(metric = factor(metric, levels = c("SPEND S1",
                                                     "SPEND S2",
                                                     "SPEND (S1 - S2)")))
  
  comparison_response <- comparison_response %>%
    tidyr::pivot_longer(cols = -1,
                        names_to = "metric",
                        values_to = "value") %>%
    dplyr::mutate(metric = factor(metric, levels = c(string_kpi1_s1,
                                                     string_kpi1_s2,
                                                     string_kpi1_diff)))
  
  return(list(spend = comparison_spend,
              response = comparison_response,
              performance_indicator = comparison_performance_indicator))
  
}



currency_string_to_symbol <- function(string){
  currency_symbol <- switch(string,
                            "pounds"  = "\u00A3",
                            "dollars" = "\u0024"
  )
  
  if (is.null(currency_symbol)) currency_symbol = ""
  
  return(currency_symbol)
}

subchart_comparison_overview <- function(all_data,
                                         a_metric,
                                         group_variable,
                                         string_kpi1_s1,
                                         string_kpi1_s2,
                                         string_kpi1_diff,
                                         string_perf_ind_s1,
                                         string_perf_ind_s2,
                                         currency_symbol,
                                         kpi1_unit){
  
  # stop notes when running devtools::check()
  
  .data <- NULL
  metric <- NULL
  value <- NULL
  
  ymax <- max(all_data[[a_metric]][["value"]], na.rm = TRUE)
  
  ggplot2::ggplot(
    data = all_data[[a_metric]],
    ggplot2::aes(
      
      x = if(group_variable != "period_level2.name"){
        if (a_metric != "performance_indicator"){
          forcats::fct_reorder(
            .f = .data[[group_variable]],
            .x = all_data$spend$value,
            .fun = dplyr::first
          )
        } else {
          forcats::fct_reorder(
            .f = .data[[group_variable]],
            .x = all_data$spend %>%
              dplyr::filter(metric %in% c("SPEND S1", "SPEND S2")) %>%
              dplyr::pull(value),
            .fun = dplyr::first
          )
        }
      } else {
        x = forcats::fct_rev(f = .data[[group_variable]])
      },
      y = value,
      fill = metric,
      text = if (a_metric == "spend"){
        paste0(
          .data[[group_variable]], "\n",
          metric, ": ",
          scales::number(value,
                         accuracy = 1,
                         prefix = currency_symbol,
                         big.mark = ",")
        )
      } else if (a_metric == "performance_indicator"){
        paste0(
          .data[[group_variable]], "\n",
          metric, ": ",
          ifelse(value < 100,
                 scales::number(value,
                                accuracy = 0.01,
                                prefix = currency_symbol,
                                big.mark = ","),
                 scales::number(value,
                                accuracy = 1,
                                prefix = currency_symbol,
                                big.mark = ",")
          )
        )
      } else if (a_metric == "response"){
        if (kpi1_unit == "percentage"){
          paste0(
            .data[[group_variable]], "\n",
            metric, ": ",
            scales::percent(value,
                            accuracy = 0.1)
          )
        } else {
          paste0(
            .data[[group_variable]], "\n",
            metric, ": ",
            ifelse(value < 100,
                   scales::number(value,
                                  accuracy = 0.01,
                                  prefix = currency_symbol,
                                  big.mark = ","),
                   scales::number(value,
                                  accuracy = 1,
                                  prefix = currency_symbol,
                                  big.mark = ",")
            )
          )
        }
      }
    )
  ) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::geom_abline(intercept = 0, slope = 0, lty = 2, color = "grey") +
    ggplot2::geom_text(
      ggplot2::aes(
        y = 0.75 * ymax,
        label = if (a_metric == "spend"){
          ifelse(value < 1e6,
                 scales::label_number_si(prefix = currency_symbol)(value),
                 scales::label_number_si(prefix = currency_symbol, accuracy = 0.1)(value)
          )
        } else if (a_metric == "response"){
          if (kpi1_unit == "percentage"){
            scales::percent(value,
                            accuracy = 0.1)
          } else if (kpi1_unit == "volume"){
            ifelse(value < 1e6,
                   scales::label_number_si()(value),
                   scales::label_number_si(accuracy = 0.1)(value)
            )
          } else {
            ifelse(value < 1e6,
                   scales::label_number_si(prefix = currency_symbol)(value),
                   scales::label_number_si(prefix = currency_symbol, accuracy = 0.1)(value)
            )
          }
        } else if (a_metric == "performance_indicator"){
          if (kpi1_unit == "percentage"){
            ifelse(value < 100,
                   scales::label_number_si(prefix = currency_symbol)(value),
                   scales::label_number_si(prefix = currency_symbol, accuracy = 0.1)(value)
            )
          } else if (kpi1_unit == "volume"){
            ifelse(value < 100,
                   scales::label_number_si(prefix = currency_symbol)(value),
                   scales::label_number_si(prefix = currency_symbol, accuracy = 0.1)(value)
            )
          } else {
            ifelse(value < 100,
                   scales::label_number_si(prefix = currency_symbol, accuracy = 0.1)(value),
                   scales::label_number_si(prefix = currency_symbol)(value)
            )
          }
          
        }
      )
    ) +
    ggplot2::scale_fill_manual(values = stats::setNames(
      c("#FF245B", "#FF245B", "#00DC7C", "#00DC7C",
        "#4DBAC1", "#4DBAC1", "#C2C5CC", "#C2C5CC"),
      c("SPEND S1", "SPEND S2", string_kpi1_s1, string_kpi1_s2,
        string_perf_ind_s1, string_perf_ind_s2, "SPEND (S1 - S2)", string_kpi1_diff)
    ))   +
    ggplot2::facet_grid(cols = ggplot2::vars(metric),
                        scales = "fixed",
                        labeller = ggplot2::label_wrap_gen(width = 10,
                                                           multi_line = TRUE)) +
    ggplot2::coord_flip() +
    ggplot2::theme(
      text = ggplot2::element_text(size = 14,
                                   color = "#0D0D0D",
                                   family = "Calibri"),
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      axis.text = ggplot2::element_text(color = "#0D0D0D"),
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = if (a_metric != "spend") ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.title = ggplot2::element_text(face = "bold"),
      panel.background = ggplot2::element_blank(),
      plot.margin = ggplot2::unit(c(0, 0, 0, 0), units = "cm"),
      legend.position = "none"
    )
  
}

# kpi1 title
string_kpi1_s1   <- paste(stringr::str_to_upper(kpi1), "S1")
string_kpi1_s2   <- paste(stringr::str_to_upper(kpi1), "S2")
string_kpi1_diff <- paste(stringr::str_to_upper(kpi1), "(S1 - S2)")

# alloc unit currency name
currency_name <- all_scenarios_table %>%
  dplyr::pull(alloc.unit_currency) %>%
  .[[1]]

# alloc unit currency symbol to use in plots
currency_symbol <- currency_name %>%
  currency_string_to_symbol()

# kpi1 unit (a particular currency, percentage, volume)
kpi1_unit <- all_scenarios_table %>%
  dplyr::filter(kpi.level1_name == kpi1) %>%
  dplyr::pull(kpi_unit) %>%
  dplyr::first()

# performance indicator (metric) title
# if kpi unit is currency, and assuming it is the same as alloc unit
# the performance metric should be an ROI
if (kpi1_unit == currency_name){
  string_perf_ind_s1 <- "ROI S1"
  string_perf_ind_s2 <- "ROI S2"
} else if (kpi1_unit == "percentage") {
  string_perf_ind_s1 <- "COST PER 1% S1"
  string_perf_ind_s2 <- "COST PER 1% S2"
} else if (kpi1_unit == "volume") {
  string_perf_ind_s1 <- "COST PER 1M S1"
  string_perf_ind_s2 <- "COST PER 1M S2"
}

group_variable <- switch(chosen_grouping,
                         "channel" = "channel_name",
                         "channel.group.level1" = "channel.group.level1_name",
                         "channel.group.level2" = "channel.group.level2_name",
                         "channel.group.level3" = "channel.group.level3_name",
                         "period_level2" = "period_level2.name"
)

comparison_data <- get_comparison_data(all_scenarios_table,
                                       scenario1,
                                       scenario2,
                                       kpi1,
                                       kpi1_unit,
                                       group_variable,
                                       string_kpi1_s1,
                                       string_kpi1_s2,
                                       string_kpi1_diff,
                                       string_perf_ind_s1,
                                       string_perf_ind_s2)


plot_spend <- subchart_comparison_overview(comparison_data,
                                           "spend",
                                           group_variable,
                                           string_kpi1_s1,
                                           string_kpi1_s2,
                                           string_kpi1_diff,
                                           string_perf_ind_s1,
                                           string_perf_ind_s2,
                                           currency_symbol,
                                           kpi1_unit)

my_plotly <- plotly::ggplotly(plot_spend,
                             tooltip = c("text"))

# my_plotly$x$layout$shapes[[1]]$y0 <- 10
# still not fixed with github version of plotly
# https://github.com/plotly/plotly.R/issues/1224
my_plotly

