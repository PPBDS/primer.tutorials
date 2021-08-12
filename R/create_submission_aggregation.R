
#' Create Submission Aggregation
#'
#' @param paths local paths to saved rds files
#' @param tutorial_id id of tutorial to save and process
#' @param new_dir new gdrive folder created in gdrive_access.R
#'
#' @return tibble with submission information
#' @export
#'
create_submission_aggregation <- function(paths, tutorial_id, new_dir){

  submission_info <- tibble::tibble()

  counter <- 0

  for (p in paths){

    counter <- counter + 1

    tbl <- readRDS(p)

    if (tutorial_id != tbl$answer[[1]]){
      next
    }

    name <- tbl$answer[[2]]

    email <- tbl$answer[[3]]

    time <- gsub("[^0-9]", "", tbl$answer[[4]])

    time_raw <- tbl$answer[[4]]

    answer_questions <- dplyr::count(tbl)[[1]]

    fn <- paste0("submission_", counter, ".rds")

    submission_info <- rbind(submission_info,
                             c(student_name = name,
                               student_email = email,
                               time_spent = time,
                               time_spent_raw = time_raw,
                               questions_answered = answer_questions,
                               filename = fn))

  }

  colnames(submission_info) <- c("student_name", "student_email",
                                 "time_spent", "time_spent_raw",
                                 "questions_answered",
                                 "filename")

  write.table(submission_info,
              file = file.path(tempdir(), "submission_aggregation.csv"),
              sep = ",",
              row.names=FALSE)

  submission_info
}
