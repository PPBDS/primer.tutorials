#' @keywords internal
"_PACKAGE"


# Was able to resolve R CMD check import note by doing stuff with these
# packages. Note that it needs to be inside of a function definition for the
# build to recognize it. Seems hacky!

function_for_import  <- function()
{
  temp <- tutorial.helpers::return_tutorial_paths('learnr')
  z <- primer.data::trains
  

}

# Best way to demonstrate these packages are actually "used", thereby stopping
# renv::status() from bothering us.

library(quarto)
library(katex)

## usethis namespace: start
## usethis namespace: end
NULL
