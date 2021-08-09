#' Build HTML Submission Report
#'
#' @param file location to render Rmd tibble into HTML
#' @param session session object from shiny with learnr
#' @param is_test check if testing function
#'
#' @return a rendered html document with a tibble submission report
#' @export

build_html <- function(file, session, is_test = FALSE){

  # Inspired by Matt Blackwell's implementation of a similar idea.
  # https://github.com/mattblackwell/qsslearnr/blob/main/R/submission.R

  # Get label order to order answers

  label_list <- get_label_list(session, is_test = is_test)

  # Copy over a report Rmd template to write to.

  tempReport <- file.path(tempdir(), "submission-temp.Rmd")
  file.copy(system.file("www/submission-temp.Rmd", package = "primer.tutorials"), tempReport, overwrite = TRUE)

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

  # Create tibble that is ordered by code chunk appearance

  out <- create_tibble_from_submissions(objs, label_list)

  # Pass tibble and title as parameters into the report template, then render
  # template as an html document.

  params <- list(output = out,
                 title = paste0(learnr:::read_request(session,
                                                      "tutorial.tutorial_id"),
                                " submissions"))

  rmarkdown::render(tempReport,
                    output_format = "html_document",
                    output_file = file,
                    params = params,
                    envir = new.env(parent = globalenv()))


}
