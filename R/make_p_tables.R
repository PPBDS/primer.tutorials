#' Insert Preceptor and Population Table Templates in Quarto
#'
#' Inserts a Quarto-ready template consisting of multiple code chunks for creating
#' **Preceptor Tables** and **Population Tables**. These tables support both causal
#' and predictive workflows.
#'
#' The output includes:
#' - Editable footnotes for documentation
#' - Empty `tibble`s for the Preceptor Table and Population Table (the latter includes
#'   the Preceptor rows)
#' - `gt` code chunks to render each table with labeled spanners and columns
#'   sized roughly proportional to label length
#' - The Preceptor and Population tables include a final "More" column and
#'   a last empty row added during rendering for easier editing
#'
#' @param type Character. Either `"causal"` or `"predictive"`. Determines
#'   whether treatment and potential outcomes columns are included (`"causal"`)
#'   or a single outcome and no treatment (`"predictive"`).
#' @param unit_label Character. Label for the unit column.
#' @param outcome_label Character. Label for the outcome or potential outcomes.
#' @param treatment_label Character. Label for the treatment column (required if `type = "causal"`).
#' @param covariate_label Character. Label for the covariate column.
#' @param source_col Logical. Whether to include a `"Source"` column in the population table. Defaults to `TRUE`.
#'
#' @note
#' - All cell entries in the tibbles must be wrapped in double quotes, including numbers (e.g., `"42"`).
#' - The initial tibbles are simplified for easier editing; an additional row and "More" column
#'   are added during table rendering.
#' - Column widths in the rendered `gt` tables are set proportionally to the length of the column labels,
#'   helping maintain readable, centered columns.
#'
#' @details
#' This function inserts R code chunks into the active Quarto document via
#' `rstudioapi::insertText()`. The inserted code includes editable footnotes,
#' two tibbles (`p_tibble` and `d_tibble`) for the user to fill out, and the
#' assembly of final tables with proper column grouping and formatting.
#'
#' @return Invisibly returns `NULL`. Inserts code into the active Quarto document.
#'
#' @author David Kane, Aashna Patel
#'
#' @importFrom glue glue
#' @importFrom tibble tribble
#' @importFrom gt gt tab_spanner tab_header cols_align cols_width fmt_markdown
#' @importFrom dplyr add_row mutate
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Insert causal tables for a study of senators
#' make_p_tables(
#'   type = "causal",
#'   unit_label = "Senator",
#'   outcome_label = "Potential Outcomes",
#'   treatment_label = "Phone Call",
#'   covariate_label = "Sex"
#' )
#'
#' # Insert predictive tables without treatment
#' make_p_tables(
#'   type = "predictive",
#'   unit_label = "Patient",
#'   outcome_label = "Outcome",
#'   treatment_label = NULL,
#'   covariate_label = "Age"
#' )
#' }


make_p_tables <- function(
  type,                # "causal" or "predictive"
  unit_label,
  outcome_label,
  treatment_label,
  covariate_label,
  source_col = TRUE    # whether to include Source column in population table
) {
  # Validate type
  if (!type %in% c("causal", "predictive")) {
    stop("`type` must be either 'causal' or 'predictive'.")
  }

  covariate_headers <- glue::glue("~`{covariate_label}`")
  covariate_gt_spanner_cols <- glue::glue("`{covariate_label}`")

  code_footnotes <- glue::glue(
    '```{{r}}
# Edit the following PRECEPTOR/POPULATION footnotes:
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

  # Preceptor table tibble — user editable: NO More column, NO extra row
  if (type == "causal") {
    code_p_tibble <- glue::glue(
      '```{{r}}
p_tibble <- tibble::tribble(
  ~`{unit_label}`, ~`Time/Year`, ~`{outcome_label} 1`, ~`{outcome_label} 2`, ~`{treatment_label}`, {covariate_headers},
  "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...", "..."
)
```'
    )
  } else {
    code_p_tibble <- glue::glue(
      '```{{r}}
p_tibble <- tibble::tribble(
  ~`{unit_label}`, ~`Time/Year`, ~`{outcome_label} 1`, ~`{outcome_label} 2`, {covariate_headers},
  "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "...",
  "...", "...", "...", "...", "..."
)
```'
    )
  }

  # Population table tibble — user editable: NO More column, NO extra row
  source_col_header <- if (source_col) "~`Source`, " else ""
  source_col_value <- if (source_col) '"...", ' else ""

  if (type == "causal") {
    code_d_tibble <- glue::glue(
      '```{{r}}
d_tibble <- tibble::tribble(
  {source_col_header}~`{unit_label}`, ~`Time/Year`, ~`{outcome_label} 1`, ~`{outcome_label} 2`, ~`{treatment_label}`, {covariate_headers},
  {source_col_value}"...", "...", "...", "...", "...", "...",
  {source_col_value}"Data", "...", "...", "...", "...", "...",
  {source_col_value}"Data", "...", "...", "...", "...", "..."
)
```'
    )
  } else {
    code_d_tibble <- glue::glue(
      '```{{r}}
d_tibble <- tibble::tribble(
  {source_col_header}~`{unit_label}`, ~`Time/Year`, ~`{outcome_label} 1`, ~`{outcome_label} 2`, {covariate_headers},
  {source_col_value}"...", "...", "...", "...", "...",
  {source_col_value}"Data", "...", "...", "...", "...",
  {source_col_value}"Data", "...", "...", "...", "..."
)
```'
    )
  }

  # Preceptor table rendering — add missing row + More column here
  if (type == "causal") {
    code_p_table <- glue::glue(
      '```{{r}}
p_tibble_full <- p_tibble |>
  dplyr::add_row(!!!as.list(rep(NA, ncol(p_tibble)))) |>
  dplyr::mutate(More = c(rep(NA, nrow(.)-1), "..."))

gt::gt(data = p_tibble_full) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "Unit", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "Potential Outcomes", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "Treatment", id = "treatment_span", columns = c(`{treatment_label}`)) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::fmt_markdown(columns = gt::everything())
```'
    )
  } else {
    code_p_table <- glue::glue(
      '```{{r}}
p_tibble_full <- p_tibble |>
  dplyr::add_row(!!!as.list(rep(NA, ncol(p_tibble)))) |>
  dplyr::mutate(More = c(rep(NA, nrow(.)-1), "..."))

gt::gt(data = p_tibble_full) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "Unit/Time", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "Outcomes", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::fmt_markdown(columns = gt::everything())
```'
    )
  }

  # Population table rendering — add missing row + More column here
  if (type == "causal") {
    code_pop_table <- glue::glue(
      '```{{r}}
d_tibble_full <- d_tibble |>
  dplyr::add_row(!!!as.list(rep(NA, ncol(d_tibble)))) |>
  dplyr::mutate(More = c(rep(NA, nrow(.)-1), "..."))

gt::gt(data = d_tibble_full) |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "Unit/Time", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "Potential Outcomes", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "Treatment", id = "treatment_span", columns = c(`{treatment_label}`)) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::fmt_markdown(columns = gt::everything())
```'
    )
  } else {
    code_pop_table <- glue::glue(
      '```{{r}}
d_tibble_full <- d_tibble |>
  dplyr::add_row(!!!as.list(rep(NA, ncol(d_tibble)))) |>
  dplyr::mutate(More = c(rep(NA, nrow(.)-1), "..."))

gt::gt(data = d_tibble_full) |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "Unit/Time", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "Outcomes", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({covariate_gt_spanner_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::fmt_markdown(columns = gt::everything())
```'
    )
  }

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
 