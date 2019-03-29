library(testthat)

test_that("process_images(empty path)",{
  expect_equal(process_images(""), "cellImages path is incorrect")
})

test_that("process_images(correct path)",{
  process_images("/Users/minhanho/Documents")
  expect_equal(length(list.files("/Users/minhanho/Documents/BCB330/data/processed")), 3000)
})