#' Install Required Packages
#'
#' This function checks if a specified package is installed and its version, and installs it if necessary.
#'
#' @param package_name The name of the package to check/install.
#' @param source The source of the package (CRAN, github::, or url:: for specific version).
#'
#' @examples
#' install_required_packages("tidyverse", "CRAN")
#' install_required_packages("hud.keep", "github::hud-govt-nz/hud-keep")
#' install_required_packages("dplyr", "url::https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_1.1.3.tar.gz")


install_required_packages <- function(package_name, source) {

  # first check for cli
  if (!requireNamespace("cli", quietly = TRUE)) {
    message("CRAN package cli is not installed. Installing now...")
    install.packages("cli")
    if (!requireNamespace("cli")) {
      message(paste(
        "Installation of CRAN Package devtools failed"
      ))
    }
  }


  ## check if CRAN packages are installed. If not, install
  if (grepl("CRAN", source) &&
      requireNamespace(package_name, quietly = TRUE)) {
    package_version <- as.character(packageVersion(package_name))
    cli::cli_alert_success("CRAN package {.strong {package_name}} is installed. Version: {.strong {package_version}}")
  } else if (grepl("CRAN", source) &&
             !requireNamespace(package_name, quietly = TRUE)) {
    cli::cli_alert_info("CRAN package {.strong {package_name}} is not installed. Installing now...")
    install.packages(package_name)
    if (!requireNamespace(package_name)) {
      cli::cli_alert_danger("Installation of CRAN package {.strong {package_name}} failed")
    }
  }


  ## Check if GitHub packages are installed. If not, install
  else if (grepl("github::", source)) {
    github_repo <- sub("github::", "", source)

    # first check for devtools
    if (!requireNamespace("devtools", quietly = TRUE)) {
      cli::cli_alert_info("CRAN package {.strong devtools} is not installed. Installing now...")
      install.packages("devtools")
      if (!requireNamespace("devtools")) {
        cli::cli_alert_danger("Installation of CRAN package {.strong devtools} failed")
      }
    }

    if (requireNamespace(package_name, quietly = TRUE)) {
      package_version <- as.character(packageVersion(package_name))
      cli::cli_alert_success("Github package {.strong {package_name}} is installed. Version: {.strong {package_version}}")
    } else {
      cli::cli_alert_info("Github package {.strong {package_name}} is not installed. Installing now...")
      devtools::install_github(github_repo)
      if (!requireNamespace(package_name)) {
        cli::cli_alert_danger("Installation of Github package {.strong {package_name}} failed")
      }
    }
  }


  ## Check if specified version of CRAN packages are installed. If not, install
  else if (grepl("url::", source)) {
    sv_url <- gsub("url::", "", source)
    specified_version <- gsub(".*_([0-9.]+)\\.tar\\.gz", "\\1", sv_url)

    if (requireNamespace(package_name, quietly = TRUE)) {
      package_version <- as.character(packageVersion(package_name))

      if (package_version == specified_version) {
        cli::cli_alert_success("Github package {.strong {package_name}} is installed with the correction version.
                               Version: {.strong {package_version}}")
      } else {
        cli::cli_alert_info("Installed version of {.strong {package_name}} is {.strong {package_version}}.
                            Required version : {.strong {specified_version}}. Installing the specified version now...")
        install.packages(sv_url, repos = NULL, type = "source")
        package_version2 <- as.character(packageVersion(package_name))
        if (package_version2 != specified_version) {
          cli::cli_alert_danger("Installation of CRAN package {.strong {package_name}} for the specified version failed")
        }
      }

    } else {
      cli::cli_alert_info("CRAN package {.strong {package_name}} is not installed. Installing the specified version now...")
      install.packages(sv_url, repos = NULL, type = "source")
      package_version2 <- as.character(packageVersion(package_name))
      if (package_version2 != specified_version) {
        cli::cli_alert_danger("Installation of CRAN package {.strong {package_name}} for the specified version failed")
      }
    }
  }
}
