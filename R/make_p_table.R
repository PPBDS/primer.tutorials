# Updated make_p_table.R
# This version produces five separate code chunks with proper formatting.

#' Insert a standardized Preceptor or Population Table template
#'
#' This function creates a five-chunk Quarto-ready template for Preceptor and Population Tables.
#' The output is inserted directly into the current document at the cursor.
#'
#' @param is_causal Logical. If TRUE, generate template for causal analysis; else predictive.
#' @export

make_p_table <- function(is_causal = TRUE) {

  # Footnotes chunk (same for all)
  code_footnotes <- glue::glue(
    '```{{r}}
# Edit these footnotes after inserting
title_footnote <- "Describe the purpose and what it helps answer."
units_footnote <- "Describe the units and time span."
outcome_footnote <- "Explain why this is predictive or causal, and details about the outcome(s)."
treatment_footnote <- "Describe the treatment and how it appears in the data."
covariates_footnote <- "Describe covariates and how they relate to those in the data."
```'
  )
  
  # Preceptor tibble chunk, sample with placeholders
  code_p_tibble <- glue::glue(
    '```{{r}}
p_tibble <- tibble::tribble(
  ~`...`, ~`...`, ~`...`,
  "...", "...", "..."
)
```'
  )
  
  # Population tibble chunk, sample with placeholders
  code_d_tibble <- glue::glue(
    '```{{r}}
d_tibble <- tibble::tribble(
  ~`Source`, ~`...`, ~`...`,
  "Data", "...", "...",
  "Preceptor Table", "...", "..."
)
```'
  )

  # Preceptor table rendering chunk
  code_p_table <- glue::glue(
    '```{{r}}
gt::gt(data = p_tibble) |>
  gt::tab_header(title = "Preceptor Table") |>
  # Customize your spanners and columns here
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`...`)) |>
  gt::fmt_markdown(columns = gt::everything())
```'
  )
  
  # Conditionally include treatment footnote string
  treatment_footnote_code <- if (is_causal) {
    '  gt::tab_footnote(treatment_footnote, locations = gt::cells_column_spanners(spanners = "Treatment")) |> \n'
  } else {
    ''
  }
  
  # Population table rendering chunk with conditional footnote injected
  code_pop_table <- glue::glue(
    '```{{r}}
gt::gt(data = d_tibble) |>
  gt::tab_header(title = "Population Table") |>
  # Customize your spanners and columns here
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`Source`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(units_footnote, locations = gt::cells_column_spanners(spanners = "Units/Time")) |>
  gt::tab_footnote(outcome_footnote, locations = gt::cells_column_spanners(spanners = "Potential Outcomes")) |>
{treatment_footnote_code}  gt::tab_footnote(covariates_footnote, locations = gt::cells_column_spanners(spanners = "Covariates"))
```'
  )
  
  # Cleanup chunk
  code_cleanup <- glue::glue(
    '```{{r}}
rm(p_tibble, d_tibble)
```'
  )
  
  # Combine all chunks into one string with new lines
  full_code <- paste(
    code_footnotes,
    code_p_tibble,
    code_d_tibble,
    code_p_table,
    code_pop_table,
    code_cleanup,
    sep = "\n\n"
  )
  
  # Insert into the active document (requires RStudio)
  rstudioapi::insertText(
    location = rstudioapi::getActiveDocumentContext()$selection[[1]]$range,
    text = full_code
  )
}
