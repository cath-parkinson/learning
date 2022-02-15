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
  mutate(selected = 1) 

# map upwards where the child is exactly the same as the parent
# df <- df %>% 
#   mutate(check_kpi_3to2 = kpi.level3_name == kpi.level2_name) %>% 
#   mutate(check_kpi_2to1 = kpi.level2_name == kpi.level1_name) %>% 
#   mutate(kpi.level3_name = ifelse(check_kpi_3to2, NA, kpi.level3_name)) %>% 
#   mutate(kpi.level2_name = ifelse(check_kpi_2to1, NA, kpi.level2_name)) %>% 
#   select(-check_kpi_3to2, -check_kpi_2to1)

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

df_summary <- ToDataFrameTypeCol(tree,
                                 # "level",
                                 "pathString",
                                 "weight",
                                 "selected")

# final list ready for scenario
kpi_summary <- list(tree = tree,
                    df = df_summary)


# first set of scenario options

# tree <- kpi_summary$tree
# df <- kpi_summary$df

get_kpi1 <- df %>% pull(kpi.level1_name) %>% unique()

get_kpi2 <- function(kpi1_selected){

  df %>% filter(kpi.level1_name == kpi1_selected) %>%
    pull(kpi.level2_name) %>%
    unique()
  }

get_kpi3 <- function(kpi1_selected, kpi2_selected){

  df %>%
    filter(kpi.level1_name == kpi1_selected) %>%
    filter(kpi.level2_name == kpi2_selected) %>%
    pull(kpi.level3_name) %>%
    unique()
}

get_kpi2(kpi1_selected = "brand health")
get_kpi3(kpi1_selected = "brand health",
         kpi2_selected = "brand health")

plot(tree)

# level 1
tree$children %>% names()
tree$children %>% names() %>% length()

# level2 = if this returns NULL don't show the next box
tree$children[[1]]$children %>% names()
tree$children[[2]]$children %>% names()

# level 3 = if this returns NULL, don't show the next box
tree$children[[1]]$children[[1]]$children %>% names()
tree$children[[2]]$children[[1]]$children %>% names()
tree$children[[2]]$children[[2]]$children %>% names()

# then collect the selected items
# use position to assisn the selected kpi to 1

# ideally would do this using a function and recursion! come back to this
# work from botton down - if it works
# tree$children[[2]]$children[[1]]$children[[1]]$selected <- 1
# tree$children[[2]]$children[[1]]$selected <- 1
# tree$children[[2]]$selected <- 1
# 
# tree$children[[2]]$children[[1]]$s

# applying weights to the whole tree

# Weight <- function(node){
#   
#   result <- node$weight
#   
#   
# }



# df_summary <- ToDataFrameTypeCol(tree, 
#                                  # "level", 
#                                  "weight", 
#                                  "selected") 


print(tree, "weight", "selected")

# example of applying recursive functions

Selected <- function(node) {
  result <- node$selected
  if(length(result) == 0) result <- sum(sapply(node$children, Selected))
  return (result)
}

Weighted <- function(node) {
  result <- node$weight
  if(length(result) == 0) result <- mean(sapply(node$children, Weighted))
  return (result)
}

print(tree, selected = Selected, weight = Weighted)
print(tree, "weight", "selected")

# apply weights in same way

# needs to divide the number by however many children there are

tree$children[[2]]$children[[1]]$newweight <- 0.8
tree$children[[2]]$children[[2]]$newweight <- 0.2
print(tree, "weight", "selected", "newweight")

tree$children[[1]]$newweight <- 0.8
tree$children[[2]]$newweight <- 0.2
print(tree, "weight", "selected", "newweight")


# 
# NewWeights1 <- function(node) {
#   result <- node$newweight
#   if(length(result) == 0) result <- sum(sapply(node$children, NewWeights1))
#   return (result)
# }
# 
# print(tree, "weight", "selected", newweights = NewWeights1)

NewWeights <- function(node){
  parent_weight <- node$parent$newweight
  sibling_number <- length(node$siblings)
  if(length(parent_weight > 0)){ node$weight <- parent_weight / (sibling_number+1)}
}

print(tree, "weight", "selected", newweights = NewWeights)

tree$parent$newweight
