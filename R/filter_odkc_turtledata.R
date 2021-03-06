#' Filter odkc_data to a given area_name.
#'
#' @param data (list) The output of data("odkc_data"), a list of tibbles and sf
#' @param area_name (chr) The name of the area to filter the data by. Options:
#'   * NULL (default): do not filter data, return unfiltered data.
#'   * "All turtle programs": do not filter data, return unfiltered data.
#'   * "Other": Filter data to area_name NA.
#'   * Any name in `unique(odkc_data$areas$area_name)`: return data filtered to
#'     this area_name.
#' @template param-verbose
#' @return (list) The input data, optionally filtered to a subset of records.
#' @export
#' @family odkc
#' @examples
#' data(odkc_data)
#'
#' # All data
#' data_all <- filter_odkc_turtledata(odkc_data)
#' nrow(data_all$tracks)
#'
#' # One area
#' area_names <- unique(odkc_data$areas$area_name)
#' area_names
#' data_area_1 <- filter_odkc_turtledata(odkc_data, area_name = "Cape Dommett")
#' nrow(data_area_1$tracks)
#' data_area_2 <- filter_odkc_turtledata(odkc_data, area_name = area_names[[2]])
#' nrow(data_area_2$tracks)
#'
#'
#' # Orphans
#' data_orphans <- filter_odkc_turtledata(odkc_data, area_name = "Other")
#' nrow(data_orphans)
filter_odkc_turtledata <- function(data,
                                   area_name = NULL,
                                   verbose = wastdr::get_wastdr_verbose()) {
  requireNamespace("sf") # overrides dplyr::filter with spatial equivalents

  # Error handling
  if (class(data) != "odkc_turtledata") {
    wastdr_msg_abort(
      glue::glue(
        "The first argument needs to be an object of class \"odkc_turtledata\", ",
        "e.g. the output of wastdr::download_odkc_turtledata_2020()."
      )
    )
  }

  if (is.null(area_name)) {
    "No area_name name given, returning all data." %>%
      wastdr::wastdr_msg_success(verbose = verbose)
    return(data)
  }

  if (area_name == "All turtle programs") {
    "All areas requested, returning all data." %>%
      wastdr::wastdr_msg_success(verbose = verbose)
    return(data)
  }

  if (area_name == "Other") {
    "Orphaned areas requested, returning data outside known areas." %>%
      wastdr::wastdr_msg_success(verbose = verbose)
    my_filter <- . %>% dplyr::filter(is.na(area_name))
  } else {
    "Area {area_name} requested, returning filtered data." %>%
      glue::glue() %>%
      wastdr::wastdr_msg_success(verbose = verbose)
    my_filter <- . %>% dplyr::filter(area_name == !!area_name)
  }

  structure(
    list(
      downloaded_on = data$downloaded_on,
      tracks = data$tracks %>% my_filter(),
      # tracks_gj = data$tracks %>% my_filter() %>% ts_gj(),
      tracks_dist = data$tracks_dist %>% my_filter(),
      tracks_log = data$tracks_log %>% my_filter(),
      tracks_egg = data$tracks_egg %>% my_filter(),
      tracks_hatch = data$tracks_hatch %>% my_filter(),
      tracks_fan_outlier = data$tracks_fan_outlier %>% my_filter(),
      track_tally = data$track_tally %>% my_filter(),
      dist = data$dist %>% my_filter(),
      mwi = data$mwi %>% my_filter(),
      mwi_dmg = data$mwi_dmg %>% my_filter(),
      mwi_tag = data$mwi_tag %>% my_filter(),
      tsi = data$tsi %>% my_filter(),
      svs = data$svs %>% my_filter(),
      sve = data$sve %>% my_filter(),
      sites = data$sites %>% my_filter(),
      areas = data$areas
    ),
    class = "odkc_data"
  )
}

# usethis::use_test("filter_odkc_turtledata")
