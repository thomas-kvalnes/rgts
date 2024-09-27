#' List CellIndices in the GridTimeSeries data for a polygon
#' @md
#' @description Looks up the CellIndex for each grid cell in the GridTimeSeries data which intersects with a polygon or a set of points.
#'
#' @param geometry A sf polygon or sf points. Should be in coordinate system EPSG:25833.
#' @return A vector with the CellIndices for the grid cells in the GridTimeSeries data which intersects with the geometry.
#' @examples
#' ## Create sf points and a sf polygon
#' library(sf)
#' xx <- c(58200, 74225, 58200, 74226)
#' yy <- c(6708225, 6708225, 6715025, 6715025)
#' points <- st_as_sf(x = data.frame(x = xx, y = yy), coords = c("x", "y"), crs = 25833)
#' pol <- st_as_sf(st_as_sfc(st_bbox(points)))
#' #' ## Extract cellindices for points
#' gts_cellindex(geometry = points)
#' ## Extract cellindices for polygon
#' gts_cellindex(geometry = pol)
#' @export
gts_cellindex <- function(geometry){

  # Create grid
  grid <- gts_create_grid()

  # Find geometry type
  geo_type <- st_geometry_type(geometry)

  # Check geometry type
  if(!all(geo_type %in% c("POLYGON", "MULTIPOLYGON", "POINT")) | (sum(c("POLYGON", "MULTIPOLYGON", "POINT") %in% geo_type) > 1)){
    stop("'geometry' should be one of 'POLYGON', 'MULTIPOLYGON' or 'POINT'")
  }

  # Select intersection method
  int_method <- switch(as.character(geo_type)[1],
                       "POLYGON" = TRUE,
                       "MULTIPOLYGON" = TRUE,
                       "POINT" = FALSE)

  # Intersects
  geo_int <- st_intersects(x = grid, y = geometry, as_points = int_method)
  geo_int <- lengths(geo_int)

  # Fint center coordinates of grid cells which intersects
  xy_int <- st_coordinates(grid)[geo_int>0, ]
  # As sf
  xy_int <- st_as_sf(xy_int, coords=c("x", "y"), crs = 25833)

  # Find cellindices for GTS data (cellindex = stars cellindex - 1)
  res <- st_cells(x = grid, sf = xy_int)-1

  # Return
  as.vector(res)

}
#'
