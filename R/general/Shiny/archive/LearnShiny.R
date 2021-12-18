# intro ####

install.packages("shiny")
install.packages("plotly")
library(shiny)
library(plotly)

#create local html
#ui is user interface
ui <- fluidPage(
  "yo"
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

#
ui <- fluidPage(
  textInput("id1","insert text")
)

server <- function(input, output, session) {
  
}

#fluid page and server are the shiny functions
#textinput and textoutput are shiny functions too
ui <- fluidPage(
  textInput("id1","insert text"), 
  textOutput("id2")
  
)

server <- function(input, output, session) {
  
  output$id2 = renderText(({
    paste0(input$id1, "how are you doing?")
  }))
}

shinyApp(ui,server)

#get the files to load

ui <- fluidPage(
  textInput("id1","insert text"), 
  textOutput("id2"),
  fileInput("file1", "Choose CSV File", multiple= FALSE, accept = c("text/csv", "text/comma-separated-values, text/plain", ".csv")),

dataTableOutput("table1")
)

server <- function(input, output, session) {
  
  output$id2 = renderText(({
    paste0(input$id1, "how are you doing?")
  }))
  
  get_data = reactive({
    file = read.csv(input$file1)
    return(file)
    
    output$table1 = renderDataTable({
      get_data()})
    
  })

}

shinyApp(ui,server)

#show the files 

ui <- fluidPage(
  textInput("id1","insert text"), 
  textOutput("id2"),
  fileInput("file1", "Choose CSV File", multiple= FALSE, accept = c("text/csv", "text/comma-separated-values, text/plain", ".csv")),
  
  dataTableOutput("table1")
)

server <- function(input, output, session) {
  
  output$id2 = renderText({
    paste0(input$id1, "how are you doing?")
  })
  
  get_data = reactive({
    infile <- input$file1
    dat = read.csv(infile$datapath)
    return(dat)
    })
    
    output$table1 = renderDataTable({
      req(input$file1)
          
          get_data()
          
          })
  
}

# today ####

#add a plot - using plotly, it creates interactive charts

#all the elements we want to see
ui <- fluidPage(
  textInput("id1","insert text"), 
  textOutput("id2"),
  fileInput("file1", "Choose CSV File", multiple= FALSE, accept = c("text/csv", "text/comma-separated-values, text/plain", ".csv")),
  numericInput("input1", label = "Input X", value = 1),
  numericInput("input2", label = "Input Y", value = 1),
  
  "Plot",
  plotlyOutput("plot1"),
  
  hr(),
  "Head of Data:",
  dataTableOutput("table1")
)

server <- function(input, output, session) {
  
  output$id2 = renderText({
    paste0(input$id1, "how are you doing?")
  })
  
  get_data = reactive({
    infile <- input$file1
    dat = read.csv(infile$datapath)
    return(dat)
  })
  
  output$plot1 = renderPlotly({
    req(input$file1)
    df = get_data()
    
    plot_ly(x = df[,input$input1], y = df[,input$input2])
  
  })
  
  output$table1 = renderDataTable({
    req(input$file1)
    
    get_data()
    
  })
  
}

#create styles - start with the two titles, then add in the styles
#h1 is a header, goes up to 6 - these are called tags
#you can also do the same thing by calling the html text
#you can then access the html file - which is split into head, body etc.
#head controls the font and colours for the page
#you can then use css code within the quotation marks - and make sure you follow the syntax
#you can create fluid rows, with columns in them 

library(shiny)

ui <- fluidPage(
  tags$head(tags$style(HTML("h2{color:green; background-color:black}
                            #header1{color:yellow; transition: .2s}
                            #header1:hover{font-size:5em}"))),
  HTML("<h1>a</h1>"),
  fluidRow(
    column(4, 
           HTML("<h1>Title</h1>"), 
           "hello"), 
    column(4,
           h1(id="header1","a"),
           "hello there")
    ),
  h1("Title"),
  h2("Heading"),
  h3(id="header1", "Sub heading")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

#now we need java script
#shiny is the content
#css is the style
#java allows you to do anything else more complicated, like games or routing on surveys
#with shiny js we can use java script without having to right all the script
install.packages("shinyjs")
library(shinyjs)

ui <- fluidPage(
  tags$head(tags$style(HTML("h2{color:green; background-color:black}
                            #header1{color:yellow; transition: .2s}
                            #header1:hover{font-size:5em}"))),
  HTML("<h1>a</h1>"),
  fluidRow(
    column(4, 
           HTML("<h1>Title</h1>"), 
           "hello"), 
    column(4,
           h1(id="header1","a"),
           "hello there")
  ),
  h1("Title"),
  h2("Heading"),
  h3(id="header1", "Sub heading"),
  useShinyjs()
  )

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

runExample("01_hello")



