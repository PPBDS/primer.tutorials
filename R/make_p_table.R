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

  # --- Define 5 separate glue code chunks ---

  if (is_causal) {
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
  } else {
    code_footnotes <- glue::glue(
      '```{{r}}
# Edit these footnotes after inserting
title_footnote <- "Describe the purpose and what it helps answer."
units_footnote <- "Describe the units and time span."
outcome_footnote <- "Explain the outcome(s)."
covariates_footnote <- "Describe covariates and how they relate to those in the data."
```'
    )
  }

  code_p_tibble <- glue::glue(
    '```{{r}}
p_tibble <- tibble::tribble(
  ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`,
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "..."
)
```'
  )

  code_d_tibble <- glue::glue(
    '```{{r}}
d_tibble <- tibble::tribble( 
  ~`Source`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`,
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "Data", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "Data", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "Preceptor Table", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "Preceptor Table", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "..."
)
```'
  )

  code_p_table <- glue::glue(
    '```{{r}}
# Render Preceptor Table
gt::gt(data = p_tibble) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "Potential Outcomes", columns = c(`...`, `...`)) |>
  gt::tab_spanner(label = "Treatment", columns = c(`...`)) |>
  gt::tab_spanner(label = "Covariates", columns = c(`...`, `...`, `...`, `...`, `...`, `...`)) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`...`)) |>
  gt::fmt_markdown(columns = gt::everything()
  )
```'
  )

  code_pop_table <- glue::glue(
    '```{{r}}
# Render Population Table
gt::gt(data = d_tibble) |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "Units/Time", columns = c(`...`, `...`)) |>
  gt::tab_spanner(label = "Potential Outcomes", columns = c(`...`, `...`)) |>
  gt::tab_spanner(label = "Treatment", columns = c(`...`)) |>
  gt::tab_spanner(label = "Covariates", columns = c(`...`, `...`, `...`, `...`, `...`, `...`)) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`Source`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(units_footnote, locations = gt::cells_column_spanners(spanners = "Units/Time")) |>
  gt::tab_footnote(outcome_footnote, locations = gt::cells_column_spanners(spanners = "Potential Outcomes")) |>
  {if (is_causal)
    "gt::tab_footnote(treatment_footnote, locations = gt::cells_column_spanners(spanners = \"Treatment\")) |>\n" else ""}gt::tab_footnote(covariates_footnote, locations = gt::cells_column_spanners(spanners = "Covariates"))
```'
  )

  code_cleanup <- glue::glue(
    '```{{r}}
# Cleanup temporary variables
rm(p_tibble, d_tibble)
```'
  )

  # Combine and insert
  full_code <- paste(
    code_footnotes,
    code_p_tibble,
    code_d_tibble,
    code_p_table,
    code_pop_table,
    code_cleanup,
    sep = "\n\n"
  )

  rstudioapi::insertText(
    location = rstudioapi::getActiveDocumentContext()$selection[[1]]$range,
    text = full_code
  )
}
