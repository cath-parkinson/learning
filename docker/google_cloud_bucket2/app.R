# It's important to set the environment variables before we run the application
Sys.setenv("GCS_AUTH_FILE" = file.path(getwd(), "measuremonks-tools-cb5499f780b1.json"))

# Load required libraries
library(shiny)
library(googleCloudStorageR)

# Define UI
ui <- fluidPage(
  h2("Contents:"),
  # Button to Connect to Google Storage Bucket
  actionButton("connect_btn", "Connect"),
  # Output to display contents of Google Storage Bucket
  verbatimTextOutput("gs_output"),
  h2("Download:"),
  # Text box to capture a file name
  textInput("file_name_download", "Enter the name of the file you'd like to download:"),
  # Button to download contents of Google Storage Bucket
  downloadButton("download_btn", "Download"),
  # File upload box
  h3("Upload:"),
  fileInput("file_upload", "Upload file"),
  # Text box to capture a file name
  textInput("file_name_upload", "Give your file a name:"),
  # Button to upload file to Google Storage Bucket
  actionButton("upload_btn", "Upload")
)

# Define Server
server <- function(input, output) {
  
  # Action to take when Connect button is clicked
  observeEvent(input$connect_btn, {
    output$gs_output <- renderPrint({
      gcs_list_objects("re_optimise-486")
    })
  })
  
  # Action to take when Download button is clicked
  output$download_btn <- downloadHandler(
    
    filename = function(){
      
      paste(input$file_name_download)
      
    }
    
    ,
    content <- function(file) {

      # Method 1 - works
      
      # Retrieve the excel file and save it to a temp directory on the disc
      # gcs_get_object(bucket = "re_optimise-486",
      #                object_name = "scenario_0/input_data.xlsx",
      #                saveToDisk = file.path(tempdir(), "input_data.xlsx"),
      #                overwrite = TRUE)
      # 
      # # Copy the file from create temp directory above to the 'file' directory, where it can be downloaded from
      # file.copy(from = file.path(tempdir(), "input_data.xlsx"),
      #           to = file,
      #           overwrite = TRUE,
      #           recursive = FALSE,
      #           copy.mode = TRUE,
      #           copy.date = TRUE)
      
      # Method 2 - more concisely works!
      
      gcs_get_object(bucket = "re_optimise-486",
                     object_name = input$file_name_download,
                     # 'file' is the path to a temp directory, so this will save the 
                     # data to disc here, and then the download handler will grab it from there and pass to the user
                     saveToDisk = file,
                     overwrite = TRUE)
      
      
    }
  )
  
  # Action to take when upload button is pressed
  observeEvent(input$upload_btn, {
    uploaded_file <- input$file_upload # get uploaded file
    if (!is.null(uploaded_file)) {
      gcs_upload(file = uploaded_file$datapath, 
                 bucket = "re_optimise-486", 
                 name = input$file_name_upload)
    }
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)