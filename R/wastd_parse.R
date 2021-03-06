#' Parse a \code{wastd_api_response} into a tibble
#'
#' \lifecycle{stable}
#'
#' @description From a \code{wastd_api_response}, turn the key \code{payload}
#'   (default: "features") into a \code{tibble:tibble}, and
#'   \code{tidyr::unnest_wider} the tibble into columns equivalent to the fields
#'   of the WAStD API serializer.
#'   If GeoJSON is found, the keys `geometry` (including `coordinates`) will
#'   remain unchanged, but the key `properties` will be unnested.
#' @param wastd_api_response A \code{wastd_api_response} from WAStD
#' @param payload (chr) The name of the key containing the parsed
#'   \code{httr::content()} from the WAStD API call
#' @return A tibble with one row per record and columns corresponding to each
#'   record's fields.
#' @export
#' @family api
wastd_parse <- function(wastd_api_response, payload = "data") {
  out <- wastd_api_response %>%
    magrittr::extract2(payload) %>%
    tibble::tibble() %>%
    tidyr::unnest_wider(".", names_repair = "universal") %>%
    janitor::clean_names()

  if ("geometry" %in% names(out)) {
    out <- out %>%
      # tidyr::unnest_wider("geometry", names_repair = "universal") %>%
      # tidyr::unnest_wider("coordinates", names_repair = "universal") %>%
      tidyr::unnest_wider("properties", names_repair = "universal") %>%
      janitor::clean_names()
  }
  out
}
