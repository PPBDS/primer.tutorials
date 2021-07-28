library(learnr)
library(primer.tutorials)
library(tidyverse)

format_tutorial_paths <- Sys.glob("addin_test_inputs/format*")

for (i in seq_along(format_tutorial_paths)){

  test_doc <- primer.tutorials::format_tutorial(paste0("addin_test_inputs/format_input_", i, ".Rmd"))

  output_doc <- readr::read_file(paste0("addin_test_outputs/format_output_", i, ".Rmd"))

  if (trimws(test_doc) != trimws(output_doc)){

    stop("From test-addins.R. Format Chunk Label addin failed on test ", i, "\n")

  }
}



