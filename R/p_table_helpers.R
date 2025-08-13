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
#' For "preceptor": adds a third row between the last 2 rows filled with "...", 
#' adds a "More" column with "..." in all positions.
#'
#' For "population": expands each tibble similarly, then combines them with
#' empty rows before, between, and after, then adds "More" column with "...".
#'
#' @examples
#' # Preceptor example
#' pre_tib <- tibble::tribble(~Unit, ~Year, ~Outcome,
#'                            "A", "2020", "5",
#'                            "B", "2021", "6",
#'                            "C", "2022", "7")
#' expand_input_tibble(list(pre_tib), "preceptor")
#'
#' # Population example
#' pop1 <- tibble::tribble(~Source, ~Unit, ~Year,
#'                        "S1", "A", "2020",
#'                        "S2", "B", "2021",
#'                        "S3", "C", "2022")
#' pop2 <- tibble::tribble(~Source, ~Unit, ~Year,
#'                        "S1", "D", "2023",
#'                        "S2", "E", "2024", 
#'                        "S3", "F", "2025")
#' expand_input_tibble(list(pop1, pop2), "population", source = TRUE)
#'
#' @export
expand_input_tibble <- function(x, type, source = FALSE) {
  stopifnot(type %in% c("preceptor", "population"))
  
  if (type == "preceptor") {
    if (length(x) != 1) stop("For 'preceptor', x must be a list of length 1.")
    tib <- x[[1]]
    
    # For a 3-row tibble, insert a new row between row 2 and row 3 (the last row)
    # This new row should be filled with "..."
    if (nrow(tib) >= 3) {
      # Create a new row filled with "..."
      new_row <- tib[1, , drop = FALSE]  # Use first row as template
      new_row[,] <- "..."  # Fill all columns with "..."
      
      # Insert the new row between the second-to-last and last row
      # For a 3-row table, this means between row 2 and row 3
      tib_expanded <- dplyr::bind_rows(
        tib[1:(nrow(tib)-1), ],  # All rows except the last
        new_row,                 # New row with "..."
        tib[nrow(tib), ]         # The last row
      )
    } else {
      # If somehow less than 3 rows, just keep as is
      tib_expanded <- tib
    }
    
    # Add 'More' column filled with "..."
    tib_expanded$More <- "..."
    
    return(tib_expanded)
    
  } else if (type == "population") {
    if (length(x) != 2) stop("For 'population', x must be a list of length 2.")
    
    # Function to expand a single tibble (data or preceptor)
    expand_one <- function(tib) {
      # Insert a row between second-to-last and last row filled with "..."
      if (nrow(tib) >= 3) {
        new_row <- tib[1, , drop = FALSE]
        new_row[,] <- "..."
        
        expanded <- dplyr::bind_rows(
          tib[1:(nrow(tib)-1), ],
          new_row,
          tib[nrow(tib), ]
        )
      } else {
        expanded <- tib
      }
      return(expanded)
    }
    
    tib1 <- expand_one(x[[1]])  # Data tibble
    tib2 <- expand_one(x[[2]])  # Preceptor tibble
    
    # Create empty row with same columns filled with NA
    empty_row <- tib1[1, , drop = FALSE]
    empty_row[,] <- NA_character_
    
    # Combine with empty rows: blank, data, blank, preceptor, blank
    combined <- dplyr::bind_rows(
      empty_row,    # blank row
      tib1,         # data rows (expanded)
      empty_row,    # blank row  
      tib2,         # preceptor rows (expanded)
      empty_row     # blank row
    )
    
    # Add 'More' column filled with "..."
    combined$More <- "..."
    
    return(combined)
  }
}
