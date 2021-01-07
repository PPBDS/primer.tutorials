context("Confirm Information and Submission sections are correct")

library(primer.tutorials)
library(tidyverse)
library(fs)

# "../../inst"

starting_place <- system.file(package = "primer.tutorials")

files <- fs::dir_ls(starting_place,
                    recurse = TRUE,
                    regexp = "tutorial.Rmd") %>%
  fs::path_abs()

stopifnot(length(files) > 15)

# Goal is to make sure that each tutorial includes the required Information and
# Submission sections. Unfortunately, I could not figure out how to check that a
# multiple-line chunk of code is present in a file.

# So, instead, we will read in the Information and Submission section templates
# with readLines(), which puts each line as a separate item in a text vector.
# Then we can confirm that all those lines are in each tutorial. Note that this
# does not confirm that they are all together and in the correct order! But it
# is good enough.

information_lines <- readLines(
  paste0(system.file("www/", package = "primer.tutorials"),
         "information_check.txt"))

for(i in files){
  if(! all(information_lines %in% readLines(i))){
    stop("Information lines missing from file ", i, "\n")
  }
}

submission_lines <- readLines(
  paste0(system.file("www/", package = "primer.tutorials"),
         "submission_check.txt"))

for(i in files){
  if(! all(submission_lines %in% readLines(i))){
    stop("Submission lines missing from file ", i, "\n")
  }
}

