library(shiny)
library(shinyWidgets)
library(tibble)
library(mm.reoptimise)
library(tidyr)
library(dplyr)

scenario_list <- mm.reoptimise::create_scenario_list("data/three2 - update")
scenario <- scenario_list[[1]]

df <- scenario$curves_full

# read in kpi_weight_master
df <- df %>% 
  select(period_level1,
         kpi.level1_name, 
         kpi.level2_name, 
         kpi.level3_name,
         kpi_unit,
         kpi.level1_weight,
         kpi.level2_weight,
         kpi.level3_weight) %>% 
  distinct() %>% 
  mutate(master_weight = rowMeans(select(., contains("weight")), 
                                  na.rm =T))
   
# functions

get_kpi1 <- function(df, type = "all"){
  
  if (type == "selected") { df <- df %>% filter(selected == 1) }
  df %>% pull(kpi.level1_name) %>% unique()  
}

get_kpi2 <- function(df, type = "all", kpi1_selected){
  
  if(type == "all") {
  
  df %>% filter(kpi.level1_name %in% kpi1_selected) %>%
    pull(kpi.level2_name) %>%
    unique()
    
  } else if(type == "selected") {
    
    df %>% filter(selected == 1) %>% pull(kpi.level2_name) %>% unique()
    
  }
}

get_kpi3 <- function(df, type = "all", kpi1_selected, kpi2_selected){
  
  if(type == "all"){
  
    df %>%
      filter(kpi.level1_name %in% kpi1_selected) %>%
      filter(kpi.level2_name %in% kpi2_selected) %>%
      pull(kpi.level3_name) %>%
      unique()
  
  } else if(type == "selected"){
    
    df %>% filter(selected == 1) %>% pull(kpi.level3_name) %>% unique()
    
  }
  
}

# prove I can pass the selected

# single select
selectedkpi1 <- get_kpi1(df)[1]
selectedkpi2 <- get_kpi2(df, selectedkpi1[1])[1]
selectedkpi3 <- get_kpi3(df, selectedkpi1[1], selectedkpi2[1])[1]

# null
selectedkpi1 <- NULL
selectedkpi2 <- NULL
selectedkpi3 <- NULL

# multi select
# selectedkpi1 <- get_kpi1(df, type = "all")[2]
# selectedkpi2 <- get_kpi2(df, type = "all", selectedkpi1[1])[c(1,2)]
# selectedkpi3 <- get_kpi3(df, type = "all", selectedkpi1[1], selectedkpi2)[c(1,2,3)]


ui <- fluidPage(
  
  tagList(
  
  pickerInput(inputId = "kpiselect1",
              label = "KPI",
              choices = get_kpi1(df, type = "all"),
              # selected = NULL,
              selected = selectedkpi1,
              multiple = T,
              pickerOptions(maxOptions = 1)), # if units are different then set this to 1
  uiOutput(outputId = "kpiselect2"),
  uiOutput(outputId = "kpiselect3")
  
  )
  
)

server <- function(input, output, session) {
  
  output$kpiselect2 <- renderUI({
    
    req(input$kpiselect1)
    
    pickerInput(inputId = "kpiselect2",
                choices = get_kpi2(df, type = "all", input$kpiselect1),
                selected = selectedkpi2,
                multiple = T)
    
  })
  
  output$kpiselect3 <- renderUI({
    
    req(input$kpiselect2)
    
    if(!is.na(get_kpi3(df, type = "all", input$kpiselect1, input$kpiselect2)[1])){
    
    pickerInput(inputId = "kpiselect3",
                choices = get_kpi3(df, type = "all", input$kpiselect1, input$kpiselect2),
                selected = selectedkpi3,
                multiple = T)
   
    }
      
  })
  
}

shinyApp(ui = ui, server = server)