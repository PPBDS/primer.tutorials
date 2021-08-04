#' @title Store pkgType Global Option in R-Profile
#'
#' @description
#'
#' This is a function that sets the "pkgType" global option
#' to "binary".
#'
#' This sets the default package installation type to binary
#' instead of source because students sometimes accidentally
#' install packages from source.
#'
#' You can examine your .Rprofile to confirm this change with
#' usethis::edit_r_profile()
#'
#' You can examine your .Renviron with usethis::edit_r_environ()
#'
#' @export

install_only_binary_packages <- function(){

  # This function is modeled after the function census_api_key()
  # from the tidycensus package.


  # Get path to user Rprofile and Renviron
  home <- Sys.getenv("HOME")
  rprof <- file.path(home, ".Rprofile")
  renv <- file.path(home, ".Renviron")

  # Create lines to insert
  #
  # Rprofile is an R script ran on init,
  # so I used the options() function to set
  # pkgType to "binary" on init.
  #
  # Renviron is an environment variable file
  # I added an environment variable that tells
  # R where the Rprofile file is.
  #
  # Note: I added these trailing newlines
  # because there is a bug where the .Rprofile script
  # does not run when the .Rprofile file does not
  # end with a trailing newline.

  rprof_line <- "options(pkgType = 'binary')\n"
  renv_line <- paste0("R_PROFILE_USER=", "'", rprof, "'\n")

  # If user already has an .Rprofile, then just append to that file
  # If not, create an .Rprofile in home directory and write to that.
  if (file.exists(rprof)){

    curr_prof <- readr::read_file(rprof)


    # If option already in user's .Rprofile, then just don't write in it

    if (stringr::str_detect(gsub(" ", "", curr_prof), stringr::fixed(gsub(" ", "", rprof_line)))){

      message("Option already in your .Rprofile")

    }else{

      message("Appending new option to your .Rprofile")

      write(paste0(trimws(curr_prof), "\n", rprof_line), file = rprof, append = FALSE)

    }
  }
  if (!file.exists(rprof)){

    message("Creating .Rprofile in your home directory")

    file.create(rprof)

    write(rprof_line, file = rprof, append = TRUE)

  }

  # Make sure only has at most 2 trailing newlines
  # because RStudio has an option that saves environment files
  # with extra newline

  # raw_prof <- readr::read_file(rprof)
  #
  # write(paste0(trimws(raw_prof), "\n"), file = rprof, append = FALSE)



  # If user already has an .Renviron, append to that file
  # If not, create an .Renviron in home directory and write to that

  if(file.exists(renv)){

    curr_env <- readr::read_file(renv)

    # If .Rprofile path already in .Renviron, skip

    if (stringr::str_detect(gsub(" ", "", curr_env), stringr::fixed(gsub(" ", "", renv_line)))){

      message("Rprofile location already in your .Renviron")

    }else{

      message("Appending .Rprofile direction into .Renviron")

      write(paste0(trimws(curr_env), "\n", renv_line), file = renv, append = FALSE)

    }
  }

  if (!file.exists(renv)){
    message("Creating .Renviron in your home directory")

    file.create(renv)

    write(renv_line, file = renv, append = TRUE)
  }

  # Make sure only has at most 2 trailing newlines
  # because RStudio has an option that saves environment files
  # with extra newline

  raw_env <- readr::read_file(renv)

  write(paste0(trimws(raw_env), "\n"), file = renv, append = FALSE)


  # Set pkgType to "binary" for this R session

  options(pkgType = "binary")

  message("You will now only install the binary version of packages")

}
