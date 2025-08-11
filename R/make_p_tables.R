#' Insert Preceptor and Population Table Templates in Quarto
#'
#' Inserts a Quarto-ready template consisting of five code chunks for creating **Preceptor Tables** and **Population Tables**. These tables support both causal and predictive workflows.
#'
#' The output includes:
#' - An empty `tibble` for the Preceptor Table
#' - An empty `tibble` for the Population Table (includes Preceptor rows)
#' - `gt` code to render each table with labeled spanners
#' - Editable footnotes for documentation
#' - Cleanup code to remove temporary objects
#'
#' @param is_causal Logical. If `TRUE`, includes treatment and potential outcomes; if `FALSE`, includes a single outcome and no treatment.
#' @param unit_label Character. Label for the unit.
#' @param outcome_label Character. Label for the outcome or potential outcomes
#' @param treatment_label Character. Label for the treatment (required if `is_causal = TRUE`).
#' @param covariate_1_label Character. First covariate label.
#' @param covariate_2_label Character. Second covariate label.
#'
#' @note
#' All cell entries must be wrapped in double quotes, including numbers (e.g., `"42"`).
#'
#' Required packages:
#' This function depends on the following packages:
#' - `gt`: for rendering the tables
#' - `tibble`: for creating the data structure
#' - `glue`: for dynamically constructing column names and labels
#'
#' @return Inserts R code chunks into the active Quarto document using `rstudioapi::insertText()`.
#'
#' @author
#' David Kane, Aashna Patel
#'
#' @importFrom glue glue
#' @importFrom tibble tribble
#' @importFrom gt gt tab_spanner tab_header cols_align fmt_markdown tab_footnote cells_title cells_column_spanners
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Insert causal tables for a study of senators
#' make_p_tables(
#'   is_causal = TRUE,
#'   unit_label = "Senator",
#'   outcome_label = "Potential Outcomes",
#'   treatment_label = "Phone Call",
#'   covariate_1_label = "Sex",
#'   covariate_2_label = "Age"
#' )
#' }



make_p_tables <- function(
  is_causal,
  unit_label,
  outcome_label,
  treatment_label,
  covariate_1_label,
  covariate_2_label
)

 {

    covariate_headers <- glue::glue("~`{covariate_1_label}`, ~`{covariate_2_label}`")
  covariate_values <- '"...", "...", "..."'
  covariate_gt_spanner_cols <- glue::glue("`{covariate_1_label}`, `{covariate_2_label}`")

  code_footnotes <- glue::glue(
    '```{{r}}
# Edit the following PRECEPTOR/POPULATION footnotes (look at the vignette for more details):
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
# Use "?" for unknowns in Preceptor Table rows, and "---" for unknowns in Data rows in the Population Table.
# Leave the third row and last column as-is to signal more rows exist
p_tibble <- tibble::tribble(
  ~`{unit_label}`, ~`Time/Year`, ~`{outcome_label} 1`, ~`{outcome_label} 2`, ~`{treatment_label}`, {covariate_headers}, ~`More`,
  "...", "...", "...", "...", "...", {covariate_values}, "...",
  "...", "...", "...", "...", "...", {covariate_values}, "...",
  "...", "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", {covariate_values}, "..."
)
```'
)


code_d_tibble <- glue::glue(
  '```{{r}}
d_tibble <- tibble::tribble(
  ~`Source`, ~`{unit_label}`, ~`Time/Year`, ~`{outcome_label} 1`, ~`{outcome_label} 2`, ~`{treatment_label}`, {covariate_headers}, ~`More`,
  "...", "...", "...", "...", "...", "...", {covariate_values}, "...",
  "Data", "...", "...", "...", "...", "...", {covariate_values}, "...",
  "Data", "...", "...", "...", "...", "...", {covariate_values}, "...",
  "Data", "...", "...", "...", "...", "...", {covariate_values}, "...",
  "Data", "...", "...", "...", "...", "...", {covariate_values}, "...",
  "...", "...", "...", "...", "...", "...", {covariate_values}, "...",
  # Reuse preceptor rows from p_tibble
  "Preceptor Table", !!!p_tibble[1, ] |> dplyr::as_tibble() |> dplyr::slice(1) |> unname() |> as.list(),
  "Preceptor Table", !!!p_tibble[2, ] |> dplyr::as_tibble() |> dplyr::slice(1) |> unname() |> as.list(),
  "Preceptor Table", !!!p_tibble[3, ] |> dplyr::as_tibble() |> dplyr::slice(1) |> unname() |> as.list(),
  "Preceptor Table", !!!p_tibble[4, ] |> dplyr::as_tibble() |> dplyr::slice(1) |> unname() |> as.list(),
  "...", "...", "...", "...", "...", "...", {covariate_values}, "..."
)
```'
)

code_p_table_causal <- glue::glue(
  '```{{r}}
gt::gt(data = p_tibble) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "Unit", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "Potential Outcomes", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "Treatment", id = "treatment_span", columns = c(`{treatment_label}`)) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(pre_title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(pre_units_footnote, locations = gt::cells_column_spanners(spanners = "unit_span")) |>
  gt::tab_footnote(pre_outcome_footnote, locations = gt::cells_column_spanners(spanners = "outcome_span")) |>
  gt::tab_footnote(pre_treatment_footnote, locations = gt::cells_column_spanners(spanners = "treatment_span")) |>
  gt::tab_footnote(pre_covariates_footnote, locations = gt::cells_column_spanners(spanners = "covariates_span"))
```'
)



code_p_table_predictive <- glue::glue(
  '```{{r}}
gt::gt(data = p_tibble) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "Unit/Time", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "Outcomes", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(pre_title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(pre_units_footnote, locations = gt::cells_column_spanners(spanners = "unit_span")) |>
  gt::tab_footnote(pre_outcome_footnote, locations = gt::cells_column_spanners(spanners = "outcome_span")) |>
  gt::tab_footnote(pre_covariates_footnote, locations = gt::cells_column_spanners(spanners = "covariates_span"))
```'
)



code_pop_table_causal <- glue::glue(
  '```{{r}}
gt::gt(data = d_tibble) |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "Unit/Time", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "Potential Outcomes", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "Treatment", id = "treatment_span", columns = c(`{treatment_label}`)) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(pop_title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(pop_units_footnote, locations = gt::cells_column_spanners(spanners = "unit_span")) |>
  gt::tab_footnote(pop_outcome_footnote, locations = gt::cells_column_spanners(spanners = "outcome_span")) |>
  gt::tab_footnote(pop_treatment_footnote, locations = gt::cells_column_spanners(spanners = "treatment_span")) |>
  gt::tab_footnote(pop_covariates_footnote, locations = gt::cells_column_spanners(spanners = "covariates_span"))
```'
)

code_pop_table_predictive <- glue::glue(
  '```{{r}}
gt::gt(data = d_tibble) |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "Unit/Time", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "Outcomes", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(pop_title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(pop_units_footnote, locations = gt::cells_column_spanners(spanners = "unit_span")) |>
  gt::tab_footnote(pop_outcome_footnote, locations = gt::cells_column_spanners(spanners = "outcome_span")) |>
  gt::tab_footnote(pop_covariates_footnote, locations = gt::cells_column_spanners(spanners = "covariates_span"))
```'
)



  code_p_table <- if (is_causal) code_p_table_causal else code_p_table_predictive
  code_pop_table <- if (is_causal) code_pop_table_causal else code_pop_table_predictive


  full_code <- paste(
    code_footnotes,
    code_p_tibble,
    code_d_tibble,
    code_p_table,
    code_pop_table,
    sep = "\n\n"
  )

  rstudioapi::insertText(
    location = rstudioapi::getActiveDocumentContext()$selection[[1]]$range,
    text = full_code
  )
}
