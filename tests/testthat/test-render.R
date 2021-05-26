library(primer.tutorials)
library(tidyverse)
library(stringr)
library(fs)
library(rprojroot)

# Our definition of "test" for a tutorial file is to run render() and hope there
# is no error. There is no check to see if "tutorial.html" looks OK, just that
# that string is returned.

# Might we do more here? For example, what we really want to confirm is that,
# when a student presses the "Run Document" button, things will work. I am not
# sure if render() is the same thing. But, the good news is that this test seems
# much more robust than that. In other words, it catches things that do not
# cause (immediate) failures with Run Document.

# Testing is tricky! Running "Test Package" does something different than the
# testing which goes on when you click "Check Package." The latter sets up a
# special test installation of the package which does not include, for example,
# the renv directories. Which is good! That is what we want (I think.) Running
# Test Package simply sources the relevant files in tests/. This does not create
# a separate installation. So, if you do that --- with our simple dir_ls() code
# below --- we end up running all the tests twice, once with the tests in the
# main tests/ and once with those copies living in renv.

# I would like this call to fs::dir_ls() to behave the same whether I am using
# Check Package or Test Package. How can I do that? Maybe the here package? Note
# that I need to include the tutorials path explicitly because otherwise, with
# Check Package, we also

files <- fs::dir_ls("../../",
                    recurse = TRUE,
                    regexp = "tutorial.Rmd") %>%
  fs::path_abs()

stopifnot(length(files) > 15)

# print(paste0("The number of test files is ", length(files), ".\n"))
# print(files)

# There are two problems with this list of files. First, it is long! There are a
# lot of tutorials and they take a while to run. There is not a lot to be done
# about that. The second problem is that there is no way to customize it.
# Sometimes, we would just like to test one tutorial, especially while we are
# working on it. Other times, we want to test all the tutorials but one.
# Regardless, we can hand-hack either of those two cases here.

# Case 1. Just assign the directory string, like "02-wrangling-C", to
# tutorial_dir_to_ignore. Set to NULL otherwise.

# tutorial_dir_to_ignore <- "02-wrangling-C"
# 
# if(! is.null(tutorial_dir_to_ignore)){
#   files <- files[! str_detect(files, tutorial_dir_to_ignore)]
# }

# Case 2. Assign files to just the file we want to test. Note that this is a
# total hack! You need to hard code in the full path, which means you need to
# have a sense of your paths. But you only need to change the top 4 levels to
# match your set up. Of course, we really should split the path into two parts,
# with the top portion being automatically created.

# files <- "/Users/davidkane/Desktop/projects/primer.tutorials.Rcheck/primer.tutorials/tutorials/02-wrangling-C/tutorial.Rmd"


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

