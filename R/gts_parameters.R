#' List parameters available in the GridTimeSeries data
#' @md
#' @description Accesses the available parameters in the GridTimeSeries data and provides a table with the name of parameters, their time resolution, units of measurement and the years of available data.
#'
#' @return A table with details the parameters that are available in the GridTimeSeries data. Use the variable names in the table when downloading data.
#' @examples
#' ## List parameters
#' gts_parameters()
#' @export
gts_parameters <- function(){

  # URL to download API
  url_api <- "http://gts.nve.no/api/GridTimeSeries/Themes/json"

  # Make request
  req <- request(base_url = url_api)

  # Run request
  resp <- req |> req_perform()

  # Collect results
  res <- resp |> resp_body_json()

  # Create data frame
  res <- bind_rows(res) %>%
    as.data.frame()

  # Return
  res

}
#'
