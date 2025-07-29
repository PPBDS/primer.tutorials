#' Insert a standardized Preceptor or Population Table template
#'
#' @param table Character. Either "preceptor" or "population" (partial match allowed).
#' @param type Character. Either "predictive" or "causal" (partial match allowed).
#'
#' @export 
make_p_table <- function(table = "preceptor", type = "predictive") {
  table <- tolower(match.arg(table, c("preceptor", "population")))
  type <- tolower(match.arg(type, c("predictive", "causal")))

  is_preceptor <- startsWith(table, "p")
  is_causal <- startsWith(type, "c")

  title_base <- if (is_preceptor) "Preceptor Table:" else "Population Table:"
  outcome_label <- if (is_causal) "Potential Outcomes" else "Outcome"
  outcome_cols <- if (is_causal) {
    "`Outcome if Control`, `Outcome if Treated`"
  } else {
    "`Predicted Outcome`"
  }
  treatment_col <- if (is_causal) ", `Treatment`" else ""
  treatment_spanner <- if (is_causal) {
    '  tab_spanner(label = "Treatment", columns = c(`Treatment`)) |>\n'
  } else {
    ""
  }
  footnote <- if (is_causal) {
    '  tab_footnote(\n    footnote = md("A * indicates a potential outcome which we do not observe."),\n    locations = cells_column_spanners(spanners = "Potential Outcomes")\n  )'
  } else {
    ""
  }

  source_col <- if (!is_preceptor) "`Source`, " else ""
  units_spanner <- if (is_preceptor) "Units" else "Units/Time"
  unit_cols <- if (is_preceptor) "`ID`" else "`Year`, `ID`"
  align_left <- if (is_preceptor) "`ID`" else "`Source`"

  code <- glue::glue(
'```{{r}}
# Edit or add values to each row in the table below
tribble(
  ~{source_col}~`Year`, ~`ID`, ~{outcome_cols}{treatment_col}, ~`Covariate 1`, ~`Covariate 2`, ~`...`,  # Change column labels as needed
  "...", "...", "...", "...", "...", "...", "..."  # Replace placeholder values with actual ones
) |>
  gt() |>
  tab_header(title = "{title_base} [Edit Description]") |>  # Edit table title to describe units and time
  tab_spanner(label = "{units_spanner}", columns = c({unit_cols})) |>  # Don't edit unless unit vars change
  tab_spanner(label = "{outcome_label}", columns = c({outcome_cols})) |>  # Outcome or potential outcomes
{treatment_spanner}  tab_spanner(label = "Covariates", columns = c(`Covariate 1`, `Covariate 2`, `...`)) |>  # Edit covariate labels as needed
  cols_align(align = "center", columns = everything()) |>
  cols_align(align = "left", columns = c({align_left})) |>
  fmt_markdown(columns = everything()) |>
{footnote}
```'
  )

  rstudioapi::insertText(
    location = rstudioapi::getActiveDocumentContext()$selection[[1]]$range,
    text = code
  )
}
