% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gts_dl_polygon.R
\name{gts_dl_polygon}
\alias{gts_dl_polygon}
\title{Download cellwise values for polygon}
\usage{
gts_dl_polygon(
  polygon,
  parameter,
  start_date,
  end_date,
  return_raw = FALSE,
  verbose = FALSE
)
}
\arguments{
\item{polygon}{A polygon as json rings with spatialReference. Use \code{\link[=sf_to_json]{sf_to_json()}} to convert from sf til json. Should be in coordinate system EPSG:25833.}

\item{parameter}{The quoted abbreviation for the parameter to download. E.g. Daily precipitaion = "rr", Temperature =  "tm", Snow depth =  "sd".}

\item{start_date}{The start date given as: 'YYYY-MM-DD'. If querying three or one hour data, the hour should be given like this: format: 'YYYY-MM-DDT06'}

\item{end_date}{The end date. See start_date.}

\item{return_raw}{Set to TRUE to return the raw results from the query (a list) without coercing to a data.frame.}

\item{verbose}{Set to TRUE to print the query to the console (default FALSE).}
}
\value{
A data frame with the GTS data associated with each grid cell for each step in the time resolution, e.g. daily values or values for each hour.
}
\description{
Downloads data for each grid cell within a polygon (coordinate system: (EPSG: 25833)). Time resolution is given by the choice of parameter and start_date/end_date. E.g. "tm3h" for "2023-12-01T06" is three hour data for temperature collected at 06:00 and "tm" for "2023-12-01" is the daily average temperature.\cr \cr
\emph{Note: The API has a cap at ~635'000 values in each download (lower if many missing values) and ends with an error for larger queries.}
}
\examples{
## Create a sf polygon and convert to json
library(sf)
xx <- c(58200, 74225, 58200, 74226)
yy <- c(6708225, 6708225, 6715025, 6715025)
pol <- st_as_sf(x = data.frame(x = xx, y = yy), coords = c("x", "y"), crs = 25833)
pol <- st_as_sf(st_as_sfc(st_bbox(pol)))
pol <- gts_sf2json(pol)
## Download data
head(gts_dl_polygon(polygon = pol, parameter = "tm", start_date = "2023-12-01", end_date = "2023-12-01"))
head(gts_dl_polygon(polygon = pol, parameter = "tm1h", start_date = "2023-12-01T00", end_date = "2023-12-01T01"))
}
