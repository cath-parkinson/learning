library(shiny)
library(shinyWidgets)
library(tibble)
library(mm.reoptimise)

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


mylist <- list(
  lower = c("a", "b", "c"),
  upper = c("a", "b", "c"))

master_list <- list(mylist1 = mylist,
                    mylist2 = mylist)

ui <- fluidPage(

  
  pickerInput(inputId = "picker",
              # choices = mylist,
              choices = master_list,
              multiple = TRUE)
    
)

server <- function(input, output, session) {}

shinyApp(ui = ui, server = server)