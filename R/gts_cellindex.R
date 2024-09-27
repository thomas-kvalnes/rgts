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
  if(!all(geo_type %in% c("POLYGON", "MULTIPOLYGON", "POINT")) | ((sum(c("POLYGON", "POINT") %in% geo_type) > 1) | (sum(c("MULTIPOLYGON", "POINT") %in% geo_type) > 1))){

    stop("'geometry' should be one of 'POLYGON', 'MULTIPOLYGON' or 'POINT'")

  }

  # Polygons
  if(all(geo_type %in% c("POLYGON", "MULTIPOLYGON"))){

    # Intersect grid and polygon
    geo_int <- st_intersects(x = grid, y = geometry, as_points = TRUE)
    geo_int <- lengths(geo_int)

    # Find center coordinates of grid cells which intersects
    coords <- st_coordinates(grid)[geo_int>0, ]

    # As sf
    coords <- st_as_sf(coords, coords = c("x", "y"), crs = 25833)
  }

  # Points
  if(all(geo_type %in% "POINT")){

    coords <- geometry

  }

  # Extract cellindex
  res <- st_extract(x = grid, at = coords)

  # Return
  as.vector(res$cellindex)

}
#'
