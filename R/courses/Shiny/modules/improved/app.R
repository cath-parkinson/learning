
source("histogram.R")

ui <- fluidPage(
  histogramUI("hist1")
)
server <- function(input, output, session) {
  histogramServer("hist1")
}
shinyApp(ui, server)  