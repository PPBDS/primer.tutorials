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


#' Get Label Order
#'
#' @param sess session object from shiny with learnr
#' @param is_test check if testing function
#'
#' @return list of labels in the correct order
#' @export

get_label_list <- function(sess, is_test = FALSE){

  # In order to keep same question order as in the exercise, use parsermd to
  # define factor level for exercise order and store it in label_list

  # information-name, information-email, download-answers-1 are questions that
  # are part of the child documents, which remain constant. Therefore, they are
  # added in manually.

  manual_list <- list("information-name", "information-email", "download-answers-1")

  rmd_path <- ifelse(is_test, "test-data/session_check_tutorial.Rmd",
                     file.path(sess$options$appDir, "tutorial.Rmd"))

  rmd <- parsermd::parse_rmd(rmd_path)

  rmd_tbl <- parsermd::as_tibble(rmd)

  rmd_chunk_labels <- dplyr::filter(rmd_tbl, rmd_tbl$type == "rmd_chunk")$label

  ls <- c(manual_list, rmd_chunk_labels)

  ls[ls != ""]
}

#' Get Submissions from a learnr Session
#'
#' @param sess session object from shiny with learnr
#'
#' @return exercise submissions of tutorial
#' @export

get_submissions_from_learnr_session <- function(sess){

  # This is an annoying link of the entire chain of building the submission
  # report because it has to communicate with the learnr session ENVIRONMENT,
  # not just the object.

  # Since we are using the session environment, we currently don't have a way to
  # save the environment and hence can't test this function.

  # So learnr:::get_all_state_objects() finds and returns ALL state objects
  # relating to the session environment and tutorial. This includes the tutorial
  # id, version, submissions, everything that defines the current "state".

  # learnr:::submissions_from_state_objects() then filters the results to only
  # submission-related state objects, which are the student answers.

  objs <- learnr:::get_all_state_objects(sess)
  learnr:::submissions_from_state_objects(objs)
}


#' Create Ordered Tibble from Submissions
#'
#' @param objs learnr session submissions
#' @param label_list order of code chunks
#'
#' @return tibble with ordered answers based on label_list
#' @export

create_tibble_from_submissions <- function(objs, label_list){

  # Create function to map objects over that will
  # return different results based on if it is a
  # code or question exercise.

  question_or_exercise <- function(obj, ...){
    options <- list(...)
    if(obj$type[[1]] == "exercise_submission"){
      obj$data$code[[1]]
    }
    else if(obj$type[[1]] == "question_submission"){
      obj$data$answer[[1]]
    }
    else{
      options$default
    }
  }

  # Format objs from learnr into a tibble
  #
  # We are creating a tibble with 3 columns: id, submission_type, answer
  #
  # purrr::map_chr() and purrr::map() iterates over each object in a list,
  # extracting the correct attribute from the objects and returning a list.

  out <- tibble::tibble(
    id = purrr::map_chr(objs, "id",
                        .default = NA),
    submission_type = purrr::map_chr(objs, "type",
                                     .default = NA),
    answer = purrr::map(objs, question_or_exercise,
                        .default = NA)
  )

  # reorder tibble rows based on label_list.

  out$id <- factor(out$id, levels = label_list)

  dplyr::arrange(out, out$id)

}

