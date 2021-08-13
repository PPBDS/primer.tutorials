#' Create Ordered Tibble from Submissions
#'
#' @param objs learnr session submissions
#' @param label_list order of code chunks
#' @param tutorial_id id of tutorial
#'
#' @return tibble with ordered answers based on label_list
#' @export

create_tibble_from_submissions <- function(objs, label_list, tutorial_id){

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
    answer = purrr::map_chr(objs, question_or_exercise,
                        .default = NA)
  )

  out <- rbind(out, c(id = "tutorial-id", submission_type = "none", answer = tutorial_id))

  # reorder tibble rows based on label_list.

  out$id <- factor(out$id, levels = label_list)

  dplyr::arrange(out, out$id)

}

