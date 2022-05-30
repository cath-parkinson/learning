library(mm.reoptimise)

# remotes::install_github("cath-parkinson/mm.reoptimise",
#                         auth_token = "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",
#                         force = T)

path <- "."
scenario_list <- create_scenario_list(path)

myscenario1 <- set_scenario(
   scenario = scenario_list[[1]],
   period = "Annual",
   budget = 20e6,
   kpi1 = "Tourism Value"
)
myscenario1 <- run_optimization(myscenario1)

myscenario2 <- set_scenario(
   scenario = scenario_list[[1]],
   budget = NA,
   period = "Annual",
   kpi1 = "Incremental Preference"
)
myscenario2 <- run_optimization(myscenario2)

scenario_list <- add_scenario(scenario_list,
                              myscenario1,
                              user_name = "Tourism Value")
scenario_list <- add_scenario(scenario_list,
                              myscenario2,
                              user_name = "Preference")


# view outputs --------------------------------------------------
df <- create_all_scenarios_table(scenario_list)
all_scenarios_table <- df

scenario1 = "Tourism Value"
scenario2 = "Preference"
kpi1 = "Tourism Value"
chosen_grouping = "channel"

chart_comparison_overview(df,
                          scenario1 = "Tourism Value",
                          scenario2 = "Preference",
                          kpi1 = "Tourism Value",
                          chosen_grouping = "channel")


