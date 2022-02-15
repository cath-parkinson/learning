#remotes::install_bitbucket("brightblueconsulting/mm.reoptimise", password = "Brightblue123")
library(mm.reoptimise)
library(data.tree)
library(dplyr)
library(tidyr)
library(DiagrammeR)

scenario_list <- mm.reoptimise::create_scenario_list("data/three2 - update")
scenario <- scenario_list[[1]]

df <- scenario$curves_full

# read in kpi_weight_master
df <- df %>% 
  select(kpi.level1_name, 
         kpi.level2_name, 
         kpi.level3_name) %>% 
  distinct()

df <- df %>% 
  mutate(weight = 1) %>% 
  mutate(selected = 0) 

df <- df %>% unite(col = "pathString",
                    kpi.level1_name,
                    kpi.level2_name,
                    kpi.level3_name,
                    na.rm = T,
                    remove = F,
                    sep = "/") %>%
  mutate(pathString = paste("kpi", pathString, sep = "/"))


tree <- as.Node(df, "weight", "selected")
print(tree, "weight", "selected")
plot(tree)

df_summary <- ToDataFrameTypeCol(tree,
                                 # "level",
                                 "pathString",
                                 "weight",
                                 "selected")

# final list ready for scenario
kpi_summary <- list(tree = tree,
                    df = df)


get_kpi1 <- function(df){
  
  df %>% pull(kpi.level1_name) %>% unique()
  
}

get_kpi2 <- function(df, kpi1_selected){
  
  df %>% filter(kpi.level1_name %in% kpi1_selected) %>%
    pull(kpi.level2_name) %>%
    unique()
}

get_kpi3 <- function(df, kpi1_selected, kpi2_selected){
  
  df %>%
    filter(kpi.level1_name %in% kpi1_selected) %>%
    filter(kpi.level2_name %in% kpi2_selected) %>%
    pull(kpi.level3_name) %>%
    unique()
}

# kpi1 <- get_kpi1(df)
# kpi2 <- get_kpi2(df, kpi1_selected = kpi1[1])
# kpi3 <- get_kpi3(df,
#                  kpi1_selected = kpi1[1],
#                  kpi2_selected = kpi2[1])




