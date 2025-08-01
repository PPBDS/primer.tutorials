# Insert a standardized Preceptor or Population Table template
#
# This function generates five editable code chunks:
# 1. Data entry for Preceptor and Population (d_tibble, p_tibble)
# 2. Footnotes to be edited
# 3. Preceptor Table generation
# 4. Population Table generation
# 5. Variable cleanup
#
# The generated tables follow standard formatting guidelines and can be used in
# Quarto or R Markdown documents. Population Tables will automatically include
# Preceptor rows within them.
#
# @param table Character. "preceptor" or "population" (partial match allowed).
# @param type Character. "predictive" or "causal" (partial match allowed).
# @param unit_label Length 1 or 2 character vector. If population, must be c(unit, time).
# @param outcome_label Character vector. One outcome for predictive; 2+ for causal.
# @param treatment_label Optional character. Required if causal.
# @param covariate_label Character vector. Will always include a final "...".
# @param num_rows Integer. Number of main data rows (excluding filler ... rows).
#
# @export
make_p_table <- function(table = "preceptor",
                         type = "predictive",
                         unit_label = NULL,
                         outcome_label = NULL,
                         treatment_label = NULL,
                         covariate_label = NULL,
                         num_rows = NULL) {

  table <- tolower(substr(table, 1, 3))
  type <- tolower(substr(type, 1, 3))
  is_preceptor <- startsWith(table, "pre")
  is_causal <- startsWith(type, "cau")

  if (is.null(num_rows)) num_rows <- if (is_preceptor) 3 else 4

  if (is_preceptor && length(unit_label) != 1)
    stop("Preceptor tables require a single unit label.")
  if (!is_preceptor && length(unit_label) != 2)
    stop("Population tables require unit and time labels.")

  if (is_causal && length(outcome_label) < 2)
    stop("Causal tables require multiple potential outcomes.")
  if (!is_causal && length(outcome_label) != 1)
    stop("Predictive tables require one outcome.")

  if (is_causal && is.null(treatment_label))
    stop("Treatment label required for causal tables.")

  if (is.null(covariate_label)) covariate_label <- c("Covariate 1", "Covariate 2")
  covariate_label <- c(covariate_label, "...")

  # Build headers
  pre_header <- c(paste0("~`", unit_label, "`"), paste0("~`", outcome_label, "`"))
  if (is_causal) pre_header <- c(pre_header, paste0("~`", treatment_label, "`"))
  pre_header <- c(pre_header, paste0("~`", covariate_label, "`"))
  pre_header <- paste(pre_header, collapse = ", ")

  pop_header <- c("~`Source`", paste0("~`", unit_label, "`"), paste0("~`", outcome_label, "`"))
  if (is_causal) pop_header <- c(pop_header, paste0("~`", treatment_label, "`"))
  pop_header <- c(pop_header, paste0("~`", covariate_label, "`"))
  pop_header <- paste(pop_header, collapse = ", ")

  # Repeated row
  data_row <- paste(rep('"..."', length(c(unit_label, outcome_label, covariate_label)) + 1 + is_causal + !is_preceptor), collapse = ", ")
  filler_row <- data_row

  # Footnotes block
  footnote_chunk <- if (is_causal) {
    '```{r}
# Footnotes (edit these)
title_footnote <- "Describe what this table helps answer."
units_footnote <- "Describe the units and time variable."
outcome_footnote <- "What do these outcomes represent?"
treatment_footnote <- "Describe the treatment."
covariates_footnote <- "Explain covariates and any key relationships."
```
'
  } else {
    '```{r}
# Footnotes (edit these)
title_footnote <- "Describe what this table helps answer."
units_footnote <- "Describe the units and time variable."
outcome_footnote <- "What do these outcomes represent?"
covariates_footnote <- "Explain covariates and any key relationships."
```
'
  }

  # Create full code block
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
  {filler_row},
  {data_row},
  {data_row},
  {data_row},
  {data_row},
  {filler_row},
  {filler_row},
  {data_row},
  {data_row},
  {filler_row}
)
```

{footnote_chunk}

```{{r}}
# Preceptor Table
p_tibble |>
  gt::gt() |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "{if (is_preceptor) "Units" else "Units/Time"}", columns = c({paste0("`", unit_label, "`", collapse = ", ")})) |>
  gt::tab_spanner(label = "{if (is_causal) "Potential Outcomes" else "Outcome"}", columns = c({paste0("`", outcome_label, "`", collapse = ", ")})) |>
  {if (is_causal) glue::glue("gt::tab_spanner(label = \"Treatment\", columns = c(`{treatment_label}`)) |>") else ""}
  gt::tab_spanner(label = "Covariates", columns = c({paste0("`", covariate_label, "`", collapse = ", ")})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`{unit_label[1]}`)) |>
  gt::fmt_markdown(columns = gt::everything())
```

```{{r}}
# Population Table
d_tibble |>
  gt::gt() |>
  gt::tab_header(title = "Population Table") |>
  gt::tab_spanner(label = "Units/Time", columns = c({paste0("`", unit_label, "`", collapse = ", ")})) |>
  gt::tab_spanner(label = "{if (is_causal) "Potential Outcomes" else "Outcome"}", columns = c({paste0("`", outcome_label, "`", collapse = ", ")})) |>
  {if (is_causal) glue::glue("gt::tab_spanner(label = \"Treatment\", columns = c(`{treatment_label}`)) |>") else ""}
  gt::tab_spanner(label = "Covariates", columns = c({paste0("`", covariate_label, "`", collapse = ", ")})) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`Source`)) |>
  gt::fmt_markdown(columns = gt::everything())
```

```{{r}}
# Cleanup
rm(p_tibble, d_tibble)
```
')

  rstudioapi::insertText(
    location = rstudioapi::getActiveDocumentContext()$selection[[1]]$range,
    text = code
  )
}
