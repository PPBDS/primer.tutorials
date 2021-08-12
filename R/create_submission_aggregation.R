#
create_submission_aggregation <- function(paths, tutorial_id){

  submission_info <- tibble::tibble()

  for (p in paths){
    tbl <- readRDS(p)

    if (tutorial_id != tbl$answer[[1]]){
      next
    }

    name <- tbl$answer[[2]]

    email <- tbl$answer[[3]]

    time <- gsub("[^0-9]", "", tbl$answer[[4]])

    time_raw <- tbl$answer[[4]]

    answer_questions <- dplyr::count(tbl)[[1]]



  }
}
