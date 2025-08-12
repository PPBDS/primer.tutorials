#' Convert Names to Tribble Column Labels
#'
#' Converts a character vector of column names into a vector formatted as
#' `~\`name\`` strings for use as column headers in `tibble::tribble()`.
#'
#' @author David Kane, Aashna Patel
#' @param x A character vector of column names.
#' @return A character vector of formatted column labels like `~\`name\``.

make_labels <- function(x) {
  paste0("~`", x, "`")
}
