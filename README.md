
<!-- README is generated from README.Rmd, edit ONLY this file if needed. But, after you edit it, you NEED TO KNIT IT BY HAND in order to create the new README.md, which is the thing which is actually used. -->

# Tutorials for *Preceptor’s Primer for <br/> Bayesian Big Data Science* <img src="man/figures/ulysses_hex_tutorials.png" align = "right"  width="160">

<!-- badges: start -->

[![R build
status](https://github.com/PPBDS/primer.tutorials/workflows/R-CMD-check/badge.svg)](https://github.com/PPBDS/primer.tutorials/actions)
<!-- badges: end -->

## About this package

`primer.tutorials` provides the tutorials used in *[Preceptor’s Primer
for Big Bayesian Data Science](https://ppbds.github.io/primer)*, the
textbook used in [Gov 1005: Big
Data](https://www.davidkane.info/files/gov_1005_spring_2021.html) at
Harvard University.

## Installation

You can install the the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("PPBDS/primer.tutorials")
```

## Using tutorials

In order to access the tutorials, you must first load the package

``` r
library(primer.tutorials)
```

You can access the tutorials via the Tutorial pane in the top right tab
in RStudio. Click “Start tutorial”. If you don’t see any tutorials, try
clicking the “Home” button – the little house symbol with the thin red
roof in the upper right.

 

<img src="man/figures/tutorial_pane.gif" width="75%" style="display: block; margin: auto;" />

 

In order to expand the window, you can drag and enlarge the tutorial
pane inside RStudio. In order to open a pop-up window, click the “Show
in New Window” icon next to the home icon.

You may notice that the Jobs tab in the lower left will create output as
the tutorial is starting up. This is because RStudio is running the code
to create the tutorial. If you accidentally clicked “Start Tutorial” and
would like to stop the job from running, you can click the back arrow in
the Jobs tab, and then press the red stop sign icon.

Your work will be saved between RStudio sessions, meaning that you can
complete a tutorial in multiple sittings. Once you have completed a
tutorial, follow the instructions on the tutorial `Submit` page and (if
you’re a student) upload the resulting file to Canvas.
