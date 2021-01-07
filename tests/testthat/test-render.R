context("Confirm that tutorials can be rendered")
library(primer.tutorials)
library(tidyverse)
library(fs)

# Our definition of "test" for a tutorial file is to run render() and hope there
# is no error. There is no check to see if "tutorial.html" looks OK, just that
# that string is returned.

# Might we do more here? For example, what we really want to confirm is that,
# when a student presses the "Run Document" button, things will work. I am not
# sure if render() is the same thing.

files <- fs::dir_ls("../../",
                    recurse = TRUE,
                    regexp = "tutorial.Rmd") %>%
  fs::path_abs()

stopifnot(length(files) > 15)

# This test is not complete because it does not simulate the scenario in which a
# user runs a tutorial directly. For example, if you forget to include
# library(primer.tutorials) in the code chunk for a tutorial, it will fail for a
# user because it won't find submission_ui. But such a flawed tutorial.Rmd will
# pass this test because we load library(primary.tutorials) before we start the
# test above. Maybe this is just an edge case we can ignore.

for(i in files){
  test_that(paste("rendering", i), {
    expect_output(rmarkdown::render(i, output_file = "tutorial.html"),
                  "tutorial.html")
  })
}

