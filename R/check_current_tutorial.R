#' Format Tutorial
#'
#' @description
#'
#' An add-in for formatting primer.tutorials.
#'
#' It adjusts the code and hint chunk labels correctly.
#'
#' This should make things easier for tutorial-writers
#' because it will allow fast chunk label updating and quick formatting
#' and checking
#'
#' There is also no need to keep track of the exercise numbers
#' because it is done for you in the add-in.
#'
#'
#' @return formatted document with correct code and hint chunk labels
check_current_tutorial <- function(){

  change_label_function <- function(x, ...){
    opts <- list(...)
    x[["name"]] <- opts[[1]]
    x
  }

  file_path <- rstudioapi::getSourceEditorContext()$path

  rmd <- parsermd::parse_rmd(file_path)

  tbl <- tibble::as_tibble(rmd)

  hint_count <- 0

  exercise_number <- 1

  curr_exercise <- ""

  has_exercise <- FALSE

  for (i in seq_along(tbl$sec_h2)){

    l <- tbl$sec_h2[i]

    e <- tbl$sec_h3[i]


    if (is.na(l) | is.na(e)){
      next
    }

    if (e != curr_exercise && nchar(trimws(e)) != 0){
      curr_exercise <- e

      exercise_number <- readr::parse_number(gsub(pattern = "[^0-9]", replacement = "", trimws(e)) )

      hint_count <- 0

      has_exercise <- FALSE
    }

    if (tbl$type[i] != "rmd_chunk" | is.na(tbl$label[i]) | nchar(trimws(tbl$label[i])) == 0){
      next
    }

    possible_id_removed_prev <- gsub("\\{#(.*)\\}", "", l)

    possible_id_removed <- gsub("[^a-zA-Z ]", "", possible_id_removed_prev)

    lowercase_id <- tolower(trimws(possible_id_removed))

    section_id <- substr(gsub(" ", "-", lowercase_id), 0, 20)

    filt_options <- parsermd::rmd_get_options(tbl$ast[i])[[1]]

    if (length(filt_options) > 0){
      if (names(filt_options) == "eval" && filt_options == "FALSE"){
        hint_count <- hint_count + 1

        new_label <- paste0(section_id, "-", exercise_number, "-hint-", hint_count)

        new_ast <- purrr::map(tbl$ast[i], change_label_function, new_label)

        tbl$ast[i] <- new_ast

        next
      }

      if (names(filt_options) == "child"){
        next
      }
    }

    if (has_exercise){
      next
    }

    new_label <- paste0(section_id, "-", exercise_number)

    new_ast <- purrr::map(tbl$ast[i], change_label_function, new_label)

    tbl$ast[i] <- new_ast

    has_exercise <- TRUE
  }

  new_doc <- ""
  for (i in seq_along(tbl$sec_h2)){
    new_txt <- parsermd::as_document(tbl$ast[i], collapse = "\n")
    if (tbl$type[i] == "rmd_markdown"){
      new_txt <- substr(new_txt, 0, nchar(new_txt)-1)
    }
    new_doc <- paste(new_doc, new_txt, sep = "\n")
  }

  out <- file(file_path, "w")
  write(trimws(new_doc), file = out)
  close(out)

}
