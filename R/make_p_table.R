#' Create a Preceptor and Population Table Template
#'
#' Inserts five Quarto code blocks into the current document for standardized Preceptor and Population Tables.
#'
#' @param type "predictive" or "causal"
#' @param unit_label Character vector of length 2: unit and time columns
#' @param outcome_label Character vector (1 for predictive, 2+ for causal)
#' @param treatment_label Character. Required if causal.
#' @param covariate_label Character vector (will append "Other")
#' @param title Character. Used in table headers.
#'
#' @export
make_p_table <- function(type = "predictive",
                         unit_label,
                         outcome_label,
                         treatment_label = NULL,
                         covariate_label,
                         title = "Edit Description") {

  is_causal <- startsWith(tolower(type), "c")

  if (length(unit_label) != 2)
    stop("unit_label must have 2 entries: one for unit, one for time.")
  if (!is_causal && length(outcome_label) != 1)
    stop("Predictive tables require one outcome label.")
  if (is_causal && length(outcome_label) < 2)
    stop("Causal tables require multiple outcome labels.")
  if (is_causal && is.null(treatment_label))
    stop("Treatment label is required for causal tables.")

  covariate_label <- c(covariate_label, "Other")

  # Quoted
  q <- function(x) paste0("`", x, "`")
  units_q <- paste(q(unit_label), collapse = ", ")
  out_q <- paste(q(outcome_label), collapse = ", ")
  cov_q <- paste(q(covariate_label), collapse = ", ")
  treat_q <- if (is_causal) q(treatment_label) else NULL

  pre_colnames <- c(q(unit_label[1]), q(outcome_label), if (is_causal) treat_q, q(covariate_label))
  pop_colnames <- c("`Source`", q(unit_label[1]), q(unit_label[2]), q(outcome_label), if (is_causal) treat_q, q(covariate_label))

  pre_header <- paste("~", pre_colnames, collapse = ", ")
  pop_header <- paste("~", pop_colnames, collapse = ", ")

  filler_row <- paste(rep('"..."', length(pre_colnames)), collapse = ", ")
  data_row <- filler_row

  filler_row_pop <- paste(rep('"..."', length(pop_colnames)), collapse = ", ")

  # Code blocks
  code <- glue::glue('
```{{r}}
# Preceptor and Population data (edit these rows)
p_tibble <- tibble::tribble(
  {pre_header},
  {filler_row},
  {data_row},
  {data_row},
  {filler_row}
)

d_tibble <- tibble::tribble(
  {pop_header},
  {filler_row_pop},
  {data_row},
  {data_row},
  {data_row},
  {data_row},
  {filler_row_pop},
  # Preceptor rows:
  {filler_row_pop},
  {data_row},
  {data_row},
  {filler_row_pop}
)
````

```{{r}}
# Footnotes (edit these)
title_footnote <- "Describe what this table helps answer."
units_footnote <- "Describe the units and time variable."
outcome_footnote <- "What do these outcomes represent?"
{if (is_causal) 'treatment_footnote <- "Describe the treatment."'}
covariates_footnote <- "Explain covariates and any key relationships."
```

```{{r}}
# Preceptor Table
p_tibble |>
  gt::gt() |>
  gt::tab_header(title = "Preceptor Table: {title}") |>
  gt::tab_spanner(label = "{if (is_causal) "Potential Outcomes" else "Outcome"}", columns = c({out_q})) |>
  {if (is_causal) glue::glue("gt::tab_spanner(label = 'Treatment', columns = c({treat_q})) |>")}\
  gt::tab_spanner(label = "Covariates", columns = c({cov_q})) |>
  gt::cols_align("center", columns = gt::everything()) |>
  gt::cols_align("left", columns = c({q(unit_label[1])})) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(outcome_footnote, locations = gt::cells_column_spanners(spanners = "{if (is_causal) "Potential Outcomes" else "Outcome"}")) |>
  {if (is_causal) 'gt::tab_footnote(treatment_footnote, locations = gt::cells_column_spanners(spanners = "Treatment")) |>'}\
  gt::tab_footnote(covariates_footnote, locations = gt::cells_column_spanners(spanners = "Covariates"))
```

```{{r}}
# Population Table
d_tibble |>
  gt::gt() |>
  gt::tab_header(title = "Population Table: {title}") |>
  gt::tab_spanner(label = "Unit/Time", columns = c({units_q})) |>
  gt::tab_spanner(label = "{if (is_causal) "Potential Outcomes" else "Outcome"}", columns = c({out_q})) |>
  {if (is_causal) glue::glue("gt::tab_spanner(label = 'Treatment', columns = c({treat_q})) |>")}\
  gt::tab_spanner(label = "Covariates", columns = c({cov_q})) |>
  gt::cols_align("center", columns = gt::everything()) |>
  gt::cols_align("left", columns = c(`Source`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(units_footnote, locations = gt::cells_column_spanners(spanners = "Unit/Time")) |>
  gt::tab_footnote(outcome_footnote, locations = gt::cells_column_spanners(spanners = "{if (is_causal) "Potential Outcomes" else "Outcome"}")) |>
  {if (is_causal) 'gt::tab_footnote(treatment_footnote, locations = gt::cells_column_spanners(spanners = "Treatment")) |>'}\
  gt::tab_footnote(covariates_footnote, locations = gt::cells_column_spanners(spanners = "Covariates"))
```

```{{r}}
# Clean up
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

````

---

### Example Use

# ````
# make_p_table(
#   type = "causal",
#   unit_label = c("Candidate", "Year"),
#   outcome_label = c("Years Lived (Lose)", "Years Lived (Win)"),
#   treatment_label = "Election Result",
#   covariate_label = c("Age", "Win Margin", "Win %", "Party", "Sex"),
#   title = "Potential Years Lived After Election"
# )
# ````
