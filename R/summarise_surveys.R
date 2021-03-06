#' Return the number of surveys for a given site_id and season
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @param sid The ID of a site, e.g. 22
#' @param seas The season as integer, e.g. 2018
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' one_season <- unique(wastd_data$surveys$season)[1]
#' one_site_id <- unique(wastd_data$surveys$site_id)[1]
#' survey_count(wastd_data$surveys, one_site_id, one_season)
survey_count <- function(surveys, sid, seas) {
  surveys %>%
    dplyr::filter(site_id == sid, season == seas) %>%
    nrow()
}

#' Return the number of surveys for a given site_id and season
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @param sid The ID of a site, e.g. 22
#' @param kms The numbers of kilometers covered in a survey, e.g. 1.6
#' @param seas The season as integer, e.g. 2018
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' one_season <- unique(wastd_data$surveys$season)[1]
#' one_site_id <- unique(wastd_data$surveys$site_id)[1]
#' some_kms <- 10
#' survey_ground_covered(wastd_data$surveys, one_site_id, some_kms, one_season)
survey_ground_covered <- function(surveys, sid, kms, seas) {
  survey_count(surveys, sid, seas) * kms
}


#' Count number of surveys per season, turtle date and site_name from the output
#' of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @return A tibble with columns season, turtle_date, site_name, n
#' (number of surveys)
#' @export
#' @family wastd
#' @examples
#' data("wastd_data")
#' surveys_per_site_name_and_date(wastd_data$surveys)
surveys_per_site_name_and_date <- function(surveys) {
  surveys %>%
    dplyr::group_by(season, turtle_date, site_name) %>%
    dplyr::tally() %>%
    dplyr::ungroup()
}

#' Sum the hours surveyed per site_name and date from the output of
#' \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @return A tibble with columns season, turtle_date, site_name, hours_surveyed
#' @export
#' @family wastd
survey_hours_per_site_name_and_date <- function(surveys) {
  surveys %>%
    dplyr::group_by(season, turtle_date, site_name) %>%
    dplyr::tally(duration_hours) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(hours_surveyed = round(n)) %>%
    dplyr::select(-n)
}

#' Sum the hours surveyed per person by season from the output of
#' \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @return A tibble with columns reporter, season, hours_surveyed,
#' sorted by most to fewest hours.
#' @export
#' @family wastd
survey_hours_per_person <- function(surveys) {
  surveys %>%
    dplyr::group_by(season, reporter) %>%
    tally(duration_hours) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(hours_surveyed = round(n)) %>%
    dplyr::select(-n) %>%
    dplyr::arrange(desc(hours_surveyed))
}

#' Create a table of survey counts from the output of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @param placename (string) The place name, used in labels. Default: ""
#' @export
#' @family wastd
list_survey_count <- function(surveys, placename = "") {
  surveys %>%
    surveys_per_site_name_and_date() %>%
    reactable::reactable(filterable = TRUE, sortable = TRUE)
}

#' Plot the surveyed hours from the output of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @param placename (string) The place name, used in labels. Default: ""
#' @param prefix (string) A prefix for the filename. Default: ""
#' @export
#' @family wastd
plot_survey_count <-
  function(surveys,
           placename = "",
           prefix = "") {
    surveys %>%
      surveys_per_site_name_and_date() %>%
      ggplot2::ggplot(
        .,
        ggplot2::aes(turtle_date,
          site_name,
          fill = n
        )
      ) +
      ggplot2::geom_raster() +
      ggplot2::facet_grid(rows = ggplot2::vars(season)) +
      ggplot2::theme_classic() +
      ggplot2::ggtitle(glue::glue("Survey Count {placename}")) +
      ggplot2::labs(x = "Turtle date", y = "", fill = "Number of surveys") +
      ggplot2::ggsave(
        filename = glue::glue("{prefix}_survey_count_{urlize(placename)}.png"),
        width = 10,
        height = 6
      )
  }

#' Create a table from the surveyed hours from the output of
#' \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @param placename (string) The place name, used in labels. Default: ""
#' @export
#' @family wastd
list_survey_effort <- function(surveys, placename = "") {
  surveys %>%
    survey_hours_per_site_name_and_date() %>%
    reactable::reactable(filterable = TRUE, sortable = TRUE)
}

#' Plot the surveyed hours from the output of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @template param-placename
#' @template param-prefix
#' @export
#' @family wastd
plot_survey_effort <-
  function(surveys,
           placename = "",
           prefix = "") {
    surveys %>%
      survey_hours_per_site_name_and_date() %>%
      ggplot2::ggplot(
        .,
        ggplot2::aes(turtle_date,
          site_name,
          fill = hours_surveyed
        )
      ) +
      ggplot2::geom_raster() +
      ggplot2::facet_grid(rows = ggplot2::vars(season)) +
      ggplot2::scale_x_date(
        breaks = scales::pretty_breaks(),
        labels = scales::date_format("%d %b %Y")
      ) +
      ggplot2::theme_classic() +
      ggplot2::ggtitle(glue::glue("Survey Effort {placename}")) +
      ggplot2::labs(x = "Turtle date", y = "", fill = "Hours surveyed") +
      ggplot2::ggsave(
        filename = glue::glue("{prefix}_survey_effort_{urlize(placename)}.png"),
        width = 10,
        height = 6
      )
  }

#' Plot the surveyed hours from the output of \code{parse_surveys} as heatmap
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @template param-placename
#' @template param-prefix
#' @export
#' @family wastd
survey_hours_heatmap <-
  function(surveys,
           placename = "",
           prefix = "") {
    surveys %>%
      wastdr::survey_hours_per_site_name_and_date(.) %>%
      ggTimeSeries::ggplot_calendar_heatmap("turtle_date", "hours_surveyed") +
      ggplot2::scale_fill_continuous(low = "green", high = "red") +
      ggplot2::facet_grid(rows = ggplot2::vars(Year)) +
      ggplot2::ggtitle(glue::glue("Survey effort at {placename}")) +
      ggplot2::xlab(NULL) + ggplot2::ylab(NULL) +
      ggplot2::theme_classic() +
      ggplot2::ggsave(
        glue::glue(
          "{prefix}_survey_hours_heatmap_{wastdr::urlize(placename)}.png"
        ),
        width = 10,
        height = 6
      )
  }

#' Plot the survey count from the output of \code{parse_surveys} as heatmap
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @template param-placename
#' @template param-prefix
#' @export
#' @family wastd
survey_count_heatmap <-
  function(surveys,
           placename = "",
           prefix = "") {
    surveys %>%
      wastdr::surveys_per_site_name_and_date(.) %>%
      ggTimeSeries::ggplot_calendar_heatmap("turtle_date", "n") +
      ggplot2::scale_fill_continuous(low = "green", high = "red") +
      ggplot2::facet_grid(rows = ggplot2::vars(Year)) +
      ggplot2::ggtitle(glue::glue("Survey effort at {placename}")) +
      ggplot2::xlab(NULL) + ggplot2::ylab(NULL) +
      ggplot2::theme_classic() +
      ggplot2::ggsave(
        glue::glue(
          "{prefix}_survey_count_heatmap_{wastdr::urlize(placename)}.png"
        ),
        width = 10,
        height = 6
      )
  }

#' Generate a season summary from the output of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @details Surveys, gruped by \code{season},
#'   summarised as first and last day of surveys, season length in days,
#'   number and total hours of surveys.
#'
#' @template param-surveys
#' @export
#' @family wastd
survey_season_stats <- function(surveys) {
  surveys %>%
    dplyr::group_by(season) %>%
    dplyr::summarise(
      first_day = min(turtle_date),
      last_day = max(turtle_date),
      season_length_days = as.numeric(
        lubridate::interval(first_day, last_day)
      ) / (3600 * 24),
      number_surveys = dplyr::n(),
      hours_surveyed = round(sum(duration_hours))
    )
}


#' Generate a season by site summary from the output of \code{parse_surveys}
#'
#' \lifecycle{stable}
#'
#' @details Surveys, gruped by \code{season} and \code{site_name},
#'   summarised as first and last day of surveys, season length in days,
#'   number and total hours of surveys.
#'
#' @template param-surveys
#'
#' @export
#' @family wastd
survey_season_site_stats <- function(surveys) {
  surveys %>%
    dplyr::group_by(season, site_name) %>%
    dplyr::summarise(
      first_day = min(turtle_date),
      last_day = max(turtle_date),
      season_length_days = as.numeric(
        lubridate::interval(first_day, last_day)
      ) / (3600 * 24),
      number_surveys = dplyr::n(),
      hours_surveyed = round(sum(duration_hours))
    )
}


#' Select main survey attributes
#'
#' \lifecycle{stable}
#'
#' @template param-surveys
#' @family wastd
#' @export
survey_show_detail <- function(surveys) {
  surveys %>%
    dplyr::select(
      change_url,
      site_name,
      season,
      turtle_date,
      is_production,
      start_time,
      end_time,
      duration_hours,
      start_comments,
      end_comments,
      status
    )
}
# usethis::use_test("summarise_surveys")
