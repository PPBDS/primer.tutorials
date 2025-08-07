#' Insert Preceptor and Population Table Templates in Quarto
#'
#' This function inserts a five-chunk Quarto-ready template for creating **Preceptor Tables** and **Population Tables**. These tables are designed to support causal and predictive modeling workflows by clearly labeling variables with spanners and encouraging thorough documentation via editable footnotes.
#'
#' The output includes:
#' - a tibble for the **Preceptor Table**
#' - a tibble for the **Population Table** (which includes Preceptor rows)
#' - `gt` code to display each table with labeled spanners
#' - editable footnotes for each section of the table
#' - cleanup code to remove temporary objects
#'
#' @description
#' These tables are meant to be self-contained and interpretable in isolation. Each table includes five spanner headers:
#'
#' - `"Unit"` (or `"Unit/Time"` in the Population Table)
#' - `"Outcome"` for predictive models, or `"Potential Outcomes"` for causal models
#' - `"Treatment"` (included only in causal models)
#' - `"Covariates"` — a set of user-specified labels (typically 3)
#'
#' The *labels* provided to this function are **not variable names from a dataset**, but rather **human-readable phrases** (e.g., `"Math Score if in Small Class"`). Long labels will be wrapped automatically when rendered using the `{gt}` package.
#'
#' The goal is to visually communicate which variables play which roles in your modeling. Each spanner groups columns of a shared type. Footnotes help document the rationale and context for each set of variables.
#'
#' NOTE: all table entries must be surrounded by double quotes, even numbers (Ex: "42").
#' 
#' Footnotes will appear under:
#' - the **table title** (background/motivation)
#' - the **Units** (unit/time range)
#' - the **Outcome(s)** (why this outcome is used)
#' - the **Treatment** (how it’s defined in the Preceptor vs. Population Table)
#' - the **Covariates** (why these were chosen and whether they differ across the two tables)
#'
#' The author is encouraged to fill in or delete these footnotes after the code is inserted. To **remove** a footnote, simply set it to `NULL`. This will hide the footnote from the rendered `gt` table.
#'
#' Preceptor and Population Tables are inserted together. The Population Table includes a `"Source"` column as its first column, which takes values `"Data"` or `"Preceptor Table"` depending on origin. This structure encourages comparison between expected and observed values.
#'
#' Behind the scenes, these tables are generated using `tibble::tribble()` for easier manual editing by row. This helps authors align values vertically and encourages clear visual structure in the Quarto document.
#'
#' @param is_causal Logical. If `TRUE`, generates a causal table with treatment and potential outcomes; if `FALSE`, generates a predictive table with one outcome and no treatment column.
#' @param unit_label Character. Label for the unit spanner (e.g., `"Student"` or `"Senator"`).
#' @param outcome_label Character. Label for the outcome spanner. Should be `"Outcome"` for predictive models, or `"Potential Outcomes"` for causal models.
#' @param treatment_label Character. Label for the treatment spanner. Required only if `is_causal = TRUE`.
#' @param covariate_1_label Character. Label for the first covariate.
#' @param covariate_2_label Character. Label for the second covariate.
#' @param covariate_3_label Character. Label for the third covariate.
#' @param pre_time Character. Default value used to populate the `"Time/Year"` column of the Preceptor Table. This helps authors indicate when expectations were formed.
#' 
#' @note
#'
#' Required packages:
#' This function depends on the following packages:
#' - `gt`: for rendering the tables
#' - `tibble`: for creating the data structure
#' - `glue`: for dynamically constructing column names and labels
#'
#' You can install them if not already installed:
#' ```r
#' install.packages(c("gt", "tibble", "glue"))
#' ```

#' @return This function inserts R code chunks directly into your currently open Quarto document, using `rstudioapi::insertText()`. The chunks include tibbles, `gt` rendering code, editable footnotes, and cleanup.
#'
#' @note
#' - No default values are provided for labels, other than `NULL`. If a required argument is not supplied, the function will return an error.
#' - The code chunk environments are self-contained and designed to avoid variable conflicts in the surrounding document.
#' - Labels should be kept concise but human-readable. If necessary, abbreviate.
#'
#' @importFrom glue glue
#' @importFrom tibble tribble
#' @importFrom gt gt tab_spanner tab_header cols_align fmt_markdown tab_footnote cells_title cells_column_spanners
#'
#' @examples
#' \dontrun{
#' make_p_tables(
#'   is_causal = TRUE,
#'   unit_label = "Senator",
#'   outcome_label = "Potential Outcomes",
#'   treatment_label = "Phone Call",
#'   covariate_1_label = "Sex",
#'   covariate_2_label = "Age",
#'   covariate_3_label = "Incumbency",
#'   pre_time = "2022"
#' )
#' }
#' 
#'@examples
#' Example output (Preceptor and Population Tables):
#'
#' \figure{Screenshot-2025-08-06-181554.png}{options: width=80%}
#' \figure{Screenshot-2025-08-06-181621.png}{options: width=80%}
#'
#' The images above show a sample Preceptor Table and Population Table generated by this function.
#' 
#' @export

make_p_tables <- function(
  is_causal = TRUE,
  unit_label = "Unit",
  outcome_label = if (is_causal) "Potential Outcomes" else "Outcome",
  treatment_label = "Treatment",
  covariate_1_label = "sex",
  covariate_2_label = "age",
  covariate_3_label = "incumbent",
  pre_time = "2020"
)
 {

    covariate_headers <- glue::glue("~`{covariate_1_label}`, ~`{covariate_2_label}`, ~`{covariate_3_label}`")
  covariate_values <- '"...", "...", "..."'
  covariate_gt_spanner_cols <- glue::glue("`{covariate_1_label}`, `{covariate_2_label}`, `{covariate_3_label}`")

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
  ~`{unit_label}`, ~`Time/Year`, ~`{outcome_label} 1`, ~`{outcome_label} 2`, ~`{treatment_label}`, {covariate_headers}, ~`More`,
  "...", "{pre_time}", "...", "...", "...", {covariate_values}, "...",
  "...", "{pre_time}", "...", "...", "...", {covariate_values}, "...",
  "...", "{pre_time}", "...", "...", "...", {covariate_values}, "...",
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
  gt::tab_spanner(label = "{unit_label}", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "{outcome_label}", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "{treatment_label}", id = "treatment_span", columns = c(`{treatment_label}`)) |>
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
  gt::tab_spanner(label = "{unit_label}", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "{outcome_label}", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
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
  gt::tab_spanner(label = "{unit_label}/Time", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "{outcome_label}", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
  gt::tab_spanner(label = "{treatment_label}", id = "treatment_span", columns = c(`{treatment_label}`)) |>
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
  gt::tab_spanner(label = "{unit_label}/Time", id = "unit_span", columns = c(`{unit_label}`, `Time/Year`)) |>
  gt::tab_spanner(label = "{outcome_label}", id = "outcome_span", columns = c(`{outcome_label} 1`, `{outcome_label} 2`)) |>
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
