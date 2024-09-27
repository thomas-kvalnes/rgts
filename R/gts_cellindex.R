#' List CellIndices in the GridTimeSeries data for a polygon
#' @md
#' @description Looks up the CellIndex for each grid cell in the GridTimeSeries data which is within a given polygon.
#'
#' @param polygon A polygon as json rings with spatialReference. Use sf_to_json() to convert from sf til json. Should be in coordinate system EPSG:25833.
#' @return A vector with the CellIndices for the grid cells in the polygon from the GridTimeSeries data.
#' @examples
#' ## Create a sf polygon and convert to json
#' library(sf)
#' xx <- c(58200, 74225, 58200, 74226)
#' yy <- c(6708225, 6708225, 6715025, 6715025)
#' pol <- st_as_sf(x = data.frame(x = xx, y = yy), coords = c("x", "y"), crs = 25833)
#' pol <- st_as_sf(st_as_sfc(st_bbox(pol)))
#' pol <- gts_sf2json(pol)
#' ## Extract cellindices
#' gts_cellindex(polygon = pol)
#' @export
gts_cellindex <- function(polygon){

  # URL to download API
  url_api <- "http://gts.nve.no/api/AreaTimeSeries/ByGeoJson"

  # Make request
  req <- request(url_api) |>
    req_body_json(list(Theme = "tm", StartDate = "2020-01-01", EndDate = "2020-01-01", Format = "json", Rings = polygon))

  # Run request
  resp <- req |> req_perform()

  # Collect results
  res <- resp |> resp_body_json()

  # Extract cellindices
  res <- bind_rows(res$CellTimeSeries) %>%
    as.data.frame()

  # Return
  res$CellIndex

}
#'
