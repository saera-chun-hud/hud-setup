# Package to help with setting up your script or project  
  
## Installation
You'll need devtools::install_github to install the package:

``` r
# install.packages("devtools")
devtools::install_github("saera-chun-hud/hud-palettes")
``` 
  
## Manage packages and their versions  
  
### `libraries()`  
The `libraries()` function automates the process of installing (if required) and loading a list of specified R packages. It validates versions if needed, ensuring that all dependencies are correctly installed before they are loaded into your environment.  
  
**Parameters:**  
- `packages`: A named list where names are package names and values are their sources (CRAN, github::, or url::).  
  
**Example Usage:**  
```r  
# Define packages with sources  
packages <- list(  
  # Packages from CRAN  
  tidyverse = "CRAN",  
  readxl = "CRAN",  
  writexl = "CRAN",  
  janitor = "CRAN",  
  DBI = "CRAN",  
  odbc = "CRAN",  
  dbplyr = "CRAN",  
  
  # Packages from GitHub  
  hud.keep = "github::hud-govt-nz/hud-keep",  
  
  # Packages from CRAN archive (specific version)  
  dplyr = "url::https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_1.1.3.tar.gz"  
)  
  
# Install and load required packages  
libraries(packages)  
```  

This example demonstrates how to automate the installation and loading of various packages from different sources (CRAN, GitHub, specific versions from URLs) using one streamlined function.  


**Types of Package Installation Available**
1. Packages from CRAN
Simply specify `"CRAN"` as the source.

2. Packages from GitHub
Use the format `"github::username/repo"`.

3. Packages from CRAN Archive (Specific Version)
Use the format `"url::https://path/to/package_version.tar.gz".`

This approach ensures that you can specify any combination of current stable CRAN packages, development versions from GitHub, or specific older versions available on CRAN's archive.


  
### Supporting Functions  
  
#### `install_required_packages()`  
This function checks if a specified package is installed, and if not, it installs the package from CRAN, GitHub, or a specific version from a URL.  
  
**Parameters:**  
- `package_name`: Name of the package to check/install.  
- `source`: Source of the package (CRAN, GitHub repository path using `github::`, or URL to tar.gz file using `url::`).  
  
**Example Usage:**  
```r  
install_required_packages("tidyverse", "CRAN")  
install_required_packages("hud.keep", "github::hud-govt-nz/hud-keep")  
install_required_packages("dplyr", "url::https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_1.1.3.tar.gz")  
```  
  
#### `load_required_packages()`  
This function loads a list of specified packages after ensuring they are correctly installed with their required versions if provided via URL.  
  
**Parameters:**  
- `packages`: A named list where names are package names and values are their sources (CRAN, github::, or url::).  
  

   
## Fixed Random Rounding to Base 3 (frr3)  
   
### Description  
The `frr3` function performs Fixed Random Rounding (FRR) to base 3. It rounds numbers to the nearest multiple of 3 with a 2/3 probability and to the second nearest multiple with a 1/3 probability. If a number is already divisible by 3, it remains unchanged.  
   
### Parameters  
- **counts**: A numeric vector of counts to apply `frr3`.  
- **key**: A key (e.g., a character string) used to generate a consistent seed for randomization.  
   
### Return Value  
- Returns a numeric vector with values rounded according to fixed random rounding rules.  
   
### Usage  
   
#### Basic Usage  
Applying the function to a simple numeric vector:  
   
```r  
# Define counts and key  
counts <- c(1:12)  
key <- "example_key"  
   
# Apply frr3 function  
rounded_counts <- frr3(counts, key)  
   
# Print results  
print(rounded_counts)  
```  
   
#### Data Frame Example  
Applying the function to all numeric columns in a data frame:  
   
```r  
# Load tidyverse for data manipulation functions  
require(tidyverse)  
   
# Create example data frame  
df <- tibble(  
  A = c(1, 2, 4, 5, 6),  
  B = c(7, 8, 9, 10, 11),  
  C = c("x", "y", "z", "w", "v") # non-numeric column  
)  
   
# Apply frr3 function across all numeric columns 
df_frr3 <- df %>%  
  mutate(across(where(is.numeric), ~ frr3(., "C")))  
   
# Print results  
print(df_frr3)  
```
