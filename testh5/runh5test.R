library(testthat) 

source("/Users/minhanho/Documents/BCB330/h5ExampleCode.R")

test_results <- test_dir("/Users/minhanho/Documents/BCB330/testh5", reporter="summary")
