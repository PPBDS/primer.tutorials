````r
#' Create a Preceptor and Population Table Template
#'
#' This function inserts multiple code blocks into a Quarto or R Markdown document to help the user construct a standardized Preceptor Table and its corresponding Population Table.
#'
#' The Population Table includes all rows from the Preceptor Table plus rows from the data.
#' Spanner headers indicate Units/Time, Outcomes, Treatment (if applicable), and Covariates.
#'
#' @param type One of "predictive" or "causal"
#' @param unit_label A character vector. Length 1 (Preceptor) or 2 (Population). e.g., c("Candidate", "Year")
#' @param outcome_label Character vector. Length 1 (predictive) or 2+ (causal).
#' @param treatment_label Character. Only used for causal tables.
#' @param covariate_label Character vector of covariate column labels.
#' @param title Character. Optional title for the tables.
#'
#' @export
make_p_table <- function(type = "predictive",
                         unit_label,
                         outcome_label,
                         treatment_label = NULL,
                         covariate_label,
                         title = "Years Lived After Election") {

  is_causal <- startsWith(tolower(type), "c")

  if (!is_causal && length(outcome_label) != 1)
    stop("Predictive tables require one outcome label.")
  if (is_causal && length(outcome_label) < 2)
    stop("Causal tables require multiple outcome labels.")
  if (is_causal && is.null(treatment_label))
    stop("Causal tables require a treatment label.")
  if (length(unit_label) != 2)
    stop("You must provide both unit and time labels for the Population Table.")

  covariate_label <- c(covariate_label, "Other")

  q <- function(x) paste0("`", x, "`")
  out_cols <- paste(q(outcome_label), collapse = ", ")
  cov_cols <- paste(q(covariate_label), collapse = ", ")
  unit_cols <- paste(q(unit_label), collapse = ", ")
  treat_col <- if (is_causal) q(treatment_label) else NULL

  pre_headers <- paste(
    q(unit_label[1]),
    if (is_causal) paste(q(outcome_label), collapse = ", ") else q(outcome_label),
    if (is_causal) q(treatment_label) else NULL,
    paste(q(covariate_label), collapse = ", "),
    sep = ", "
  )

  pop_headers <- paste(
    "`Source`,", q(unit_label[1]), ",", q(unit_label[2]), ",",
    if (is_causal) paste(q(outcome_label), collapse = ", ") else q(outcome_label), ",",
    if (is_causal) paste0(q(treatment_label), ",") else "",
    cov_cols
  )

  row_fill <- paste(rep('"..."', length(strsplit(pop_headers, ",")[[1]])), collapse = ", ")

  code <- glue::glue('```{{r}}
# Tables to edit:
p_tibble <- tibble::tribble(
  ~{pre_headers},
  {row_fill},
  {row_fill},
  {row_fill}
)

d_tibble <- tibble::tribble(
  ~{pop_headers},
  {row_fill},
  {row_fill},
  {row_fill}
)
````

```{{r}}
# Footnotes to edit:
title_footnote <- "Describe the goal of this analysis and what this table helps us see."
units_footnote <- "Describe the unit of analysis and time period."
outcome_footnote <- "Explain the nature of the outcome(s) and whether this is causal or predictive."
{if (is_causal) 'treatment_footnote <- "Explain what treatment means here and how it’s measured."'}
covariates_footnote <- "List important covariates and how they relate to your data."
```

```{{r}}
# Preceptor Table
p_tibble |>
  gt::gt() |>
  gt::tab_header(title = glue::glue("Preceptor Table: {title}")) |>
  gt::tab_spanner(label = glue::glue("Outcome{if (is_causal) 's' else ''}"), columns = c({out_cols})) |>
  {if (is_causal) glue::glue("gt::tab_spanner(label = 'Treatment', columns = c({treat_col})) |>\n")}\
  gt::tab_spanner(label = "Covariates", columns = c({cov_cols})) |>
  gt::cols_align("center", columns = gt::everything()) |>
  gt::cols_align("left", columns = c({q(unit_label[1])})) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(outcome_footnote, locations = gt::cells_column_spanners(spanners = glue::glue("Outcome{if (is_causal) 's' else ''}"))) |>
  {if (is_causal) 'gt::tab_footnote(treatment_footnote, locations = gt::cells_column_spanners(spanners = "Treatment")) |>'}\
  gt::tab_footnote(covariates_footnote, locations = gt::cells_column_spanners(spanners = "Covariates"))
```

```{{r}}
# Population Table
d_tibble |>
  gt::gt() |>
  gt::tab_header(title = glue::glue("Population Table: {title}")) |>
  gt::tab_spanner(label = "Unit/Time", columns = c({unit_cols})) |>
  gt::tab_spanner(label = glue::glue("Outcome{if (is_causal) 's' else ''}"), columns = c({out_cols})) |>
  {if (is_causal) glue::glue("gt::tab_spanner(label = 'Treatment', columns = c({treat_col})) |>\n")}\
  gt::tab_spanner(label = "Covariates", columns = c({cov_cols})) |>
  gt::cols_align("center", columns = gt::everything()) |>
  gt::cols_align("left", columns = c(`Source`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(units_footnote, locations = gt::cells_column_spanners(spanners = "Unit/Time")) |>
  gt::tab_footnote(outcome_footnote, locations = gt::cells_column_spanners(spanners = glue::glue("Outcome{if (is_causal) 's' else ''}"))) |>
  {if (is_causal) 'gt::tab_footnote(treatment_footnote, locations = gt::cells_column_spanners(spanners = "Treatment")) |>'}\
  gt::tab_footnote(covariates_footnote, locations = gt::cells_column_spanners(spanners = "Covariates"))
```

```{{r}}
# Remove variables
rm(p_tibble, d_tibble,
   title_footnote, units_footnote, outcome_footnote,
   {if (is_causal) "treatment_footnote," else ""} covariates_footnote)
```

')

rstudioapi::insertText(
location = rstudioapi::getActiveDocumentContext()\$selection\[\[1]]\$range,
text = code
)
}

