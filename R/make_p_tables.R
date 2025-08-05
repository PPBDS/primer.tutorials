# Updated make_p_tables.R
# This version produces five separate code chunks with proper formatting.

#' Insert a standardized Preceptor or Population Table template
#'
#' This function creates a five-chunk Quarto-ready template for Preceptor and Population Tables.
#' The output is inserted directly into the current document at the cursor.
#'
#' @description blahblahblah
#' 
#' @param is_causal Logical. If TRUE, generates template for causal analysis; else predictive.
#' @param unit_label Label (character) for the Unit/Time spanner
#' @param outcome_label Label (character) for the Outcome or Potential Outcomes spanner
#' @param treatment_label Label (character) for the Treatment spanner (only used if is_causal = TRUE)
#' @param covariate_label Label (character) for the Covariates spanner
#' @export

make_p_tables <- function(
  is_causal = TRUE,
  unit_label = "Unit",
  outcome_label = if (is_causal) "Potential Outcomes" else "Outcome",
  treatment_label = "Treatment",
  covariate_label = "Covariates"
) {

  code_footnotes <- glue::glue(
    '```{{r}}
# Edit the following PRECEPTOR/POPULATION footnotes (look at the help page for more details):
pre_title_footnote <- "..."
pre_units_footnote <- "..."
pre_outcome_footnote <- "..."
pre_treatment_footnote <- "..."
pre_covariates_footnote <- "..."

pop_title_footnote <- "..."
pop_units_footnote <- "..."
pop_outcome_footnote <- "..."
pop_treatment_footnote <- "..."
pop_covariates_footnote <- "..."
```'
  )

# Preceptor tibble (no "Source" column)
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

# Population tibble (has "Source" column)
code_d_tibble <- glue::glue(
  '```{{r}}
d_tibble <- tibble::tribble(
  ~`Source`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`, ~`...`,
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "..."
)
```'
)

  code_p_table <- glue::glue(
    '```{{r}}
gt::gt(data = p_tibble) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "...", columns = c(`...`, `...`)) |>
  gt::tab_spanner(label = "...", columns = c(`...`)) |>
  gt::tab_spanner(label = "...", columns = c(`...`, `...`, `...`, `...`, `...`, `...`)) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`...`)) |>
  gt::fmt_markdown(columns = gt::everything())
```'
  )

  treatment_footnote_code <- if (is_causal) {
    '  gt::tab_footnote(treatment_footnote, locations = gt::cells_column_spanners(spanners = "...")) |> \n'
  } else {
    ''
  }

  code_pop_table <- glue::glue(
    '```{{r}}
gt::gt(data = d_tibble) |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "...", columns = c(`...`, `...`)) |>
  gt::tab_spanner(label = "...", columns = c(`...`, `...`)) |>
  gt::tab_spanner(label = "...", columns = c(`...`)) |>
  gt::tab_spanner(label = "...", columns = c(`...`, `...`, `...`, `...`, `...`, `...`)) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`...`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(units_footnote, locations = gt::cells_column_spanners(spanners = "...")) |>
  gt::tab_footnote(outcome_footnote, locations = gt::cells_column_spanners(spanners = "...")) |>
{treatment_footnote_code}  gt::tab_footnote(covariates_footnote, locations = gt::cells_column_spanners(spanners = "..."))
```'
  )

  code_cleanup <- glue::glue(
    '```{{r}}
rm(p_tibble, d_tibble)
```'
  )

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
