
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

  skip <- 0

  remaining_paths <- list()

  for (p in paths){

    new_submission_row <- tryCatch({
      tbl <- readRDS(p)

      counter <- counter + 1

      if (tutorial_id != tbl$answer[[1]]){
        next
      }

      name <- tbl$answer[[2]]

      email <- tbl$answer[[3]]

      time <- gsub("[^0-9]", "", tbl$answer[[4]])

      time_raw <- tbl$answer[[4]]

      answer_questions <- dplyr::count(tbl)[[1]]

      fn <- paste0("submission_", counter, ".rds")

      c(student_name = name,
        student_email = email,
        time_spent = time,
        time_spent_raw = time_raw,
        questions_answered = answer_questions,
        filename = fn,
        curr_path = p)


    },
    error = function (cond){
      # message("Error While Processing:")
      # message(p)
      # message(paste0("Returned with:\n",cond))
    })

    if (is.null(new_submission_row)){
      skip <- skip + 1
      next
    }

    submission_info <- rbind(submission_info, new_submission_row)

  }

  colnames(submission_info) <- c("student_name", "student_email",
                                 "time_spent", "time_spent_raw",
                                 "questions_answered",
                                 "filename", "curr_path")

  utils::write.table(dplyr::select(submission_info, -"curr_path"),
              file = file.path(tempdir(), "submission_aggregation.csv"),
              sep = ",",
              row.names=FALSE)

  message(paste0("skipped aggregation of ", skip, " submissions due to errors"))

  submission_info
}
