#' Convert between url-safe dash-separated-names and Human Readable Title Case
#'
#' \lifecycle{stable}
#'
#' @param urlsafe_string (chr) A url-safe-string
#' @return a Human Readable Title Cased String
#' @export
#' @family helpers
#' @examples
#' humanize("chelonia-mydas")
#' humanize("natator-depressus")
#' humanize("successful-crawl")
humanize <- function(urlsafe_string) {
  urlsafe_string %>%
    stringr::str_to_title(.) %>%
    stringr::str_replace_all("-", " ")
}

# usethis::use_test("humanize")
