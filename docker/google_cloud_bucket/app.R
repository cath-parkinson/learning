# It's important to set the environment variables before we run the application
Sys.setenv("GCS_AUTH_FILE" = file.path(getwd(), "measuremonks-tools-5d83c9d4859b.json"))

# Load required libraries
library(shiny)
library(googleCloudStorageR)

# Define UI
ui <- fluidPage(
  # Button to Connect to Google Storage Bucket
  actionButton("connect_btn", "Connect"),
  # Output to display contents of Google Storage Bucket
  verbatimTextOutput("gs_output")
)

# Define Server
server <- function(input, output) {
  
  # Action to take when Connect button is clicked
  observeEvent(input$connect_btn, {
    output$gs_output <- renderPrint({
      gcs_list_objects("re_optimise-486")
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)