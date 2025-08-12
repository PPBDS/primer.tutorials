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

make_labels <- function(x) {
  paste0("~`", x, "`")
}

make_p_tables <- function(
  type,
  unit_label,
  outcome_label,
  treatment_label = NULL,
  covariate_label,
  source_col = TRUE
) {
  if (!type %in% c("causal", "predictive")) {
    stop("`type` must be either 'causal' or 'predictive'.")
  }

  outcome_cols <- c(paste0(outcome_label, " 1"), paste0(outcome_label, " 2"))

  if (type == "causal") {
    all_cols <- c(unit_label, "Time/Year", outcome_cols, treatment_label, covariate_label)
  } else {
    all_cols <- c(unit_label, "Time/Year", outcome_cols, covariate_label)
  }

  pop_cols <- if (source_col) c("Source", all_cols) else all_cols

  # *** FIX HERE: collapse vector into one string ***
  p_col_headers <- paste(make_labels(all_cols), collapse = ", ")
  d_col_headers <- paste(make_labels(pop_cols), collapse = ", ")

  # Create rows of placeholders
  p_rows <- paste(
    paste(rep('"..."', length(all_cols)), collapse = ", "),
    paste(rep('"..."', length(all_cols)), collapse = ", "),
    paste(rep('"..."', length(all_cols)), collapse = ", "),
    sep = ",\n  "
  )

  d_rows <- paste(
    paste(rep('"..."', length(pop_cols)), collapse = ", "),
    paste(rep('"..."', length(pop_cols)), collapse = ", "),
    paste(rep('"..."', length(pop_cols)), collapse = ", "),
    sep = ",\n  "
  )

  unit_spanner_cols <- c(unit_label, "Time/Year")
  outcome_spanner_cols <- outcome_cols
  treatment_spanner_cols <- if (type == "causal") treatment_label else character(0)
  covariate_spanner_cols <- covariate_label
  pop_unit_cols <- if (source_col) c("Source", unit_spanner_cols) else unit_spanner_cols

  widths <- c(
    nchar(unit_label) + 2,
    9,
    rep(nchar(outcome_label) + 2, 2),
    if (type == "causal") nchar(treatment_label) + 2 else numeric(0),
    nchar(covariate_label) + 2,
    5
  )

  glue_cols <- function(cols) {
    paste0("`", cols, "`", collapse = ", ")
  }

  code_footnotes <- 
    '```{{r}}
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

p_tibble <- tibble::tribble(
  {p_col_headers},
  {p_rows}
)

d_tibble <- tibble::tribble(
  {d_col_headers},
  {d_rows}
)
```'

  code_footnotes <- glue::glue(code_footnotes)

  if (type == "causal") {
    code_p_table <- glue::glue(
      '```{{r}}
p_tibble_full <- p_tibble |>
  dplyr::add_row(!!!as.list(rep(NA, ncol(p_tibble)))) |>
  dplyr::mutate(More = c(rep(NA, nrow(.) - 1), "..."))

gt::gt(p_tibble_full) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "Unit", id = "unit_span", columns = c({glue_cols(unit_spanner_cols)})) |>
  gt::tab_spanner(label = "Potential Outcomes", id = "outcome_span", columns = c({glue_cols(outcome_spanner_cols)})) |>
  gt::tab_spanner(label = "Treatment", id = "treatment_span", columns = c({glue_cols(treatment_spanner_cols)})) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({glue_cols(covariate_spanner_cols)})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::cols_width(columns = c({glue_cols(c(unit_spanner_cols, outcome_spanner_cols, treatment_spanner_cols, covariate_spanner_cols, "More"))}),
                 widths = gt::px(c({paste(widths, collapse = ", ")}))) |>
  gt::fmt_markdown(columns = gt::everything())
```'
    )
  } else {
    code_p_table <- glue::glue(
      '```{{r}}
p_tibble_full <- p_tibble |>
  dplyr::add_row(!!!as.list(rep(NA, ncol(p_tibble)))) |>
  dplyr::mutate(More = c(rep(NA, nrow(.) - 1), "..."))

gt::gt(p_tibble_full) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "Unit/Time", id = "unit_span", columns = c({glue_cols(unit_spanner_cols)})) |>
  gt::tab_spanner(label = "Outcomes", id = "outcome_span", columns = c({glue_cols(outcome_spanner_cols)})) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({glue_cols(covariate_spanner_cols)})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::cols_width(columns = c({glue_cols(c(unit_spanner_cols, outcome_spanner_cols, covariate_spanner_cols, "More"))}),
                 widths = gt::px(c({paste(widths, collapse = ", ")}))) |>
  gt::fmt_markdown(columns = gt::everything())
```'
    )
  }

  if (type == "causal") {
    code_pop_table <- glue::glue(
      '```{{r}}
d_tibble_full <- d_tibble |>
  dplyr::add_row(!!!as.list(rep(NA, ncol(d_tibble)))) |>
  dplyr::mutate(More = c(rep(NA, nrow(.) - 1), "..."))

gt::gt(d_tibble_full) |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "Unit/Time", id = "unit_span", columns = c({glue_cols(pop_unit_cols)})) |>
  gt::tab_spanner(label = "Potential Outcomes", id = "outcome_span", columns = c({glue_cols(outcome_spanner_cols)})) |>
  gt::tab_spanner(label = "Treatment", id = "treatment_span", columns = c({glue_cols(treatment_spanner_cols)})) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({glue_cols(covariate_spanner_cols)})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::cols_width(columns = c({glue_cols(c(pop_unit_cols, outcome_spanner_cols, treatment_spanner_cols, covariate_spanner_cols, "More"))}),
                 widths = gt::px(c({paste(widths, collapse = ", ")}))) |>
  gt::fmt_markdown(columns = gt::everything())
```'
    )
  } else {
    code_pop_table <- glue::glue(
      '```{{r}}
d_tibble_full <- d_tibble |>
  dplyr::add_row(!!!as.list(rep(NA, ncol(d_tibble)))) |>
  dplyr::mutate(More = c(rep(NA, nrow(.) - 1), "..."))

gt::gt(d_tibble_full) |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "Outcomes", id = "outcome_span", columns = c({glue_cols(outcome_spanner_cols)})) |>
  gt::tab_spanner(label = "Unit/Time", id = "unit_span", columns = c({glue_cols(pop_unit_cols)})) |>
  gt::tab_spanner(label = "Covariates", id = "covariates_span", columns = c({glue_cols(covariate_spanner_cols)})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label}`)) |>
  gt::cols_width(columns = c({glue_cols(c(pop_unit_cols, outcome_spanner_cols, covariate_spanner_cols, "More"))}),
                 widths = gt::px(c({paste(widths, collapse = ", ")}))) |>
  gt::fmt_markdown(columns = gt::everything())
```'
    )
  }

  full_code <- paste(
    code_footnotes,
    code_p_table,
    code_pop_table,
    sep = "\n\n"
  )

  rstudioapi::insertText(
    location = rstudioapi::getActiveDocumentContext()$selection[[1]]$range,
    text = full_code
  )

  invisible(NULL)
}
