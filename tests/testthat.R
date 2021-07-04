library(testthat)
library(tidyverse)
library(learnr)
library(primer.tutorials)

# There are two ways to test files in R. We can use Build -> Test Package. This
# does not build a new tar ball. Instead, it simply sources test/testthat.R. I
# am unsure exactly how this functions. I *think* that a new R instance is
# started, but one with a new .Rprofile, one which does not know about the renv
# library. Instead, it only knows about your default R library. In that case,
# the primer.tutorials which is loaded is the one which is there. But you have
# not updated it! In fact, within the project which uses renv, doing so is
# annoying. (In fact, I am not sure how to do it.) I *think* we should just
# rarely/never use Test Package.

# The second way to test is Build -> Check Package. This does testing the "right
# way," by building the tar ball. From that tarball, I new primer.tutorials is
# installed, and that is the one that is used, which is what we want.  As long
# as we do it this way, then the `learnr:available_tutorials()` trick will work
# correctly, and then we build the path by hand.


package_location <- system.file("tutorials", package = "primer.tutorials")
  
tutorial_paths <- available_tutorials("primer.tutorials") |> 
  mutate(path = paste0(package_location, "/", name, "/tutorial.Rmd")) |>
  pull(path)
  
stopifnot(length(tutorial_paths) > 15)

# We use the tutorial_paths vector in the testing functions which now get run. 

test_check("primer.tutorials")
