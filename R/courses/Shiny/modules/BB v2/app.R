library(shiny)
library(shinydashboard)
library(rhandsontable)
library(readxl)
library(dplyr)
library(tidyverse)
library(highcharter)
library(lubridate)
library(formattable)
library(scales)

# Combined ------------------------

# source("reoptimise.R")


## UI: sidebar --------------------

sidebar <- dashboardSidebar(
  
  sidebarMenu(
    id = "tabs",
    menuItem("Info", tabName = "info", icon = icon("info")),
    menuItem("re:Optimise MMM", tabName = "reoptimiseMMM", icon = icon("bullseye")),
    menuItem("re:Forecast", tabName = "reforecast", icon = icon("sliders-h"))
  )
)

## UI: body --------------------------
body <- dashboardBody(
  
  # css
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
  ),
  
  tabItems(
    
    tabItem(tabName = "info",
            fluidPage()),
    
    tabItem(tabName = "reoptimiseMMM",
            fluidPage(
              
              tags$head(tags$style(HTML("body{color:#05498C; background-color:#21BBEF;}
                            *{font-family: calibri !important;}
                            #run_optim{background-color:#F63263;color:white;font-size:2em;height:1.7em;border-radius:7px;text-align: center;}
                            #run_optim:hover{background-color:#92D050}
                            h1{color:white; font-size:3.5em;background-color:#21BBEF; font-weight:bold; margin-left: 0.5em;}
                            h4{-webkit-transform: rotate(270deg) !important; font-size:1.8em;text-align: left;}
                            h3{font-size:1.8em;}
                            h5{font-size:1.4em;}
                            .nav li a{;color:#05498C;font-size: 1.4em; text-indent: 0em;}
                            .nav li a:hover{color:#05498C}
                            .arrow_exp{margin-left:50px;}
                            .expand{color:white;background-color:#21BBEF;border-radius:7px;padding:5px 10px;font-size:1.5em,height:3em;}
                            .noexpand{color:white;background-color:#05498C;border-radius:7px;padding:5px 10px;font-size:1.5em,height:3em;}
                            .expand:hover{background-color:#05498C;cursor: pointer;}
                            div.line{background-color:#05498C}
                            li{font-size:1.4em;padding: 0px 0px 3px 20px; text-indent: -1.4em;}
                            #total_budget.form-control.shiny-bound-input {font-size:1.5em;height: 2em;color:black}
                            div.budgetinput{font-size:1.5em;}
                            #plot.recalculating {z-index: -2;}
                            .shiny-notification {size: 50em}
                            div.radioSelect{font-size:1.5em;height: 50px; color:black}"))),
              
              # fluidRow(class = "header_row",
              #          column(10,tags$div(
              #            HTML(paste(tags$span(style = "color:#05498C; font-size:5em;background-color:#21BBEF; font-weight:bold;","RE"), 
              #                       tags$span(style="color:white; font-size:3.5em;background-color:#21BBEF; font-weight:bold;", "Optimise"), sep = ""))
              #          ))),
              # #hr(),
              
              wellPanel(style = "background-color: white;",tabsetPanel(id = "tabs",type = "pills",
                                                                       # ui - home                   ####
                                                                       tabPanel("Home",
                                                                                
                                                                                hr(),
                                                                                fluidRow(
                                                                                  column(6,h3(strong("Overview")),
                                                                                         p(),
                                                                                         h5("Use this tool to run media scenarios that optimise profit from gross adds or brand health. The tool is based on the diminishing returns curves measured for each channel over the last 52 weeks, Jan 2020 - Dec 2020. TV and OOH were not ran in this time, therefore curves are built from uplift measured in 2019."),
                                                                                         p(),
                                                                                         tags$li("Profit = Gross Adds * AMPU"),
                                                                                         tags$li("Brand Health = Percentage point increase in aided awareness (averaged across the year)"),
                                                                                         h3(strong("Instructions")),
                                                                                         # tags$li("Select optimisation type - budget level or target uplift"),
                                                                                         # tags$li("Select budget level or target revenue"),
                                                                                         tags$li("Set your objective - profit, gross adds or brand health"),
                                                                                         tags$li("Choose your optimisation constraints - these are the minimum and maximum spends we could realistically invest within each channel"),
                                                                                         tags$li("Run optimisation. You can then download and compare your plans!"),
                                                                                         p(),
                                                                                         h3(strong("Outputs")),
                                                                                         tags$li("Recommended spends"),
                                                                                         tags$li("Incremental uplift and efficiency"),
                                                                                         p(),
                                                                                         # h3(strong("Upload Saved Scenario")), fileInput("file1", NULL,accept = c('.xlsx','.xls','.xlsm')),
                                                                                         h3(strong("Download Scenario")),
                                                                                         downloadButton("downloadData_2", "Download Scenario")),
                                                                                  # downloadButton("downloadData_2", "Download New vs. Retained Breakdown"),
                                                                                  column(4, imageOutput("image"))
                                                                                )
                                                                       ),
                                                                       
                                                                       # ui - constraints            ####
                                                                       tabPanel("Set-up",
                                                                                
                                                                                
                                                                                hr(),
                                                                                
                                                                                
                                                                                h2(id="c15a",class="expand","1. Select optimisation type:"),
                                                                                div(id = "c15b",
                                                                                    
                                                                                    h3("Use the drop down to select objective type:"),
                                                                                    fluidRow(column(2, selectInput("salestypeselect", NULL, c("Profit","Gross Adds", "Brand Health"), selected = "All"))),
                                                                                    
                                                                                    br(),
                                                                                    
                                                                                    #CEP put this into one divider, so can only show select_type if select profit above
                                                                                    div(id = "select_type", 
                                                                                        h3("Select optimisation type:"), 
                                                                                        div(class = "radioSelect",radioButtons("choose_type", NULL, c("I have an objective"="constrained","I want best case scenario"="free"
                                                                                        ), selected = "constrained", inline = F))),
                                                                                    
                                                                                    
                                                                                    br(),
                                                                                    
                                                                                    div(id = "const_type2",
                                                                                        h3("Select objective type:"),
                                                                                        div(class = "radioSelect",radioButtons("choose_type2", NULL, c("I have a budget to optimise"="budget","I have a target"="profit"
                                                                                        ), selected = "budget", inline = F)),
                                                                                        br(), 
                                                                                        
                                                                                        h3(textOutput("optimtype")),
                                                                                        div(class = "budgetinput",rHandsontableOutput("budget",width = "400px")))),
                                                                                
                                                                                div(id = "constraints", 
                                                                                    h5("Use sections 2-5 to select any month, channel, campaign and detailed constraints."),
                                                                                    
                                                                                    h2(id="c1a",class="expand","2. Input monthly spend constraints:"),
                                                                                    div(id = "c1b", 
                                                                                        h5("Amend min or max monthly spends where we want to restrict/exclude budgets on certain months."),
                                                                                        withLoader(rHandsontableOutput("constr1",width = "400px"),type = "html", loader = "loader1"),
                                                                                        h5("Did you know? To unselect a month, set the max spend to zero."),
                                                                                        h5("Did you know? To overlay committed existing spends, input the same spend for min and max.")),
                                                                                    
                                                                                    h2(id="c2a",class="expand","3. Input channel spend constraints:"),
                                                                                    div(id = "c2b", 
                                                                                        h5("Amend min or max channel spends where we want to restrict/exclude budgets on certain channels."),
                                                                                        withLoader(rHandsontableOutput("constr2",width = "400px"),type = "html", loader = "loader1"),
                                                                                        h5("Did you know? To unselect a channel, set the max spend to zero."),
                                                                                        h5("Did you know? To overlay committed existing spends, input the same spend for min and max.")),
                                                                                    
                                                                                    h2(id="c3a",class="expand","4. Input campaign constraints:"),
                                                                                    div(id = "c3b", 
                                                                                        h5("Amend min or max channel spends where we want to restrict/exclude budgets on certain campaigns."),
                                                                                        withLoader(rHandsontableOutput("constr3",width = "400px"),type = "html", loader = "loader1"),
                                                                                        h5("Max should be left at current levels unless you wish to exclude a campaign from the optimisation.")),
                                                                                    
                                                                                    h2(id="c4a",class="expand","5. Input specific spend constraints:"),
                                                                                    div(id = "c4b", 
                                                                                        h5("Amend min or max specific spends where we want to restrict/exclude budgets on certain months."),
                                                                                        withLoader(rHandsontableOutput("rawdata",width = "800px"),type = "html", loader = "loader1"))
                                                                                    
                                                                                ),
                                                                                
                                                                                fluidRow(column(3,offset = 9, actionButton("run_optim","Run Optimisation")))),
                                                                       
                                                                       # ui - results                ####
                                                                       
                                                                       tabPanel("Results",
                                                                                tabsetPanel(id = "tabs2",type = "pills",selected = "Topline",
                                                                                            hr(),
                                                                                            
                                                                                            tabPanel("Topline",
                                                                                                     condition = "channel_type != 'Profit'",
                                                                                                     fluidRow(h2(id="r8a",class="noexpand","Optimised Budget"),
                                                                                                              column(width = 3,withSpinner(plotOutput("plot1",height = "200px"))),
                                                                                                              column(width = 3,withSpinner(plotOutput("plot2unitstest",height = "200px"))),
                                                                                                              column(width = 2,withSpinner(plotOutput("plot2",height = "200px"))),
                                                                                                              column(width = 2,withSpinner(plotOutput("plot3",height = "200px"))),
                                                                                                              column(width = 2,withSpinner(plotOutput("plot2_BH",height = "200px")))),
                                                                                                     fluidRow(h2(id="r9a",class="noexpand","Last Year Budget"),
                                                                                                              column(width = 3,withSpinner(plotOutput("plot4",height = "200px"))),
                                                                                                              column(width = 3,withSpinner(plotOutput("plot5unitstest",height = "200px"))),
                                                                                                              column(width = 2,withSpinner(plotOutput("plot5",height = "200px"))),
                                                                                                              column(width = 2,withSpinner(plotOutput("plot6",height = "200px"))),
                                                                                                              column(width = 2,withSpinner(plotOutput("plot5_BH",height = "200px"))))
                                                                                            ),                           
                                                                                            
                                                                                            
                                                                                            
                                                                                            tabPanel("Laydown",
                                                                                                     fluidRow(
                                                                                                       column(width = 4,
                                                                                                              h3("Please Select Y-Axis"),
                                                                                                              div(class = "radioSelect",radioButtons("yaxis",NULL,c("Months" = "Months","Channels" = "Channels","Campaigns" = "Campaigns"),inline = T))),
                                                                                                       column(width =4,
                                                                                                              h3("Please Select X-Axis"),
                                                                                                              div(class = "radioSelect",radioButtons("xaxis",NULL,c("Months" = "Months","Channels" = "Channels","Campaigns" = "Campaigns"),inline = T)))
                                                                                                     ),
                                                                                                     h2(id="r11a",class="expand","Channel Laydown - Showing optimised monthly spend by channel"),
                                                                                                     div(id = "r11b",
                                                                                                         withSpinner(tableOutput("pivottable1")),
                                                                                                         fluidRow(column(11,offset = 1,plotlyOutput("plot7"))))),
                                                                                            
                                                                                            
                                                                                            tabPanel("Profit",
                                                                                                     
                                                                                                     h2(id="r1a",class="expand","Month Comparison"),
                                                                                                     div(id = "r1b",withSpinner(tableOutput("table1")),tableOutput("table1b")),
                                                                                                     
                                                                                                     h2(id="r2a",class="expand","Channel Comparison"),
                                                                                                     div(id = "r2b",withSpinner(tableOutput("table2")),tableOutput("table2b")),
                                                                                                     
                                                                                                     h2(id="r3a",class="expand","Product Comparison"),
                                                                                                     div(id = "r3b",withSpinner(tableOutput("table3")),tableOutput("table3b"))),
                                                                                            
                                                                                            
                                                                                            tabPanel("ROI",
                                                                                                     
                                                                                                     h2(id="r1aa",class="expand","Month Comparison"),
                                                                                                     div(id = "r1bb",withSpinner(tableOutput("table1c")),tableOutput("table1d")),
                                                                                                     
                                                                                                     h2(id="r2aa",class="expand","Channel Comparison"),
                                                                                                     div(id = "r2bb",withSpinner(tableOutput("table2c")),tableOutput("table2d")),
                                                                                                     
                                                                                                     h2(id="r3aa",class="expand","Product Comparison"),
                                                                                                     div(id = "r3bb",withSpinner(tableOutput("table3c")),tableOutput("table3d"))),
                                                                                            
                                                                                            tabPanel("BH",
                                                                                                     
                                                                                                     #        h2(id="r1aaa",class="expand","Month Comparison"),
                                                                                                     #        div(id = "r1bbb",withSpinner(tableOutput("table1e")),tableOutput("table1f")),
                                                                                                     
                                                                                                     h2(id="r2aaa",class="expand","Channel Comparison"),
                                                                                                     div(id = "r2bbb",withSpinner(tableOutput("table2e")),tableOutput("table2f")),
                                                                                                     
                                                                                                     h2(id="r3aaa",class="expand","Product Comparison"),
                                                                                                     div(id = "r3bbb",withSpinner(tableOutput("table3e")),tableOutput("table3f"))
                                                                                            ),
                                                                                            
                                                                                            # tabPanel("Store & Online Uplift",
                                                                                            #          h2(id="xxx",class="expand","Channel Breakdown"),
                                                                                            #          div(id = "store",withSpinner(tableOutput("table_store_split")),tableOutput("table_store_splitb"))),
                                                                                            # 
                                                                                            # tabPanel("GrossAdds & Retained Uplift",
                                                                                            #          h2(id="xxx",class="expand","Optimised Plan"),
                                                                                            #          div(id = "GrossAddsret",withSpinner(tableOutput("table_GrossAddsret_splitd"))),
                                                                                            #          h2(id="xxx",class="expand","Last Year Plan"),
                                                                                            #          div(id = "GrossAddsret",withSpinner(tableOutput("table_GrossAddsret_splitc"))),
                                                                                            #          h2(id="xxx",class="expand","Channel Breakdown (Optimised Plan)"),
                                                                                            #          div(id = "GrossAddsret",withSpinner(tableOutput("table_GrossAddsret_split")),tableOutput("table_GrossAddsret_splitb"))),
                                                                                            
                                                                                            tabPanel("Detailed Results",
                                                                                                     h2(id="r10a",class="expand","Detailed Results"),
                                                                                                     withSpinner(tableOutput("table4"))))))),
              
              useShinyjs()
              
              
            )),
    
    tabItem(tabName = "reforecast",
            fluidRow())
  )
  
)

## Run app ------------------------------------------

ui <- dashboardPage(dashboardHeader(title = "BB tools"),
                    sidebar,
                    body)


server <- function(input, output, session){
  
  data <- reactive(mtcars[[input$var]])
  
  output$hist <- renderPlot({
    hist(data(), breaks = input$bins, main = input$var)
  }, res = 96)  
}

shinyApp(ui, server)



