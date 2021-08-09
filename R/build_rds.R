#' Build RDS Submission Object
#'
#' @param file location to save RDS file
#' @param session session object from shiny with learnr
#' @param is_test check if testing function
#'
#' @return location of the rds file
#' @export

build_rds <- function(file, session, is_test = FALSE){

  # Get submissions from learnr

  # Data Structure of a learnr submission object

  # obj$data$answer[[1]] question answer
  # obj$data$code[[1]] "exercise answer"
  # obj$type[[1]] "exercise_submission"
  # obj$id[[1]] "id"

  if(is_test){
    objs <- readRDS("test-data/submission_test_outputs/learnr_submissions_output.rds")
  }
  else{
    objs <- get_submissions_from_learnr_session(session)
  }

  # Get label order to order answers

  label_list <- get_label_list(session, is_test = is_test)

  # Create tibble that is ordered by code chunk appearance

  out <- create_tibble_from_submissions(objs, label_list)

  # save tibble object in destination

  saveRDS(out, file)

  file
}
