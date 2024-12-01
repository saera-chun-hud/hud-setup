#' Fixed Random Rounding to Base 3
#'
#' This function performs fixed random rounding of a numeric vector to the nearest multiple of 3.
#' It rounds a number to the nearest number divisible by 3 with 2/3 probability, and to the second nearest multiple with 1/3 probability.
#' If a number is already divisible by 3, it remains unchanged.
#'
#' @param counts A numeric vector of counts to apply frr3.
#' @param key A key (e.g., a character string) used to generate a consistent seed for randomization.
#'
#' @return A numeric vector with values rounded as per fixed random rounding rules.
#'
#' @examples
#' # Apply to a list
#'
#' counts <- c(1:12)
#' key <- "example_key"
#' rounded_counts <- frr3(counts, key)
#'
#' # Apply to a dataframe on all numeric columns
#' require(tidyverse)
#' df_frr3 <- df %>%
#'   mutate(across(where(is.numeric), ~ frr3(., "reporting_month")))


frr3 <- function(counts, key) {

  require(digest)

  # Ensure 1 and 2 are always rounded to 3, not 0
  counts[counts == 1 | counts == 2] <- 3

  # Generate a seed for each count based on the key
  seeds <- sapply(counts, function(x) digest::digest2int(paste0(x, digest::digest2int(as.character(key)))))

  # Pre-allocate random numbers vector
  random_numbers <- numeric(length(counts))

  # Generate random numbers using individual seeds
  for (i in seq_along(counts)) {
    set.seed(seeds[i])
    random_numbers[i] <- runif(1)
  }

  # Find base 3 multiples
  remainder <- counts %% 3
  lower_multiple <- counts - remainder
  upper_multiple <- lower_multiple + 3

  # Calculate distance to multiples
  distance_to_lower <- abs(counts - lower_multiple)
  distance_to_upper <- abs(counts - upper_multiple)

  closest_multiple <- ifelse(distance_to_lower <= distance_to_upper, lower_multiple, upper_multiple)
  second_closest_multiple <- ifelse(distance_to_lower <= distance_to_upper, upper_multiple, lower_multiple)

  # 'Random' rounding to base 3
  rounded_counts <- ifelse(remainder == 0, counts,
                           ifelse(random_numbers <= 2/3, closest_multiple, second_closest_multiple))

  return(rounded_counts)
}
