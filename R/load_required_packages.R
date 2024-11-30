#' Load Required Packages
#'
#' This function loads a list of packages and checks their versions if specified.
#'
#' @param packages A named list where names are package names and values are their sources (CRAN, github::, or url::).


load_required_packages <- function(packages) {
  installed_pkgs <- installed.packages()[, "Package"]

  # Check packages not installed
  installed_not <- names(packages)[!(names(packages) %in% installed_pkgs)]

  # Function to extract version from URL
  extract_version_from_url <- function(url) {
    sub(".*_(.*).tar.gz", "\\1", basename(url))
  }

  # Check for correct versions in URL-specified packages
  for (pkg in names(packages)) {
    if (grepl("^url::", packages[[pkg]])) {
      url_version <- extract_version_from_url(sub("url::", "", packages[[pkg]]))

      if (pkg %in% installed_pkgs) {
        installed_version <- as.character(packageVersion(pkg))

        if (installed_version != url_version) {
          installed_diffversion <- c(pkg)
        }
      } else {
        installed_not <- c(installed_not, pkg)
      }
    }
  }


  ## Get correctly installed packages
  installed_correctly <- setdiff(unlist(installed_pkgs[names(packages)]),installed_diffversion)
  installed_correctly <- installed_correctly[!is.na(installed_correctly)]


  ## function to load quietly
  load_package_quietly <- function(pkg) {
    suppressWarnings(suppressMessages(
      library(pkg, character.only = TRUE)
    ))
  }


  ## Load all packages in the list quietly
  lapply(installed_correctly, load_package_quietly)
  cli::cli_alert_success("Packages successfully loaded: {.strong {installed_correctly}}")

  lapply(installed_diffversion, load_package_quietly)
  cli::cli_alert_info("Packages loaded but not the specified version: {.strong {installed_diffversion}}")

  cli::cli_alert_danger("Packages not loaded: {.strong {installed_not}}")
}
