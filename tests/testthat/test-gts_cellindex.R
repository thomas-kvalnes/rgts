test_that("cellindex test", {
  library(sf)
  pol <- st_as_sf(st_as_sfc(st_bbox(st_as_sf(x = data.frame(x = c(58200.16, 74224.55, 58200.16, 74224.55), y = c(6708224.65, 6708224.65, 6715024.86, 6715024.86)), coords = c("x", "y"), crs = 25833))))
  lgc <- gts_cellindex(geometry = pol)
  expect_equal(lgc[1], 1535708)
})
