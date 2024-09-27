test_that("download of data frame", {
  l <- gts_parameters()
  expect_equal(is.data.frame(l), TRUE)
})
