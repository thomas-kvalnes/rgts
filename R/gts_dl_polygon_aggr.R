#' Download aggregated values for polygon
#' @md
#' @description Downloads and returns data aggregated for the chosen time resolution over grid cells within a polygon (coordinate system: (EPSG: 25833)). Available methods for aggregating are sum, min, max, avg and median. Time resolution is given by the choice of environmental variable (env_layer) and start_date/end_date. E.g. "tm3h" for "2023-12-01T06" is three hour data for temperature collected at 06:00 and "tm" for "2023-12-01" is the daily average temperature. collected at 06:00. \emph{Warning: This function is extremely slow for 1 and 3 hour time steps as the API requires one request per time step when not requesting daily time steps.}
#' @param polygon A polygon as json rings with spatialReference. Use [sf_to_json()] to convert from sf til json. Should be in coordinate system EPSG:25833.
#' @param env_layer The quoted abbreviation for the environmental layer to download. E.g. Daily precipitaion = "rr", Temperature =  "tm", Snow depth =  "sd".
#' @param start_date The start date given as: 'YYYY-MM-DD'. If querying three or one hour data, the hour should be given like this: format: 'YYYY-MM-DDT06'
#' @param end_date The end date. See start_date.
#' @param method The method for aggregating values ("sum", "min", "max", "avg" or "median")
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
#' pol <- gts_sf_to_json(pol)
#' ## Download data
#' gts_dl_polygon_aggr(polygon = pol, env_layer = "tm", start_date = "2023-12-01", end_date = "2023-12-04", method = "avg")
#' gts_dl_polygon_aggr(polygon = pol, env_layer = "tm1h", start_date = "2023-12-01T06", end_date = "2023-12-01T12", method = "avg")
#' gts_dl_polygon_aggr(polygon = pol, env_layer = "tm3h", start_date = "2023-12-01T06", end_date = "2023-12-01T12", method = "avg")
#' @export
gts_dl_polygon_aggr <- function(polygon, env_layer, start_date, end_date, method, verbose = FALSE){

  # URL to download API
  url_api <- "http://gts.nve.no/api/AggregationTimeSeries/ByGeoJson"

  # Find time resolution for env_layer
  timeres <- filter(gts_parameters(), .data$Name == env_layer)$TimeResolutionInMinutes

  # Select step size for sequence of date and time
  datetime_steps <- switch(as.character(timeres),
                           "1440" = "days",
                           "180" = "3 hour",
                           "60" = "hour")

  # Check if time resolution is daily
  if(timeres == 1440){

    # Make request
    req <- request(url_api) |>
      req_body_json(list(Theme = env_layer, StartDate = start_date, EndDate = end_date, Format = "json", Method = method, Rings = polygon))

    # Dry run
    if(verbose)
      req |> req_dry_run()

    # Run request
    resp <- req |> req_perform()

    # Collect results
    res <- resp |> resp_body_json()

    # NoDataValue
    nodata <- res$NoDataValue

    # Date and time
    datetime <- seq(dmy_hm(res$StartDate), dmy_hm(res$EndDate), by = datetime_steps)

    # Time
    time <- format(as.POSIXlt(as_hms(datetime)), "%H:%M")

    # Make results into data frame
    resdf <- data.frame(date = date(datetime), variable = res$Theme, unit = res$Unit, time = time, time_resolution_minutes = res$TimeResolution, values = unlist(res$Data), method = res$Method)

    # Replace NoDataValue by NA
    resdf[resdf$values == nodata]$values <- NA

    # Cast
    resdf <- dcast(resdf , formula = date + time + time_resolution_minutes + unit ~ variable + method, value.var = "values")

    # Return
    return(resdf)

  }else{
    # If not daily, one request per time step (1h or 3h)

    # Make request - first time step
    req <- request(url_api) |>
      req_body_json(list(Theme = env_layer, StartDate = start_date, EndDate = start_date, Format = "json", Method = method, Rings = polygon))

    # Dry run - first time step
    if(verbose)
      req |> req_dry_run()

    # Run request and collect results - first time step
    res <- req |> req_perform() |> resp_body_json()

    # Make request - last time step
    req2 <- request(url_api) |>
      req_body_json(list(Theme = env_layer, StartDate = end_date, EndDate = end_date, Format = "json", Method = method, Rings = polygon))

    # Dry run - last time step
    if(verbose)
      req2 |> req_dry_run()

    # Run request and collect results - last time step
    res2 <- req2 |> req_perform() |> resp_body_json()

    # NoDataValue
    nodata <- res$NoDataValue

    # Date and time - sequence from first and last time step
    datetime <- seq(dmy_hm(res$StartDate), dmy_hm(res2$StartDate), by = datetime_steps)

    # Time
    time <- format(as.POSIXlt(as_hms(datetime)), "%H:%M")

    # Make results data frame
    resdf <- data.frame(date = date(datetime), variable = res$Theme, unit = res$Unit, time = time, time_resolution_minutes = res$TimeResolution, values = NA, method = res$Method)

    # Insert first value
    resdf$values[resdf$date == date(datetime[1]) & resdf$time == time[1]] <- unlist(res$Data)

    # Insert last value (if last date-time is final date-time in data frame)
    # Indicator for last value
    lv <- 0
    # Insert
    if(dmy_hm(res2$StartDate) == tail(datetime, 1)){
      resdf$values[resdf$date == tail(resdf$date, 1) & resdf$time == tail(resdf$time, 1)] <- unlist(res2$Data)
      lv <- 1
    }

    # Loop through other time steps (if more time steps to run)
    if((nrow(resdf) == 2 & lv == 0)|(nrow(resdf) > 2)){
      for (i in 2:(nrow(resdf)-lv)){

        # Hour
        hh <- str_split_fixed(string = resdf$time[i], pattern = ":", n = 2)[,1]
        # Make start and end date
        start_i <- paste0(resdf$date[i], "T", hh)
        end_i <- start_i

        # Make request
        req <- request(url_api) |>
          req_body_json(list(Theme = env_layer, StartDate = start_i, EndDate = end_i, Format = "json", Method = method, Rings = polygon))

        # Dry run
        if(verbose)
          req |> req_dry_run()

        # Run request and collect results
        res <- req |> req_perform() |> resp_body_json()

        # Insert into data frame
        resdf$values[i] <- unlist(res$Data)

      }
    }

    # Cast
    resdf <- dcast(resdf , formula = date + time + time_resolution_minutes + unit ~ variable + method, value.var = "values")

    # Replace NoDataValue by NA
    resdf[resdf$values == nodata]$values <- NA

    # Return
    return(resdf)

  }
}
#'
