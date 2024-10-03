#' Download aggregated values for polygon
#' @md
#' @description Downloads and returns data aggregated for the chosen time resolution over grid cells within a polygon (coordinate system: (EPSG: 25833)). Available methods for aggregating are sum, min, max, avg and median. Time resolution is given by the choice of parameter and start_date/end_date. E.g. "tm3h" for "2023-12-01T06" is three hour data for temperature collected at 06:00 and "tm" for "2023-12-01" is the daily average temperature. collected at 06:00.\cr \cr
#' \emph{Note: The API has a cap at ~635'000 values in each download (lower if many missing values) and ends with an error for larger queries.}\cr \cr
#' \emph{Warning: This function is extremely slow for 1 and 3 hour time steps as the API requires one request per time step when not requesting daily time steps.}
#' @param polygon A polygon as json rings with spatialReference. Use [sf_to_json()] to convert from sf til json. Should be in coordinate system EPSG:25833.
#' @param parameter The quoted abbreviation for the parameter to download. E.g. Daily precipitaion = "rr", Temperature =  "tm", Snow depth =  "sd".
#' @param start_date The start date given as: 'YYYY-MM-DD'. If querying three or one hour data, the hour should be given like this: format: 'YYYY-MM-DDT06'
#' @param end_date The end date. See start_date.
#' @param method The method for aggregating values ("sum", "min", "max", "avg" or "median")
#' @param return_raw Set to TRUE to return the raw results from the query (a list) without coercing to a data.frame (only available for daily time steps).
#' @param verbose Set to TRUE to print the query to the console (default FALSE).
#' @return A data frame with the GTS data aggregated across grid cells in the polygon for each step in the time resolution, e.g. daily values or values for each hour.
#' @seealso [gts_dl_polygon()] to download cellwise GTS data for polygon.
#' @examples
#' ## Create a sf polygon and convert to json
#' library(sf)
#' xx <- c(58200, 74225, 58200, 74226)
#' yy <- c(6708225, 6708225, 6715025, 6715025)
#' pol <- st_as_sf(x = data.frame(x = xx, y = yy), coords = c("x", "y"), crs = 25833)
#' pol <- st_as_sf(st_as_sfc(st_bbox(pol)))
#' pol <- gts_sf2json(pol)
#' ## Download data
#' gts_dl_polygon_aggr(polygon = pol, parameter = "tm", start_date = "2023-12-01", end_date = "2023-12-04", method = "avg")
#' gts_dl_polygon_aggr(polygon = pol, parameter = "tm1h", start_date = "2023-12-01T06", end_date = "2023-12-01T12", method = "avg")
#' gts_dl_polygon_aggr(polygon = pol, parameter = "tm3h", start_date = "2023-12-01T06", end_date = "2023-12-01T12", method = "avg")
#' @export
gts_dl_polygon_aggr <- function(polygon, parameter, start_date, end_date, method, return_raw = FALSE, verbose = FALSE){

  # URL to download API
  url_api <- "http://gts.nve.no/api/AggregationTimeSeries/ByGeoJson"

  # Find time resolution for parameter
  timeres <- filter(gts_parameters(), .data$Name == parameter)$TimeResolutionInMinutes

  # Select step size for sequence of date and time
  datetime_steps <- switch(as.character(timeres),
                           "1440" = "days",
                           "180" = "3 hour",
                           "60" = "hour")

  # Check if time resolution is daily
  if(timeres == 1440){

    # Make request
    req <- request(url_api) |>
      req_body_json(list(Theme = parameter, StartDate = start_date, EndDate = end_date, Format = "json", Method = method, Rings = polygon))

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

    # NoDataValue
    nodata <- res$NoDataValue

    # Date and time
    datetime <- seq(dmy_hm(res$StartDate), dmy_hm(res$EndDate), by = datetime_steps)

    # Time
    time <- format(as.POSIXlt(as_hms(datetime)), "%H:%M")

    # Make results into data frame
    resdf <- data.frame(date = date(datetime), variable = res$Theme, unit = res$Unit, time = time, time_resolution_minutes = res$TimeResolution, values = unlist(res$Data), method = res$Method)

    # Replace NoDataValue by NA
    resdf$values[resdf$values == nodata] <- NA

    # Cast
    resdf <- dcast(resdf , formula = date + time + time_resolution_minutes + unit ~ variable + method, value.var = "values")

    # Return
    return(resdf)

  }else{
    # If not daily, one request per time step (1h or 3h)

    # Make request - first time step
    req <- request(url_api) |>
      req_body_json(list(Theme = parameter, StartDate = start_date, EndDate = start_date, Format = "json", Method = method, Rings = polygon))

    # Dry run - first time step
    if(verbose)
      req |> req_dry_run()

    # Run request and collect results - first time step
    res <- req |> req_perform() |> resp_body_json()

    # NoDataValue
    nodata <- res$NoDataValue

    # Date and time - sequence from first and last time step
    datetime <- seq(dmy_hm(res$StartDate), ymd_h(end_date), by = datetime_steps)

    # Time
    time <- format(as.POSIXlt(as_hms(datetime)), "%H:%M")

    # Make results data frame
    resdf <- data.frame(date = date(datetime), variable = res$Theme, unit = res$Unit, time = time, time_resolution_minutes = res$TimeResolution, values = NA, method = res$Method)

    # Insert first value
    resdf$values[1] <- unlist(res$Data)

    # Loop through other time steps (if more time steps to run)
    if(nrow(resdf) > 1){
      for (i in 2:nrow(resdf)){

        # Hour
        hh <- str_split_fixed(string = resdf$time[i], pattern = ":", n = 2)[,1]

        # Make start and end date
        start_i <- paste0(resdf$date[i], "T", hh)
        end_i <- start_i

        # Make request
        req <- request(url_api) |>
          req_body_json(list(Theme = parameter, StartDate = start_i, EndDate = end_i, Format = "json", Method = method, Rings = polygon))

        # Dry run
        if(verbose)
          req |> req_dry_run()

        # Run request and collect results
        res <- req |> req_perform() |> resp_body_json()

        # Insert into data frame
        resdf$values[i] <- unlist(res$Data)

      }
    }

    # Replace NoDataValue by NA
    resdf$values[resdf$values == nodata] <- NA

    # Cast
    resdf <- dcast(resdf , formula = date + time + time_resolution_minutes + unit ~ variable + method, value.var = "values")

    # Return
    return(resdf)

  }
}
#'
