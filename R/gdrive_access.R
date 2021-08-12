#
# gdrive_access <- function(tutorial_id, year, month, day, temp_path, ...){
#   options <- list(...)
#   new_dir <- paste0("submission_folder/",
#                     tutorial_id,
#                     "-",
#                     year,
#                     "-",
#                     month,
#                     "-",
#                     day)
#   googledrive::drive_mkdir(new_dir)
#
#   rds_paths <- Sys.glob(file.path(temp_path, "*.rds"))
#
#   for (i in seq_along(rds_paths)){
#     googledrive::drive_upload(
#       rds_paths[[i]],
#       path = new_dir,
#       name = paste0("submission_", i, ".rds")
#     )
#   }
#
#   googledrive::drive_upload(
#     file.path(temp_path, "submission_aggregation.csv"),
#     path = new_dir,
#     name = "submission_aggregation.csv",
#     type = "spreadsheet"
#   )
#
#
# }


