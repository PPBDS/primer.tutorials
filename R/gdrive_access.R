
#' Google Drive Submission Processing
#'
#' @param tutorial_id id of tutorial to save and process
#' @param year year from parsed_date
#' @param month month from parsed_date
#' @param day day from parsed_date
#' @param temp_path path of tempdir()
#' @param rds_paths paths of saved rds files from gmail
#'
#' @return success status
#' @export
#'
gdrive_access <- function(tutorial_id, year, month, day, temp_path, rds_paths){

  googledrive::drive_auth()

  new_dir <- file.path("submission_folder",
                       paste0(tutorial_id,
                              "-",
                              year,
                              "-",
                              month,
                              "-",
                              day))
  googledrive::drive_mkdir(new_dir)

  submission_info <- create_submission_aggregation(rds_paths, tutorial_id, new_dir)

  for (i in seq_along(submission_info[[1]])){
    googledrive::drive_upload(
      rds_paths[[i]],
      path = new_dir,
      name = basename(submission_info$file_path[[i]])
    )
  }

  googledrive::drive_upload(
    file.path(temp_path, "submission_aggregation.csv"),
    path = new_dir,
    name = "submission_aggregation.csv",
    type = "spreadsheet"
  )


}


