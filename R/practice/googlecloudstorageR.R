# This works exactly fine when I make the service account an "owner"
# And I follow these steps 
# https://bookdown.org/hegghammer/interacting_with_google_storage_in_r/interacting_with_google_storage.html

# And now it works if I set the roles as Storage Admin, Storage Object Admin, Storage Object Creator
Sys.setenv("GCS_AUTH_FILE" = file.path(getwd(), "measuremonks-tools-5d83c9d4859b.json"))

library(googleCloudStorageR)

# tell me all the buckets
gcs_list_buckets("measuremonks-tools")

# tell me about this bucket, and list all the objects in it
gcs_get_bucket("re_optimise-486")
gcs_list_objects("re_optimise-486")

# upload objects to it - note we're using the '/' to create a folder structure in the bucket
gcs_upload(file = file.path(getwd(), "input_data.xlsx"),
           bucket = "re_optimise-486",
           name = "scenario_0/input_data.xlsx")

gcs_upload(file = file.path(getwd(), "config.xlsx"),
           bucket = "re_optimise-486",
           name = "scenario_0/config.xlsx")


# download files
gcs_get_object(object_name = "scenario_0/input_data.xlsx",
               bucket = "re_optimise-486",
               saveToDisk = "input_data_downloaded.xlsx",
               overwrite = TRUE)

