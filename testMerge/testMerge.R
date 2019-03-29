library(testthat)

test_that("run_correlations(empty path)",{
  expect_equal(process_h5(""), "Incorrect path")
})

test_that("run_correlations(correct path)",{
  run_correlations("/Users/minhanho/Documents")
  expect_equal(,)
})
