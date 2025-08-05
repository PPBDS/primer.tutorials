# Updated make_p_tables.R

#' Insert a standardized Preceptor or Population Table template
#'
#' This function creates a five-chunk Quarto-ready template for Preceptor and Population Tables.
#' The output is inserted directly into the current document at the cursor.
#'
#' @description Insert editable templates for Preceptor and Population tables.
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
  covariate_label = "Covariates",
  pre_time = "2020"
)
 {

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

code_p_tibble <- glue::glue(
  '```{{r}}
# Use "?" for unknowns in Preceptor Table rows, and "---" for unknowns in Population (data) rows.
# Leave the last row and column as-is to signal more rows exist
p_tibble <- tibble::tribble(
  ~`{unit_label}`, ~`Time/Year`, ~`{outcome_label} 1`, ~`{outcome_label} 2`, ~`{treatment_label}`, ~`{covariate_label}`, ~`...`, ~`...`, ~`...`, ~`...`,
  "...", "{pre_time}", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "{pre_time}", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "{pre_time}", "...", "...", "...", "...", "...", "...", "...", "..."
)
```'
)

code_d_tibble <- glue::glue(
  '```{{r}}
# Use "---" to indicate unknown values for data-derived Population Table rows.
# Leave the first, middle, and last rows as well as the last column as-is to signal more rows exist
# Leave the Preceptor Table rows as-is, it will copy over from above
d_tibble <- tibble::tribble(
  ~`Source`, ~`{unit_label}`, ~`Time/Year`, ~`{outcome_label} 1`, ~`{outcome_label} 2`, ~`{treatment_label}`, ~`{covariate_label}`, ~`...`, ~`...`, ~`...`, ~`...`,
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "Data", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "Data", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "Data", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "Preceptor Table", p_tibble[1, ] |> dplyr::as_tibble() |> dplyr::mutate(Source = "Preceptor Table") |> dplyr::select(Source, dplyr::everything()),
  "Preceptor Table", p_tibble[2, ] |> dplyr::as_tibble() |> dplyr::mutate(Source = "Preceptor Table") |> dplyr::select(Source, dplyr::everything()),
  "Preceptor Table", p_tibble[3, ] |> dplyr::as_tibble() |> dplyr::mutate(Source = "Preceptor Table") |> dplyr::select(Source, dplyr::everything()),
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "..."
)
```'
)

  code_p_table_causal <- glue::glue(
    '```{{r}}
gt::gt(data = p_tibble) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "{unit_label}", columns = c(`...`, `...`)) |>
  gt::tab_spanner(label = "{outcome_label}", columns = c(`...`)) |>
  gt::tab_spanner(label = "{treatment_label}", columns = c(`...`)) |>
  gt::tab_spanner(label = "{covariate_label}", columns = c(`...`, `...`, `...`, `...`, `...`, `...`)) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`...`)) |>
  gt::fmt_markdown(columns = gt::everything())
```'
  )

  code_p_table_predictive <- glue::glue(
    '```{{r}}
gt::gt(data = p_tibble) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "{unit_label}", columns = c(`...`, `...`)) |>
  gt::tab_spanner(label = "{outcome_label}", columns = c(`...`)) |>
  gt::tab_spanner(label = "{covariate_label}", columns = c(`...`, `...`, `...`, `...`, `...`, `...`)) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`...`)) |>
  gt::fmt_markdown(columns = gt::everything())
```'
  )

  code_pop_table_causal <- glue::glue(
    '```{{r}}
gt::gt(data = d_tibble) |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "{unit_label}/Time", columns = c(`...`, `...`)) |>
  gt::tab_spanner(label = "{outcome_label}", columns = c(`...`)) |>
  gt::tab_spanner(label = "{treatment_label}", columns = c(`...`)) |>
  gt::tab_spanner(label = "{covariate_label}", columns = c(`...`, `...`, `...`, `...`, `...`, `...`)) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`...`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(pop_title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(pop_units_footnote, locations = gt::cells_column_spanners(spanners = "{unit_label}/Time")) |>
  gt::tab_footnote(pop_outcome_footnote, locations = gt::cells_column_spanners(spanners = "{outcome_label}")) |>
  gt::tab_footnote(pop_treatment_footnote, locations = gt::cells_column_spanners(spanners = "{treatment_label}")) |>
  gt::tab_footnote(pop_covariates_footnote, locations = gt::cells_column_spanners(spanners = "{covariate_label}"))
```'
  )

  code_pop_table_predictive <- glue::glue(
    '```{{r}}
gt::gt(data = d_tibble) |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "{unit_label}/Time", columns = c(`...`, `...`)) |>
  gt::tab_spanner(label = "{outcome_label}", columns = c(`...`)) |>
  gt::tab_spanner(label = "{covariate_label}", columns = c(`...`, `...`, `...`, `...`, `...`, `...`)) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`...`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(pop_title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(pop_units_footnote, locations = gt::cells_column_spanners(spanners = "{unit_label}/Time")) |>
  gt::tab_footnote(pop_outcome_footnote, locations = gt::cells_column_spanners(spanners = "{outcome_label}")) |>
  gt::tab_footnote(pop_covariates_footnote, locations = gt::cells_column_spanners(spanners = "{covariate_label}"))
```'
  )

  code_p_table <- if (is_causal) code_p_table_causal else code_p_table_predictive
  code_pop_table <- if (is_causal) code_pop_table_causal else code_pop_table_predictive

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
