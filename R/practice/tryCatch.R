# remotes::install_github("cath-parkinson/mm.reoptimise",
                        # ref = "feature/check-inputdata",
                        # auth_token = "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",
                        # force = T)

# set wd to this directory

file_path <- file.path("..", "..", "data", "re_optimise", "scenario_0", "input_data.xlsx")
file_path_for_list <- file.path("..", "..", "data", "re_optimise")
scenario_list <- mm.reoptimise::create_scenario_list(file_path_for_list)

file_path <- file.path("..", "..", "data", "re_optimise", "check4", "input_data.xlsx")

tryCatch(
  
  error = function(cnd) {
    cnd$message    
  },
  
  {
    mm.reoptimise::check_input_data(file_path)
    scenario <- mm.reoptimise::create_scenario(file_path)
    # why does this return null?
    mm.reoptimise::check_input_data_matches_scenario_list(scenario, scenario_list)
    
  }
  
  
)
