#' Build HTML Submission Report
#'
#' @param file location to render Rmd tibble into HTML
#' @param session session object from shiny with learnr
#'
#' @return a rendered html document with a tibble submission report
#' @export
#'
build_html <- function(file, session){

  # Inspired by Matt Blackwell's implementation of a similar idea.
  # https://github.com/mattblackwell/qsslearnr/blob/main/R/submission.R

  # Get label order to order answers

  label_list <- get_label_list(session)

  # Create function to map objects over that will
  # return different results based on if it is a
  # code or question exercise.

  question_or_exercise <- function(obj, ...){
    options <- list(...)
    if (obj$type[[1]] == "exercise_submission"){
      obj$data$code[[1]]
    }else if (obj$type[[1]] == "question_submission"){
      obj$data$answer[[1]]
    }else{
      options$default
    }
  }

  # Copy over a report Rmd template to write to.

  tempReport <- file.path(tempdir(), "submission-temp.Rmd")
  file.copy(system.file("www/submission-temp.Rmd", package = "primer.tutorials"), tempReport, overwrite = TRUE)

  # Get submissions from learnr

  objs <- get_submissions_from_learnr_session(session)

  # Format objs from learnr into a tibble
  #
  # We are creating a tibble with 3 columns:
  # id, submission_type, answer
  #
  # purrr::map_chr() and purrr::map() iterates over each object
  # in a list, extracting the correct attribute from the objects
  # and returning a list.

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

  out <- dplyr::arrange(out, out$id)

  # Pass tibble and title as parameters into
  # the report template, then render template as
  # an html document.

  params <- list(
    output = out,
    title = paste0(learnr:::read_request(session, "tutorial.tutorial_id"), " submissions")
  )

  rmarkdown::render(tempReport,
                    output_format = "html_document",
                    output_file = file,
                    params = params,
                    envir = new.env(parent = globalenv())
  )


}


#' Get Label Order
#'
#' @param sess session object from shiny with learnr
#'
#' @return list of labels in the correct order
#' @export
#'
#'
get_label_list <- function(sess){

  # In order to keep same question order as in the exercise,
  # use parsermd to define factor level for exercise order
  # and store it in label_list
  #
  # information-name, information-email, download-answers-1
  # are questions that are part of the child documents, which
  # remain constant. Therefore, they are added in manually.

  manual_list <- list("information-name", "information-email", "download-answers-1")

  rmd_path <- file.path(sess$options$appDir, "tutorial.Rmd")

  rmd <- parsermd::parse_rmd(rmd_path)

  rmd_tbl <- parsermd::as_tibble(rmd)

  rmd_chunk_labels <- dplyr::filter(rmd_tbl, rmd_tbl$type == "rmd_chunk")$label

  c(manual_list, rmd_chunk_labels)
}

#' Get Submissions from a learnr Session
#'
#' @param sess session object from shiny with learnr
#'
#' @return exercise submissions of tutorial
#' @export
#'
get_submissions_from_learnr_session <- function(sess){

  # Data Structure of learnr submission object

  # obj$data$answer[[1]] question answer
  # obj$data$code[[1]] "exercise answer"
  # obj$type[[1]] "exercise_submission"
  # obj$id[[1]] "id"

  objs <- learnr:::get_all_state_objects(sess)
  learnr:::submissions_from_state_objects(objs)
}
