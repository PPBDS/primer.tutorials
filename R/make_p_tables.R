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
#' @name make_p_tables
#' @title Insert Preceptor and Population Table Templates
#'
#' @param type Character. Either `"causal"` or `"predictive"`. Determines
#'   whether potential outcomes are used (`"causal"`) or a single outcome (`"predictive"`).
#' @param unit_label Character. Label for the unit column (length 2).
#' @param outcome_label Character. Label for the outcome or potential outcomes.
#' @param treatment_label Character. Label for the treatment column (always required).
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
#' # Insert causal tables for a study of senators' voting behavior over years
#' make_p_tables(
#'   type = "causal",
#'   unit_label = c("Senator", "Session Year"),
#'   outcome_label = c("Support Bill", "Oppose Bill"),
#'   treatment_label = "Lobbying Contact",
#'   covariate_label = "Senator Age"
#' )
#'
#' # Insert predictive tables for a clinical trial measuring patient recovery over time
#' make_p_tables(
#'   type = "predictive",
#'   unit_label = c("Patient ID", "Visit Number"),
#'   outcome_label = c("Recovery Score"),
#'   treatment_label = "Drug Dosage Group",
#'   covariate_label = "Baseline Health Score"
#' )
#' }


make_p_tables <- function(
  type,
  unit_label,
  outcome_label,
  treatment_label,
  covariate_label,
  source_col = TRUE
) {
  # Validation
  if (length(unit_label) != 2) {
    stop("unit_label must be of length 2.", call. = FALSE)
  }
  if (type == "causal" && length(outcome_label) < 2) {
    stop("For causal tables, outcome_label must be of length 2 or greater.", call. = FALSE)
  }
  if (!type %in% c("causal", "predictive")) {
    stop("`type` must be either 'causal' or 'predictive'.")
  }


  # Both p_tibble and d_tibble use the same columns (no Source column yet)
  all_cols <- c(unit_label, outcome_label, treatment_label, covariate_label)
 
  # Source column only added during population table rendering
  pop_unit_cols <- if (source_col) c("Source", unit_label) else unit_label


  # Generate tribble code using helper function
  p_tribble_code <- write_input_tribble(all_cols)
  d_tribble_code <- write_input_tribble(all_cols)


  widths <- c(
    if (source_col) 80 else NULL,  # Source column width
    max(nchar(unit_label[1]) * 8, 100),  # Minimum 100px for first unit column
    max(nchar(unit_label[2]) * 8, 120),  # Minimum 120px for second unit column
    rep(max(max(nchar(outcome_label)) * 8, 120), length(outcome_label)),  # Minimum 120px per outcome
    max(nchar(treatment_label) * 8, 120),  # Minimum 120px for treatment
    max(nchar(covariate_label) * 8, 120),  # Minimum 120px for covariate
    60  # More column
  )


  glue_cols <- function(cols) paste0("`", cols, "`", collapse = ", ")


  code_footnotes <- glue::glue(
    "```{{r}}
pre_title_footnote <- \"...\"
pre_units_footnote <- \"...\"
pre_outcome_footnote <- \"...\"
pre_treatment_footnote <- \"...\"
pre_covariates_footnote <- \"...\"


pop_title_footnote <- \"...\"
pop_units_footnote <- \"...\"
pop_outcome_footnote <- \"...\"
pop_treatment_footnote <- \"...\"
pop_covariates_footnote <- \"...\"


p_tibble <- {p_tribble_code}


d_tibble <- {d_tribble_code}
```"
  )


  code_p_table <- glue::glue(
    "```{{r}}
p_tibble_full <- expand_input_tibble(list(p_tibble), \"preceptor\")


gt::gt(p_tibble_full) |>
  gt::tab_header(title = \"Preceptor Table\") |>
  gt::tab_spanner(label = \"Unit/Time\", id = \"unit_span\", columns = c({glue_cols(unit_label)})) |>
  gt::tab_spanner(label = \"Potential Outcomes\", id = \"outcome_span\", columns = c({glue_cols(outcome_label)})) |>
  gt::tab_spanner(label = \"Treatment\", id = \"treatment_span\", columns = c({glue_cols(treatment_label)})) |>
  gt::tab_spanner(label = \"Covariates\", id = \"covariates_span\", columns = c({glue_cols(covariate_label)})) |>
  gt::cols_align(align = \"center\", columns = gt::everything()) |>
  gt::cols_align(align = \"left\", columns = c(`{unit_label[1]}`)) |>
  gt::cols_width({
    all_cols_with_more <- c(unit_label, outcome_label, treatment_label, covariate_label, \"More\")
    width_assignments <- paste0('\"', all_cols_with_more, '\" ~ gt::px(', widths[!is.null(widths)], ')', collapse = \", \")
    width_assignments
  }) |>
  gt::tab_style(
    style = gt::cell_text(size = gt::px(14)),
    locations = gt::cells_body()
  ) |>
  gt::tab_style(
    style = list(
      gt::cell_text(size = gt::px(14), weight = \"bold\"),
      gt::cell_borders(sides = \"bottom\", weight = gt::px(2))
    ),
    locations = gt::cells_column_labels()
  ) |>
  gt::tab_options(
    table.font.size = gt::px(14),
    data_row.padding = gt::px(12),
    column_labels.padding = gt::px(12),
    row_group.padding = gt::px(12),
    table.width = gt::pct(100),
    table.margin.left = gt::px(0),
    table.margin.right = gt::px(0)
  ) |>
  gt::fmt_markdown(columns = gt::everything())
```"
  )


  # Population table code - fixed to show all 4 data rows and proper structure
  if (source_col) {
    code_pop_table <- glue::glue(
      "```{{r}}
# Create full data tibble with 4 rows (3 content, 1 blank in 3rd position)
data_tibble <- dplyr::bind_rows(
  d_tibble[1:2, , drop = FALSE],  # First 2 data rows
  d_tibble[1, , drop = FALSE] |> dplyr::mutate(dplyr::across(dplyr::everything(), ~ \"...\")),  # Blank row
  d_tibble[3, , drop = FALSE]     # Last data row
) |>
  dplyr::mutate(Source = \"Data\", .before = 1)


# Create preceptor tibble from p_tibble_full (remove More column, add Source)
preceptor_tibble <- p_tibble_full |>
  dplyr::select(-More) |>
  dplyr::mutate(Source = \"Preceptor\", .before = 1)


# Create the 11-row population table structure manually
# Row structure: blank, 4 data (3rd blank), blank, 4 preceptor (3rd blank), blank

# Create empty row template
empty_row <- data_tibble[1, , drop = FALSE]
empty_row[,] <- \"...\"

# Build the 11-row structure
population_tibble <- dplyr::bind_rows(
  empty_row,              # Row 1: blank
  data_tibble,            # Rows 2-5: 4 data rows (3rd is blank)
  empty_row,              # Row 6: blank  
  preceptor_tibble,       # Rows 7-10: 4 preceptor rows (3rd is blank)
  empty_row               # Row 11: blank
)

# Add More column
population_tibble$More <- \"...\"


gt::gt(population_tibble) |>
  gt::tab_header(title = \"Population Table\") |>
  gt::tab_spanner(label = \"Unit/Time\", id = \"unit_span\", columns = c({glue_cols(pop_unit_cols)})) |>
  gt::tab_spanner(label = \"Potential Outcomes\", id = \"outcome_span\", columns = c({glue_cols(outcome_label)})) |>
  gt::tab_spanner(label = \"Treatment\", id = \"treatment_span\", columns = c({glue_cols(treatment_label)})) |>
  gt::tab_spanner(label = \"Covariates\", id = \"covariates_span\", columns = c({glue_cols(covariate_label)})) |>
  gt::cols_align(align = \"center\", columns = gt::everything()) |>
  gt::cols_align(align = \"left\", columns = c(`{unit_label[1]}`)) |>
  gt::cols_width({
    all_cols_with_more <- c(pop_unit_cols, outcome_label, treatment_label, covariate_label, \"More\")
    width_assignments <- paste0('\"', all_cols_with_more, '\" ~ gt::px(', widths[!is.null(widths)], ')', collapse = \", \")
    width_assignments
  }) |>
  gt::tab_style(
    style = gt::cell_text(size = gt::px(14)),
    locations = gt::cells_body()
  ) |>
  gt::tab_style(
    style = list(
      gt::cell_text(size = gt::px(14), weight = \"bold\"),
      gt::cell_borders(sides = \"bottom\", weight = gt::px(2))
    ),
    locations = gt::cells_column_labels()
  ) |>
  gt::tab_options(
    table.font.size = gt::px(14),
    data_row.padding = gt::px(12),
    column_labels.padding = gt::px(12),
    row_group.padding = gt::px(12),
    table.width = gt::pct(100),
    table.margin.left = gt::px(0),
    table.margin.right = gt::px(0)
  ) |>
  gt::fmt_markdown(columns = gt::everything())
```"
    )
  } else {
    code_pop_table <- glue::glue(
      "```{{r}}
# Create full data tibble with 4 rows (3 content, 1 blank in 3rd position)
data_tibble <- dplyr::bind_rows(
  d_tibble[1:2, , drop = FALSE],  # First 2 data rows
  d_tibble[1, , drop = FALSE] |> dplyr::mutate(dplyr::across(dplyr::everything(), ~ \"...\")),  # Blank row
  d_tibble[3, , drop = FALSE]     # Last data row
)


# Create preceptor tibble from p_tibble_full (remove More column)
preceptor_tibble <- p_tibble_full |>
  dplyr::select(-More)


# Create the 11-row population table structure manually
# Row structure: blank, 4 data (3rd blank), blank, 4 preceptor (3rd blank), blank

# Create empty row template
empty_row <- data_tibble[1, , drop = FALSE]
empty_row[,] <- \"...\"

# Build the 11-row structure
population_tibble <- dplyr::bind_rows(
  empty_row,              # Row 1: blank
  data_tibble,            # Rows 2-5: 4 data rows (3rd is blank)
  empty_row,              # Row 6: blank  
  preceptor_tibble,       # Rows 7-10: 4 preceptor rows (3rd is blank)
  empty_row               # Row 11: blank
)

# Add More column
population_tibble$More <- \"...\"


gt::gt(population_tibble) |>
  gt::tab_header(title = \"Population Table\") |>
  gt::tab_spanner(label = \"Unit/Time\", id = \"unit_span\", columns = c({glue_cols(pop_unit_cols)})) |>
  gt::tab_spanner(label = \"Potential Outcomes\", id = \"outcome_span\", columns = c({glue_cols(outcome_label)})) |>
  gt::tab_spanner(label = \"Treatment\", id = \"treatment_span\", columns = c({glue_cols(treatment_label)})) |>
  gt::tab_spanner(label = \"Covariates\", id = \"covariates_span\", columns = c({glue_cols(covariate_label)})) |>
  gt::cols_align(align = \"center\", columns = gt::everything()) |>
  gt::cols_align(align = \"left\", columns = c(`{unit_label[1]}`)) |>
  gt::cols_width({
    all_cols_with_more <- c(pop_unit_cols, outcome_label, treatment_label, covariate_label, \"More\")
    width_assignments <- paste0('\"', all_cols_with_more, '\" ~ gt::px(', widths[!is.null(widths)], ')', collapse = \", \")
    width_assignments
  }) |>
  gt::fmt_markdown(columns = gt::everything())
```"
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
