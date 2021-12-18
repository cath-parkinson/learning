library(shiny)
  
    ui <- fluidPage(
      
      tags$head(
      tags$style(HTML("
      li{ 
      list-style-type: square;
      }
                      "))
      ),
    titlePanel("My Shiny App"),
    sidebarLayout(
      
      sidebarPanel(
        h1("Installation"), 
        p("Shiny is available on CRAN, so you can install it in the usual way from your R console:"),
        code("install.packages(shiny)"),
        width = 4, br(), br(), 
        img(src = "rstudio.png", height = 72, width = 100),
        p("Shiny is a product of ", a("RStudio", href = "https://rstudio.com/"))
      ),
      
      mainPanel(
        h1("Introducing Shiny"),
        p("Shiny is a new package from RStudio that makes it",
          em("incredibly easy"),
          "to build interactive web applications in R"
      ), br(), br(), br(), 
      h2("Features"), 
      tags$li("Build useful web applications with only a few lines of code-no Javascript required."),
      tags$li("Shiny applications are automatically 'live' in the same way that" , strong("spreadsheets"), 
              "are live. Outputs change instantly as users modify inputs, without requiring a reload of the browser.")
    )
  )
    )
  
  server <- function(input,output){}
  
  shinyApp(ui, server)