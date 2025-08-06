# Updated make_p_tables.R

#' Insert a standardized Preceptor or Population Table template
#'
#' This function creates a five-chunk Quarto-ready template for Preceptor and Population Tables.
#' The output is inserted directly into the current document at the cursor.
#'
#' @description Insert editable Quarto-ready templates for Preceptor and Population tables, including example rows, column labels, and spanner headers. The templates differ slightly depending on whether the table is for causal or predictive analysis.
#'
#' @param is_causal Logical. If TRUE, generates a template for causal analysis (includes a Treatment column and Potential Outcomes); if FALSE, generates a predictive template.
#' @param unit_label Character. Label for the Unit spanner (e.g., "Unit", "ID").
#' @param outcome_label Character. Label for the Outcome or Potential Outcomes spanner.
#' @param treatment_label Character. Label for the Treatment spanner (used only if \code{is_causal = TRUE}).
#' @param covariate_label Character vector of Covariate column names (e.g., c("sex", "age")).
#' @param pre_time Character. Default value to populate the "Time/Year" column in the Preceptor Table (e.g., "2020").
#' @export

make_p_tables <- function(
  is_causal = TRUE,
  unit_label,
  outcome_label = if (is_causal) "Potential Outcomes" else "Outcome",
  treatment_label,
  covariate_label,
  pre_time
)
 {

covariate_gt_spanner_cols <- paste0("`", covariate_label, "`", collapse = ", ")


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

covariate_headers <- paste0("~`", covariate_label, "`", collapse = ", ")
covariate_placeholders <- paste(rep('"..."', length(covariate_label)), collapse = ", ")

code_p_tibble <- glue::glue(
  '```{{r}}
# Use "?" for unknowns in Preceptor Table rows, and "---" for unknowns in Population (data) rows.
# Leave the last row and column as-is to signal more rows exist
p_tibble <- tibble::tribble(
  ~`{unit_label}`, ~`Time/Year`, ~`{outcome_label} 1`, ~`{outcome_label} 2`, ~`{treatment_label}`, {covariate_headers}, ~`...`, ~`...`,
  "...", "{pre_time}", "...", "...", "...", {covariate_placeholders}, "...", "...",
  "...", "{pre_time}", "...", "...", "...", {covariate_placeholders}, "...", "...",
  "...", "{pre_time}", "...", "...", "...", {covariate_placeholders}, "...", "...",
  "...", "...", "...", "...", "...", {covariate_placeholders}, "...", "..."
)
```'
)


code_d_tibble <- glue::glue(
  '```{{r}}
# Use "---" to indicate unknown values for data-derived Population Table rows.
# Leave the first, middle, and last rows as well as the last column as-is to signal more rows exist
# Leave the Preceptor Table rows as-is, it will copy over from above
d_tibble <- tibble::tribble(
  ~`Source`, ~`{unit_label}`, ~`Time/Year`, ~`{outcome_label} 1`, ~`{outcome_label} 2`, ~`{treatment_label}`, {covariate_headers}, ~`...`, ~`...`,
  "...", "...", "...", "...", "...", "...", {covariate_placeholders}, "...", "...",
  "Data", "...", "...", "...", "...", "...", {covariate_placeholders}, "...", "...",
  "Data", "...", "...", "...", "...", "...", {covariate_placeholders}, "...", "...",
  "Data", "...", "...", "...", "...", "...", {covariate_placeholders}, "...", "...",
  "Data", "...", "...", "...", "...", "...", {covariate_placeholders}, "...", "...",
  "...", "...", "...", "...", "...", "...", {covariate_placeholders}, "...", "...",
  "Preceptor Table", p_tibble[1, ] |> dplyr::as_tibble() |> dplyr::mutate(Source = "Preceptor Table") |> dplyr::select(Source, dplyr::everything()),
  "Preceptor Table", p_tibble[2, ] |> dplyr::as_tibble() |> dplyr::mutate(Source = "Preceptor Table") |> dplyr::select(Source, dplyr::everything()),
  "Preceptor Table", p_tibble[3, ] |> dplyr::as_tibble() |> dplyr::mutate(Source = "Preceptor Table") |> dplyr::select(Source, dplyr::everything()),
  "Preceptor Table", p_tibble[4, ] |> dplyr::as_tibble() |> dplyr::mutate(Source = "Preceptor Table") |> dplyr::select(Source, dplyr::everything()),
  "...", "...", "...", "...", "...", "...", {covariate_placeholders}, "...", "..."
)
```'
)


code_p_table_causal <- glue::glue(
  '```{{r}}
gt::gt(data = p_tibble) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "{unit_label}", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "{outcome_label}", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "{treatment_label}", columns = c(`{treatment_label}`)) |>
  gt::tab_spanner(label = "{covariate_label}", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::fmt_markdown(columns = gt::everything())
```'
)


code_p_table_predictive <- glue::glue(
  '```{{r}}
gt::gt(data = p_tibble) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "{unit_label}", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "{outcome_label}", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "{covariate_label}", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::fmt_markdown(columns = gt::everything())
```'
)


code_pop_table_causal <- glue::glue(
  '```{{r}}
gt::gt(data = d_tibble) |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "{unit_label}/Time", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "{outcome_label}", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "{treatment_label}", columns = c(`{treatment_label}`)) |>
  gt::tab_spanner(label = "{covariate_label}", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
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
  gt::tab_spanner(label = "{unit_label}/Time", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "{outcome_label}", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "{covariate_label}", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
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
