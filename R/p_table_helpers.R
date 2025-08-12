#' Write a tribble template with placeholders for a character vector of column names
#'
#' Generates a character string representing an R tibble::tribble()
#' with the specified column names and 3 rows filled with placeholder
#' text `"..."`. Useful for quickly creating editable table templates.
#'
#' @param names Character vector of column names.
#'
#' @return Character string containing the R code for an input tribble with placeholders `"..."`,
#'   formatted for manual editing.
#'
#' @examples
#' write_input_tribble(c("Unit", "Year", "Outcome", "Treatment"))
#'
#' @export
write_input_tribble <- function(names) {
  n <- length(names)
  # Create 3 rows of placeholders
  rows <- replicate(3, paste(rep('"..."', n), collapse = ", "), simplify = FALSE)
  # Prepare header row with backtick quoted column names
  header <- paste0("~`", names, "`", collapse = ", ")
  
  # Construct tribble text with line breaks for readability
  tribble_text <- paste0(
    "tibble::tribble(\n",
    "  ", header, ",\n  ",
    paste(rows, collapse = ",\n  "),
    "\n)"
  )
  return(tribble_text)
}

#' Expand input tibble(s) by adding a 'More' column and missing rows, then combine if population
#'
#' Processes one or two input tibbles to add missing rows (to at least 3 rows),
#' a final "More" column with "..." in the last row, and combines them if type is 'population'.
#'
#' @param x List of tibble(s). For type "preceptor", a list of length 1.
#'   For type "population", a list of length 2.
#' @param type Character string. Either "preceptor" or "population".
#' @param source Logical, whether the population table includes a 'Source' column. Default FALSE.
#'
#' @return A single tibble with added missing rows and 'More' column, suitable for piping to gt.
#'
#' @details
#' For "preceptor": adds missing rows to ensure at least 3 rows, adds a "More" column
#' with NA except last row contains "...".
#'
#' For "population": expands each tibble similarly, then combines them with
#' empty rows before, between, and after, then adds "More" column.
#'
#' @examples
#' # Preceptor example
#' pre_tib <- tibble::tribble(~Unit, ~Year, ~Outcome,
#'                            "A", "2020", "5",
#'                            "B", "2021", "6")
#' expand_input_tibble(list(pre_tib), "preceptor")
#'
#' # Population example
#' pop1 <- tibble::tribble(~Source, ~Unit, ~Year,
#'                        "S1", "A", "2020",
#'                        "S2", "B", "2021")
#' pop2 <- tibble::tribble(~Source, ~Unit, ~Year,
#'                        "S1", "C", "2022",
#'                        "S2", "D", "2023")
#' expand_input_tibble(list(pop1, pop2), "population", source = TRUE)
#'
#' @export
expand_input_tibble <- function(x, type, source = FALSE) {
  stopifnot(type %in% c("preceptor", "population"))
  
  if (type == "preceptor") {
    if (length(x) != 1) stop("For 'preceptor', x must be a list of length 1.")
    tib <- x[[1]]
    
    # Add missing rows to reach at least 3 rows
    n_missing <- max(0, 3 - nrow(tib))
    if (n_missing > 0) {
      missing_rows <- tib[rep(nrow(tib), n_missing), , drop = FALSE]
      missing_rows[,] <- NA_character_
      tib <- dplyr::bind_rows(tib, missing_rows)
    }
    
    # Add 'More' column: NA except last row is "..."
    tib$More <- rep(NA_character_, nrow(tib))
    tib$More[nrow(tib)] <- "..."
    
    return(tib)
    
  } else if (type == "population") {
    if (length(x) != 2) stop("For 'population', x must be a list of length 2.")
    
    expand_one <- function(tib) {
      n_missing <- max(0, 3 - nrow(tib))
      if (n_missing > 0) {
        missing_rows <- tib[rep(nrow(tib), n_missing), , drop = FALSE]
        missing_rows[,] <- NA_character_
        tib <- dplyr::bind_rows(tib, missing_rows)
      }
      tib
    }
    
    tib1 <- expand_one(x[[1]])
    tib2 <- expand_one(x[[2]])
    
    # Create empty row with same columns filled NA
    empty_row <- tib1[1, , drop = FALSE]
    empty_row[,] <- NA_character_
    
    # Combine with empty rows before, between, and after
    combined <- dplyr::bind_rows(
      empty_row,
      tib1,
      empty_row,
      tib2,
      empty_row
    )
    
    # Add 'More' column with NA except last row is "..."
    combined$More <- rep(NA_character_, nrow(combined))
    combined$More[nrow(combined)] <- "..."
    
    return(combined)
  }
}
