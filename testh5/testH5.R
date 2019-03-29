library(testthat)

test_that("process_h5(empty path)",{
  expect_equal(process_h5(""), "Incorrect path")
})

test_that("process_h5(correct path)",{
  process_h5("/Users/minhanho/Documents")
  expect_equal(file.exists("/Users/minhanho/Documents/BCB330/TF_FeatureExtraction/features_with_level1class.csv"), TRUE)
})

test_that("process_h5(correct path)",{
  process_h5("/Users/minhanho/Documents")
  expect_equal(nrow(cellTable), 3005)
  expect_equal(ncol(cellTable), 10)
  expect_equal(nrow(totalTable), 3000)
  expect_equal(ncol(totalTable), 1003)
})