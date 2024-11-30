#' Libraries
#'
#' This function will install (if required), then load a list of packages and validates their versions if specified.
#'
#' @param packages A named list where names are package names and values are their sources (CRAN, github::, or url::).


libraries <- function(packages) {

  ## check for installation
  for (pkg in names(packages)) {
    install_required_packages(pkg, packages[[pkg]])
  }

  ## load libraries
  list_packages(packages)

}
