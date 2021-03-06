% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_odkc_turtledata_2019.R
\name{download_odkc_turtledata_2019}
\alias{download_odkc_turtledata_2019}
\title{Download all turtle data from DBCA's ODK Central}
\usage{
download_odkc_turtledata_2019(
  local_dir = here::here("media"),
  prod = "https://odkcentral.dbca.wa.gov.au",
  uat = "https://odkcentral-uat.dbca.wa.gov.au",
  tz = "Australia/Perth",
  download = TRUE,
  odkc_version = 0.6,
  verbose = wastdr::get_wastdr_verbose()
)
}
\arguments{
\item{local_dir}{A local directory to which to save the attachment files.
Attachment filepaths will be relative to the directory.
The directory and its parent folders will be created if not existing.}

\item{prod}{The ODKC PROD server,
default: "https://odkcentral.dbca.wa.gov.au".}

\item{uat}{The ODKC UAT server,
default: "https://odkcentral-uat.dbca.wa.gov.au".}

\item{tz}{The lubridate timezone, default: "Australia/Perth}

\item{download}{(lgl) Whether to download attachments to \code{local_dir} or not,
default: TRUE.}

\item{odkc_version}{The numeric ODK Central version, e.g. 0.7 or 0.8.}

\item{verbose}{Whether to show debug messages.
Default: wastdr::get_wastdr_verbose()}
}
\value{
An S3 class "odkc_turtledata" with items:
\itemize{
\item downloaded_on An UTC POSIXct timestamp of the data snapshot.
\item tracks The turtle tracks and nests from form
"Turtle Track or Nest 1.0".
\item tracks_dist Individual disturbances recorded against tracks,
one row per disturbance.
\item tracks_log Individual nest tags recorded against nests,
one row per tag.
\item tracks_egg Next excavation photos, one row per photo.
\item tracks_hatch Turtle hatchling morphometrics, one row per measured
hatchling.
\item tracks_fan_outlier Individual hatchling track outliers recorded
against hatched nests, one row per outlier.
\item tracks_light Individual light sources known at hatchling emergence,
one row per light source.
\item track_tally A line transect tally of turtle tracks from form
"Track Tally 0.6".
\item dist The disturbance and predation records from form
"Predator or Disturbance 1.1".
\item mwi Strandings and rescues from the form
"Marine Wildlife Incident 0.6 ".
\item mwi_dmg Individual injuries recorded against mwi,
one record per injury.
\item mwi_tag Individual tags sighted during an mwi, one record per tag.
\item tsi Turtle Sightings from form "Turtle Sighting 0.1/0.2",
one row per sighted turtle.
\item tt Placeholder for form \code{Turtle-Tagging-3-0}, here: NULL.
\item tt_dmg Placeholder for form \code{Turtle-Tagging-3-0} (damages), here: NULL.
\item tt_tag Placeholder for form \code{Turtle-Tagging-3-0} (tags), here: NULL.
\item tt_log Placeholder for form \code{Turtle-Tagging-3-0} (loggers), here: NULL.
\item svs Survey start points from form "Site Visit Start 1.3".
\item sve Survey end points from form "Site Visit End 1.2".
\item sites An sf object of known WAStD sites.
\item areas An sf object of known WAStD localities.
}
}
\description{
\lifecycle{maturing}
}
\seealso{
Other odkc: 
\code{\link{add_hatching_emergence_success_odkc}()},
\code{\link{add_nest_labels_odkc}()},
\code{\link{download_odkc_turtledata_2020}()},
\code{\link{exclude_training_species_odkc}()},
\code{\link{filter_odkc_turtledata}()},
\code{\link{general_disturbance_by_season_odkc}()},
\code{\link{hatching_emergence_success_odkc}()},
\code{\link{map_dist_odkc}()},
\code{\link{map_mwi_odkc}()},
\code{\link{map_sv_odkc}()},
\code{\link{map_tracks_odkc}()},
\code{\link{nest_disturbance_by_season_odkc}()},
\code{\link{nesting_type_by_area_season_age_species_odkc}()},
\code{\link{nesting_type_by_area_season_species_odkc}()},
\code{\link{nesting_type_by_season_age_species_odkc}()},
\code{\link{nesting_type_by_season_calendarday_age_species_odkc}()},
\code{\link{nesting_type_by_season_calendarday_species_odkc}()},
\code{\link{nesting_type_by_season_day_species_odkc}()},
\code{\link{nesting_type_by_season_species_odkc}()},
\code{\link{nesting_type_by_season_week_age_species_odkc}()},
\code{\link{nesting_type_by_season_week_site_species_odkc}()},
\code{\link{nesting_type_by_season_week_species_odkc}()},
\code{\link{nesting_type_by_site_season_age_species_odkc}()},
\code{\link{nesting_type_by_site_season_species_odkc}()}
}
\concept{odkc}
