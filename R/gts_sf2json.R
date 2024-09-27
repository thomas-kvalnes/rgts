#' Convert sf object to json ring
#' @md
#' @description Converts sf object to json rings with spatialReference. The function accepts an sf object and converts it to json. This format is required to collect data for a location given by a  polygon from GridTimeSeries data at nve.api.no.
#'
#' The function is adapted from  MatthewJWhittle/getarc on github (https://github.com/MatthewJWhittle/getarc/).
#' @param x A sf of sfc object
#' @return A character string representing the sf object in json format.
#' @examples
#' ## Create a sf polygon
#' library(sf)
#' xx <- c(58200, 74225, 58200, 74226)
#' yy <- c(6708225, 6708225, 6715025, 6715025)
#' pol <- st_as_sf(x = data.frame(x = xx, y = yy), coords = c("x", "y"), crs = 25833)
#' pol <- st_as_sf(st_as_sfc(st_bbox(pol)))
#' ## Convert to json
#' gts_sf2json(pol)
#' @export
gts_sf2json <- function(x) {

  # make table with json types
  sf_json_type <- data.frame(sf = c("POINT", "MULTIPOINT", "LINESTRING", "MULTILINESTRING", "POLYGON", "MULTIPOLYGON"), json = c("point", "points", "paths", "paths", "rings", "rings"))

  # Drop the z & m dimensions as I don't know how to tell if they are present
  x <- st_zm(x, drop = TRUE)
  # Check the geom type  to convert to its json spec (rings, points, paths)
  x_geom_type <- st_geometry_type(x)
  # Don't query if the geom type isn't supported
  stopifnot(x_geom_type %in% sf_json_type$sf)
  json_type <- filter(sf_json_type, .data$sf == x_geom_type)$json

  # Convert the boundary to an sfc object
  x_sfc <- st_geometry(x)
  stopifnot(length(x_sfc) == 1)

  # Extract the EPSG code
  crs <- st_crs(x_sfc)$epsg
  # If the geometry type is a point, the function needs to return the json in a different way
  if(json_type == "point"){
    xy <- st_coordinates(x)
    return(
      glue("{'x':(xy[,1]), 'y':(xy[,2]), 'spatialReference' : {'wkid' : (crs)}}",
                 .open = "(",
                 .close = ")"
      )
    )
  }


  # First convert the boundary to geojson as this is closer to the required format
  x_geojson <- sfc_geojson(x_sfc)

  # Strip out everything outside the rings
  rings <- str_remove_all(x_geojson, "\\{.+:|\\}")

  # sfc_geojson adds one too many pairs of enclosing brackets
  # Its neccessary to remove one layer. This works for simple text
  # case with two adjecent boxes. Need to test more widely
  # Could make this conditional on geometry being a multipolygon
  rings <-
    rings %>%
    str_replace_all("\\[\\[\\[\\[", "[[[") %>%
    str_replace_all("\\]\\]\\]\\]", "]]]") %>%
    str_replace_all("\\]\\]\\],\\[\\[\\[", "]],[[")

  # Format the json and return
  glue("{'(json_type)':(rings),'spatialReference':{'wkid':(crs)}}",
             .open = "(",
             .close = ")")
}
#'
