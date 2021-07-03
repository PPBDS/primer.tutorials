library(testthat)
library(tidyverse)
library(learnr)
library(primer.tutorials)


# This is where we put function definitions for functions that are used in the
# tests. Or does this belong elsewhere? 

# For now, we only have one function. It returns a character vector with the
# paths to all the tutorials in primer.tutorials.

tutorial_paths <- function(){
  package_location <- system.file("tutorials", package = "primer.tutorials")
  
  
  paths <- available_tutorials("primer.tutorials") %>% 
    mutate(path = paste0(package_location, "/", name, "/tutorial.Rmd")) |>
    pull(path)
  
  stopifnot(length(paths) > 15)
  
  paths
}

test_check("primer.tutorials")
