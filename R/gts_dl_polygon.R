#' Download cellwise values for polygon
#' @md
#' @description Downloads data for each grid cell within a polygon (coordinate system: (EPSG: 25833)). Time resolution is given by the choice of parameter and start_date/end_date. E.g. "tm3h" for "2023-12-01T06" is three hour data for temperature collected at 06:00 and "tm" for "2023-12-01" is the daily average temperature.\cr \cr
#' \emph{Note: The API has a cap at ~635'000 values in each download (lower if many missing values) and ends with an error for larger queries.}
#' @param polygon A polygon as json rings with spatialReference. Use [sf_to_json()] to convert from sf til json. Should be in coordinate system EPSG:25833.
#' @param parameter The quoted abbreviation for the parameter to download. E.g. Daily precipitaion = "rr", Temperature =  "tm", Snow depth =  "sd".
#' @param start_date The start date given as: 'YYYY-MM-DD'. If querying three or one hour data, the hour should be given like this: format: 'YYYY-MM-DDT06'
#' @param end_date The end date. See start_date.
#' @param return_raw Set to TRUE to return the raw results from the query (a list) without coercing to a data.frame.
#' @param verbose Set to TRUE to print the query to the console (default FALSE).
#' @return A data frame with the GTS data associated with each grid cell for each step in the time resolution, e.g. daily values or values for each hour.
#' @examples
#' ## Create a sf polygon and convert to json
#' library(sf)
#' xx <- c(58200, 74225, 58200, 74226)
#' yy <- c(6708225, 6708225, 6715025, 6715025)
#' pol <- st_as_sf(x = data.frame(x = xx, y = yy), coords = c("x", "y"), crs = 25833)
#' pol <- st_as_sf(st_as_sfc(st_bbox(pol)))
#' pol <- gts_sf2json(pol)
#' ## Download data
#' head(gts_dl_polygon(polygon = pol, parameter = "tm", start_date = "2023-12-01", end_date = "2023-12-01"))
#' head(gts_dl_polygon(polygon = pol, parameter = "tm1h", start_date = "2023-12-01T00", end_date = "2023-12-01T01"))
#' @export
gts_dl_polygon <- function(polygon, parameter, start_date, end_date, return_raw = FALSE, verbose = FALSE){

  # URL to download API
  url_api <- "http://gts.nve.no/api/AreaTimeSeries/ByGeoJson"

  # Make request
  req <- request(url_api) |>
    req_body_json(list(Theme = parameter, StartDate = start_date, EndDate = end_date, Format = "json", Rings = polygon))

  # Dry run
  if(verbose)
    req |> req_dry_run()

  # Run request
  resp <- req |> req_perform()

  # Collect results
  res <- resp |> resp_body_json()

  # Return raw data values
  if(return_raw){
    return(res)
  }

  # Find time resolution
  timeres <- res$TimeResolution
  # Select step size for sequence of date and time
  datetime_steps <- switch(as.character(timeres),
                           "1440" = "days",
                           "180" = "3 hour",
                           "60" = "hour")

  # Make results into data frame
  # Data frame
  resdf <- bind_rows(lapply(res$CellTimeSeries, function(x) data.frame(altitude = x$Altitude, cellindex = x$CellIndex, values = unlist(x$Data))))

  # NoDataValue
  nodata <- res$NoDataValue

  # Date and time
  datetime <- seq(dmy_hm(res$StartDate), dmy_hm(res$EndDate), by = datetime_steps)

  # Time
  time <- format(as.POSIXlt(as_hms(datetime)), "%H:%M")

  # Add variables
  resdf$date <- date(datetime)
  resdf$variable <- res$Theme
  resdf$unit <- res$Unit
  resdf$time <- time
  resdf$time_resolution_minutes <- res$TimeResolution

  # Replace NoDataValue by NA
  resdf$values[resdf$values == nodata] <- NA

  # Cast
  resdf <- dcast(resdf , formula = cellindex + altitude + date + time + time_resolution_minutes + unit ~ variable, value.var = "values")

  # Return
  resdf
}
#'
