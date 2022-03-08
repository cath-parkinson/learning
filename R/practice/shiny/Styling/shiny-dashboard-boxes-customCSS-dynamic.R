library(shiny)
library(shinydashboard)
library(htmltools)

setBorderColor <- function(valueBoxTag, color){tagQuery(valueBoxTag)$find("div.small-box")$addAttrs("style" = sprintf("border-style: solid; border-color: %s; height: 106px;", color))$allTags()}

# A dashboard body with a row of valueBoxes
body <- dashboardBody(
  fluidRow(
    tagQuery(valueBox(
      uiOutput("orderNum"), "New Orders", icon = icon("credit-card")
    ))$find("div.small-box")$addAttrs("style" = "border-style: solid; border-color: #FF0000;")$allTags(),
    {vb2 <- valueBox(
      tagList("60", tags$sup(style="font-size: 20px", "%")),
      "Approval Rating", icon = icon("line-chart"), color = "green"
    )
    tagQuery(vb2)$find("div.small-box")$addAttrs("style" = "border-style: solid; border-color: #000000;")$allTags()
    },
    {vb3 <- valueBox(
      htmlOutput("progress"), "Progress", icon = icon("users"), color = "purple"
    )
    setBorderColor(vb3, "#FFFF00")},
    valueBoxOutput("vbox")
  )
  
)

myPalette <- colorRampPalette(c("red", "yellow", "green"))( 100 )

server <- function(input, output) {
  output$orderNum <- renderText({
    x = 789
  })
  
  output$progress <- renderUI({
    tagList(8.90, tags$sup(style="font-size: 20px", "%"))
  })
  
  output$vbox <- renderValueBox({
    invalidateLater(500)
    setBorderColor(valueBox(
      "Title",
      input$count,
      icon = icon("credit-card")
    ), sample(myPalette, 1))
  })
  
}

shinyApp(
  ui = dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    body
  ),
  server = server
)