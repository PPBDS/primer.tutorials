#' Insert a standardized Preceptor or Population Table template
#'
#' This function creates a five-chunk Quarto-ready template for Preceptor and Population Tables.
#' The output is inserted directly into the current document at the cursor.
#'
#' @param is_causal Logical. If TRUE, generate template for causal analysis; else predictive.
#' @param table_title Character. Title to use for the Population Table.
#' @export

make_p_table <- function(is_causal = TRUE,
                         table_title = "Population Table") {

  # --- Set up optional treatment footnote block ---
  treatment_footnote_line <- if (is_causal) {
    'treatment_footnote <- "Describe the treatment and how it appears in the data."'
  } else {
    ""
  }

  treatment_footnote_block <- if (is_causal) {
    'gt::tab_footnote(treatment_footnote, locations = gt::cells_column_spanners(spanners = "Treatment")) |>'
  } else {
    ""
  }

  # --- Code Chunks ---

  code_footnotes <- glue::glue(
'```{{r}}
# Edit these footnotes after inserting
title_footnote <- "Describe the purpose and what it helps answer."
units_footnote <- "Describe the units and time span."
outcome_footnote <- "Explain why this is predictive or causal, and details about the outcome(s)."
{treatment_footnote_line}
covariates_footnote <- "Describe covariates and how they relate to those in the data."
```')

  code_p_tibble <- glue::glue(
'```{{r}}
p_tibble <- tibble::tribble(
  ~`Candidate`, ~`Years Lived (Lose)`, ~`Years Lived (Win)`, ~`Election Result`, ~`Win Margin`, ~`Age`, ~`Win %`, ~`Party`, ~`Sex`, ~`...`,
  "Joe Smith", "18*", "23", "Win", "7.2", "56", "100%", "Republican", "Male", "...",
  "David Jones", "22", "28*", "Lose", "-3.5", "48", "67%", "Democrat", "Male", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "..."
)
```')

  code_d_tibble <- glue::glue(
'```{{r}}
d_tibble <- tibble::tribble(
  ~`Source`, ~`Candidate`, ~`Year`, ~`Years Lived (Lose)`, ~`Years Lived (Win)`, ~`Election Result`, ~`Win Margin`, ~`Age`, ~`Win %`, ~`Party`, ~`Sex`, ~`...`,
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "Data", "Earl Warren", "1946", "18*", "23", "Win", "7.2", "56", "100%", "Republican", "Male", "...",
  "Data", "George Wallace", "1946", "22", "28*", "Lose", "-3.5", "48", "67%", "Democrat", "Male", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...",
  "Preceptor Table", "Joe Smith", "2025", "18*", "23", "Win", "7.2", "56", "100%", "Republican", "Male", "...",
  "Preceptor Table", "David Jones", "2025", "22", "28*", "Lose", "-3.5", "48", "67%", "Democrat", "Male", "...",
  "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "..."
)
```')

  code_p_table <- glue::glue(
'```{{r}}
# Render Preceptor Table
gt::gt(data = p_tibble) |>
  gt::tab_header(title = "Preceptor Table") |>
  gt::tab_spanner(label = "Potential Outcomes", columns = c(`Years Lived (Lose)`, `Years Lived (Win)`)) |>
  gt::tab_spanner(label = "Treatment", columns = c(`Election Result`)) |>
  gt::tab_spanner(label = "Covariates", columns = c(`Win Margin`, `Age`, `Win %`, `Party`, `Sex`, `...`)) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`Candidate`)) |>
  gt::fmt_markdown(columns = gt::everything())
```')

  code_pop_table <- glue::glue(
'```{{r}}
# Render Population Table
gt::gt(data = d_tibble) |>
  gt::tab_header(title = "{table_title}") |>
  gt::tab_spanner(label = "Units/Time", columns = c(`Candidate`, `Year`)) |>
  gt::tab_spanner(label = "Potential Outcomes", columns = c(`Years Lived (Lose)`, `Years Lived (Win)`)) |>
  gt::tab_spanner(label = "Treatment", columns = c(`Election Result`)) |>
  gt::tab_spanner(label = "Covariates", columns = c(`Win Margin`, `Age`, `Win %`, `Party`, `Sex`, `...`)) |>
  gt::cols_align(align = "center", columns = gt::everything()) |>
  gt::cols_align(align = "left", columns = c(`Source`)) |>
  gt::fmt_markdown(columns = gt::everything()) |>
  gt::tab_footnote(title_footnote, locations = gt::cells_title("title")) |>
  gt::tab_footnote(units_footnote, locations = gt::cells_column_spanners(spanners = "Units/Time")) |>
  gt::tab_footnote(outcome_footnote, locations = gt::cells_column_spanners(spanners = "Potential Outcomes")) |>
  {treatment_footnote_block}
  gt::tab_footnote(covariates_footnote, locations = gt::cells_column_spanners(spanners = "Covariates"))
```')

  code_cleanup <- glue::glue(
'```{{r}}
# Cleanup temporary variables
rm(p_tibble, d_tibble)
```')

  # --- Combine and insert into Quarto/Rmd ---
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
