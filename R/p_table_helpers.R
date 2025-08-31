#' Write a tribble template with placeholders for a character vector of column names
#'
#' Generates a character string representing an R tibble::tribble()
#' with the specified column names and 3 rows filled with placeholder
#' text `"..."`. Column values are aligned under their headers for easy editing.
#'
#' @param names Character vector of column names.
#'
#' @return Character string containing the R code for an input tribble with placeholders `"..."`,
#'   formatted for manual editing with aligned columns.
#'
#' @examples
#' write_input_tribble(c("Unit", "Year", "Outcome", "Treatment"))
#'
#' @export
write_input_tribble <- function(names) {
  n <- length(names)
  
  # Calculate column widths based on header names (with backticks and ~)
  header_widths <- nchar(paste0("~`", names, "`"))
  # Ensure minimum width of 5 for "..." placeholder
  col_widths <- pmax(header_widths, 5)
  
  # Create properly spaced header row
  headers_spaced <- character(n)
  for (i in 1:n) {
    header_text <- paste0("~`", names[i], "`")
    padding <- col_widths[i] - nchar(header_text)
    headers_spaced[i] <- paste0(header_text, paste(rep(" ", padding), collapse = ""))
  }
  header <- paste(headers_spaced, collapse = ", ")
  
  # Create properly spaced data rows
  placeholder_rows <- character(3)
  for (row in 1:3) {
    row_values <- character(n)
    for (i in 1:n) {
      value_text <- '"..."'
      padding <- col_widths[i] - nchar(value_text)
      row_values[i] <- paste0(value_text, paste(rep(" ", padding), collapse = ""))
    }
    placeholder_rows[row] <- paste(row_values, collapse = ", ")
  }
  
  # Construct tribble text with aligned columns
  tribble_text <- paste0(
    "tibble::tribble(\n",
    "  ", header, ",\n  ",
    paste(placeholder_rows, collapse = ",\n  "),
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
    
    if (nrow(tib) >= 3) {
      new_row <- tib[1, , drop = FALSE]
      new_row[,] <- "..."
      
      tib_expanded <- dplyr::bind_rows(
        tib[1:(nrow(tib)-1), ],
        new_row,
        tib[nrow(tib), ]
      )
    } else {
      tib_expanded <- tib
    }
    
    tib_expanded$More <- "..."
    
    return(tib_expanded)
    
  } else if (type == "population") {
    if (length(x) != 2) stop("For 'population', x must be a list of length 2.")
    
    data_tibble <- x[[1]]    # Should be 2 rows from d_tibble
    preceptor_tibble <- x[[2]] # Should be 4 rows from p_tibble_full (without More column)
    
    # Create empty row template
    empty_row <- data_tibble[1, , drop = FALSE]
    empty_row[,] <- "..."
    
    # Build the 11-row structure:
    # Row 1: blank (all "...")
    # Rows 2-3: data rows (2 rows)
    # Row 4: blank ("..." in all columns)
    # Rows 5-8: preceptor rows (4 rows, already has "..." in 3rd position)
    # Row 9: blank (all "...")
    
    # For data section: 2 data rows + 1 blank + 1 more blank = 4 rows total
    data_section <- dplyr::bind_rows(
      data_tibble[1, ],  # First data row
      data_tibble[2, ],  # Second data row  
      empty_row,         # Blank row
      data_tibble[3, ]   # Third data row
    )
    
    # Preceptor section is already 4 rows from p_tibble_full
    preceptor_section <- preceptor_tibble
    
    # Combine: blank + data(4) + blank + preceptor(4) + blank = 11 rows
    combined <- dplyr::bind_rows(
      empty_row,          # Row 1: blank
      data_section,       # Rows 2-5: data section (2 data + 2 blank)
      empty_row,          # Row 6: blank  
      preceptor_section,  # Rows 7-10: preceptor section (4 rows)
      empty_row           # Row 11: blank
    )
    
    # Add More column
    combined$More <- "..."
    
    return(combined)
  }
}
