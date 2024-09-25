#' Download values at given coordinates
#' @md
#' @description Downloads data for a point (coordinate) in a grid cell (coordinate system: (EPSG: 25833)) at the given time resolution. Several coordinates can be provided at once. Time resolution is given by the choice of environmental variable (env_layer) and start_date/end_date.  E.g. "tm3h" for "2023-12-01T06" is three hour data for temperature collected at 06:00 and "tm" for "2023-12-01" is the daily average temperature.
#' @param coords A data frame with x and y coordinates (coordinate system: (EPSG: 25833))
#' @param env_layer The quoted abbreviation for the environmental layer to download. E.g. Daily precipitaion = "rr", Temperature =  "tm", Snow depth =  "sd".
#' @param start_date The start date given as: 'YYYY-MM-DD'. If querying three or one hour data, the hour should be given like this: format: 'YYYY-MM-DDT06'
#' @param end_date The end date. See start_date.
#' @param verbose Set to TRUE to print the query to the console (default FALSE).
#' @return A data frame with the GTS data associated with each point for each step in the time resolution, e.g. daily values or values for each hour.
#' @examples
#' ## Create a data frame with coordinates
#' coords <- data.frame(x = c(58200, 74225), y = c(6708225, 6715025))
#' ## Download data
#' gts_dl_coords(coords = coords, env_layer = "tm", start_date = "2023-12-01", end_date = "2023-12-02")
#' gts_dl_coords(coords = coords, env_layer = "tm3h", start_date = "2023-12-01T23", end_date = "2023-12-02T06")
#' gts_dl_coords(coords = coords, env_layer = "tm1h", start_date = "2023-12-01T23", end_date = "2023-12-02T06")
#' @export
gts_dl_coords <- function(coords, env_layer, start_date, end_date, verbose = FALSE){

  # URL to download API
  url_api <- "http://gts.nve.no/api/MultiPointTimeSeries/ByMapCoordinateCsv"

  # Prepare coordiantes (remove any decimals and paste)
  coords$x <- round(coords$x)
  coords$y <- round(coords$y)
  coords <- paste(apply(X = coords, MARGIN = 1, FUN = function(x)paste(x, collapse = " ")), collapse = ", ")

  # Make request
  req <- request(url_api) |>
    req_body_json(list(Theme = env_layer, StartDate = start_date, EndDate = end_date, Format = "json", MapCoordinateCsv = coords))

  # Dry run
  if(verbose)
    req |> req_dry_run()

  # Run request
  resp <- req |> req_perform()

  # Collect results
  res <- resp |> resp_body_json()

  # Find time resolution
  timeres <- res$TimeResolution
  # Select step size for sequence of date and time
  datetime_steps <- switch(as.character(timeres),
                           "1440" = "days",
                           "180" = "3 hour",
                           "60" = "hour")

  # Make results into data frame
  # Data frame
  resdf <- bind_rows(lapply(res$CellTimeSeries, function(x) data.frame(x = x$X, y = x$Y, altitude = x$Altitude, cellindex = x$CellIndex, values = unlist(x$Data))))

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
  resdf[resdf$values == nodata]$values <- NA

  # Cast
  resdf <- dcast(resdf , formula = x + y + cellindex + altitude + date + time + time_resolution_minutes + unit ~ variable, value.var = "values")

  # Return
  resdf
}
#'
