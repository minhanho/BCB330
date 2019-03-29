library(testthat)

test_that("run_correlations(empty path)",{
  expect_equal(process_h5(""), "Incorrect path")
})

test_that("run_correlations(correct path)",{
  run_correlations("/Users/minhanho/Documents")
  expect_equal(nrow(linLabMelted), 60015860)
  expect_equal(ncol(linLabMelted), 3)
})

test_that("run_correlations(correct path)",{
  run_correlations("/Users/minhanho/Documents")
  expect_equal(nrow(corTable), 3000)
  expect_equal(ncol(corTable), 1002)
  expect_equal(nrow(full_table), 3000)
  expect_equal(ncol(full_table), 20972)
  expect_equal(nrow(full_cor), 20972)
  expect_equal(ncol(full_cor), 20972)
  
})