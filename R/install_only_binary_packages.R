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
#' @export

install_only_binary_packages <- function(){
  home <- Sys.getenv("HOME")
  rprof <- file.path(home, ".Rprofile")

  line <- 'options(pkgType="binary")\n'

  if (file.exists(rprof)){
    message("Appending new option to your .Rprofile")

    if (gsub(" ", "", line) %in% gsub(" ", "", readr::read_file(rprof))){

      return("Option already in your .Rprofile")

    }else{

      write(line, file = rprof, append = TRUE)

    }
  }
  if (!file.exists(rprof)){

    message("Creating .Rprofile in your home directory")

    file.create(rprof)

    write(line, file = rprof, append = TRUE)

  }

  options(pkgType = "binary")

  return("You will now only install the binary version of packages")

}
