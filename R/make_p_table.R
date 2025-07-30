#' Insert a standardized Preceptor or Population Table template
#'
#' This function creates a template for a Preceptor or Population Table, used to show units, outcomes, treatments, and covariates for causal or predictive models.
#' The output is inserted directly into the current R Markdown or Quarto document at the cursor.
#'
#' Key behaviors:
#' - Spanner headers always include: Units/Time, Outcomes, Treatment (if causal), Covariates
#' - Covariates always end with a "..." placeholder column
#' - Population Tables include a Source column by default
#' - Footnotes are included for each spanner and the title, with "Describe what goes here" filler text
#'
#' @param table Character. One of "preceptor" or "population". Partial matching is supported.
#' @param type Character. One of "predictive" or "causal". Partial matching is supported.
#' @param unit_label Character vector of length 1 (preceptor) or 2 (population). Column labels for units.
#' @param outcome_label Character vector of length 1 (predictive) or 2+ (causal). Column labels for outcomes.
#' @param treatment_label Character of length 1 (only used for causal tables).
#' @param covariate_label Character vector. Covariate column labels.
#' @param num_rows Integer. Number of data rows (excluding "..." rows). If NULL, defaults to 5 for preceptor, 6 for population.
#'
#' @export
make_p_table <- function(table = "preceptor",
                         type = "predictive",
                         unit_label = NULL,
                         outcome_label = NULL,
                         treatment_label = NULL,
                         covariate_label = NULL,
                         num_rows = NULL) {

  # Validate inputs
  table <- tolower(substr(table, 1, 3))  # "pre", "pop"
  type <- tolower(substr(type, 1, 3))    # "pre", "cau"
  is_preceptor <- startsWith(table, "pre")
  is_causal <- startsWith(type, "cau")

  if (is.null(num_rows)) num_rows <- if (is_preceptor) 5 else 6

  if (is_preceptor && length(unit_label) != 1)
    stop("Preceptor tables require a single unit label.")
  if (!is_preceptor && length(unit_label) != 2)
    stop("Population tables require two unit labels (unit and time).")

  if (is_causal && length(outcome_label) < 2)
    stop("Causal tables must include at least two potential outcomes.")
  if (!is_causal && length(outcome_label) != 1)
    stop("Predictive tables must include one outcome column.")

  if (is_causal && is.null(treatment_label))
    stop("Causal tables must include a treatment label.")

  if (is.null(covariate_label)) covariate_label <- c("Covariate 1", "Covariate 2")
  covariate_label <- c(covariate_label, "...")  # Always add "..." column

  # Labels and columns
  unit_cols <- paste0("`", unit_label, "`", collapse = ", ")
  outcome_cols <- paste0("`", outcome_label, "`", collapse = ", ")
  covariate_cols <- paste0("`", covariate_label, "`", collapse = ", ")
  treatment_col <- if (is_causal) paste0("`", treatment_label, "`") else NULL
  spanner_treatment <- if (is_causal) glue::glue('  gt::tab_spanner(label = "Treatment", columns = c({treatment_col})) |>\n') else ""
  treatment_col_def <- if (is_causal) paste0(", ~`", treatment_label, "`") else ""

  # Column headers
  col_headers <- c(
    if (!is_preceptor) "~`Source`",
    if (!is_preceptor) paste0("~`", unit_label[1], "`"),
    if (!is_preceptor) paste0("~`", unit_label[2], "`"),
    if (is_preceptor) paste0("~`", unit_label, "`"),
    paste0("~`", outcome_label, "`"),
    if (is_causal) paste0("~`", treatment_label, "`"),
    paste0("~`", covariate_label, "`")
  )
  col_header_line <- paste(col_headers, collapse = ", ")

  # Data rows
  filler_row <- rep('"..."', length(col_headers))
  data_rows <- c(paste(filler_row, collapse = ", "))
  for (i in seq_len(num_rows)) {
    data_rows <- c(data_rows, paste(rep('"..."', length(col_headers)), collapse = ", "))
  }
  data_rows <- c(data_rows, paste(filler_row, collapse = ", "))

  # Spanners
  spanner_units <- if (is_preceptor) "Units" else "Units/Time"
  spanner_outcomes <- if (is_causal) "Potential Outcomes" else "Outcome"
  align_left_col <- if (is_preceptor) glue::glue("`{unit_label}`") else "`Source`"

  # Footnote placeholders
  footnotes <- glue::glue('
# Edit these footnotes after inserting
title_footnote <- "Describe the table’s purpose and what it helps answer."
units_footnote <- "Describe the units and time span."
outcome_footnote <- "Explain why this is predictive or causal, and details about the outcome(s)."
treatment_footnote <- "Describe the treatment and how it appears in the data."  # only for causal
covariates_footnote <- "Describe covariates and how they relate to those in the data."
')

  gt_footnotes <- glue::glue(
'  gt::tab_footnote(title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(units_footnote, locations = gt::cells_column_spanners(spanners = "{spanner_units}")) |>
  gt::tab_footnote(outcome_footnote, locations = gt::cells_column_spanners(spanners = "{spanner_outcomes}")) |>
  {if (is_causal) "gt::tab_footnote(treatment_footnote, locations = gt::cells_column_spanners(spanners = \"Treatment\")) |>\n" else ""}  gt::tab_footnote(covariates_footnote, locations = gt::cells_column_spanners(spanners = \"Covariates\"))'
  )

  # Full code block
  code <- glue::glue(
'```{{r}}
{footnotes}

tibble::tribble(
  {col_header_line},
  {paste(data_rows, collapse = ",\n  ")}
) |>
  gt::gt() |>
  gt::tab_header(title = "{if (is_preceptor) "Preceptor Table" else "Population Table"}: [Edit Description]") |>
  gt::tab_spanner(label = "{spanner_units}", columns = c({unit_cols})) |>
  gt::tab_spanner(label = "{spanner_outcomes}", columns = c({outcome_cols})) |>
{spanner_treatment}  gt::tab_spanner(label = "Covariates", columns = c({covariate_cols})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c({align_left_col})) |>
  gt::fmt_markdown(columns = gt::everything()) |>
{gt_footnotes}
```'
  )

  rstudioapi::insertText(
    location = rstudioapi::getActiveDocumentContext()$selection[[1]]$range,
    text = code
  )
}
