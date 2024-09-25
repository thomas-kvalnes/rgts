test_that("conversion works", {
  library(sf)
  pol <- st_as_sf(st_as_sfc(st_bbox(st_as_sf(x = data.frame(x = c(58200.16, 74224.55, 58200.16, 74224.55), y = c(6708224.65, 6708224.65, 6715024.86, 6715024.86)), coords = c("x", "y"), crs = 25833))))
  exp_res <- "{'rings':[[[58200.16,6708224.65],[74224.55,6708224.65],[74224.55,6715024.86],[58200.16,6715024.86],[58200.16,6708224.65]]],'spatialReference':{'wkid':25833}}"
  expect_equal(sf_to_json(pol), exp_res)
})
