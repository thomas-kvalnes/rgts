% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gts_sf2json.R
\name{gts_sf2json}
\alias{gts_sf2json}
\title{Convert sf object to json ring}
\usage{
gts_sf2json(x)
}
\arguments{
\item{x}{A sf of sfc object}
}
\value{
A character string representing the sf object in json format.
}
\description{
Converts sf object to json rings with spatialReference. The function accepts an sf object and converts it to json. This format is required to collect data for a location given by a  polygon from GridTimeSeries data at nve.api.no.

The function is adapted from  MatthewJWhittle/getarc on github (https://github.com/MatthewJWhittle/getarc/).
}
\examples{
## Create a sf polygon
library(sf)
xx <- c(58200, 74225, 58200, 74226)
yy <- c(6708225, 6708225, 6715025, 6715025)
pol <- st_as_sf(x = data.frame(x = xx, y = yy), coords = c("x", "y"), crs = 25833)
pol <- st_as_sf(st_as_sfc(st_bbox(pol)))
## Convert to json
gts_sf2json(pol)
}
