#' Create the 1x1 km raster in the GridTimeSeries data
#' @md
#' @description The function returns an empty stars raster with resolution 1x1 km and coordinate system EPSG:25833. This is identical to the grid used in the GridTimeSeries data.
#'
#' @return An empty stars raster in resolution 1x1 km, identical to the one used in the GridTimeSeries data. Coordinate system EPSG:25833.
#' @examples
#' ## Create empty raster grid
#' grid <- gts_create_grid()
#' grid
#' @export
gts_create_grid <- function(){

  # Create grid with extend and resulution used in the GridTimeSeries data
  st_as_stars(st_bbox(c(xmin = -75000, ymin = 6450000, xmax = 1120000, ymax = 8000000), crs = st_crs(25833)), dx = 1000, dy = 1000, values = NA)

}
#'
