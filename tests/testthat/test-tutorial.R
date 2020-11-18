# Any code in a tutorial code chunk, including in a hint, which produces an
# error when run on its own will cause an error if you use R CMD check. Most
# common example is when you have ... to indicate to the student that they
# should replace the ... with something. Best solution is to set eval=FALSE in
# all hint chunks like this. But the same warning applies for all chunks.

# Testing is hard. There are (at least) two different environments in which we
# run tests. First, and most important, is when we run R CMD check. This is the
# most rigorous check. Most importantly, it seems to require that code written
# in all code chunks work correctly. So, you can't just have things like
# library(...) around, even though that is an extremely convenient way to
# indicate to the student that they need to use the library function with some
# argument. The second environment is when you press "Test Package". I think
# that all this does is to source tests/testthat.R. (And this environment is
# (mostly) the same as when you just execute tests interactively. At least, the
# two give the same answer.) But, in this second case, the code in hint (all?)
# chunks is not evaluated.

# Side note: Because we use the system.package hack, we are only ever testing
# the tutorials which are already installed. If you make a change in a file, you
# need to reinstall the whole package before running an interactive test. Also,
# keep in mind:

# First, we have the problem of finding all the Rmd files which we want to test.
# The **fs** approach here works, but is it best?

# Second, once you know where the Rmd file is, you have to "test" it somehow. As
# you can see, our definition of "test" is to run render() and hope there is no
# error. There is no check to see if "tutorial.html" looks OK, just that that
# string is returned.

# Third, might we do more here? For example, what we really want to confirm is
# that, when a student presses the "Run Document" button, things will work. I am
# not sure if render() is the same thing.

context("Tutorials")
library(PPBDS.data)
library(fs)

base <- system.file(package = "PPBDS.data", ".")

files <- dir_ls(base, recurse = TRUE, regexp = "tutorial.Rmd") %>%
            path_abs()

stopifnot(length(files) > 3)

# You can choose to run just a few of the portfolios through by selecting a
# subset of files, like `files <- files[c(2)]` or `files <- files[c(1, 3:9)]`.
# But I am not sure if that really works. For example, it seems like I could get
# just file 2 to work or just all the other files to work but 2. Yet, whenever I
# did them all, I got errors (all from within file 2). Not sure what to make of
# this, other than that perhaps I should explore the new version of testthat.

for(i in files){
  test_that(paste("rendering", i), {
    expect_output(rmarkdown::render(i, output_file = "tutorial.html"),
                  "tutorial.html")
  })
}
