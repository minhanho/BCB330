library(testthat) 

source("/Users/minhanho/Documents/BCB330/imageManipulation.R")

test_results <- test_dir("/Users/minhanho/Documents/BCB330/testImage", reporter="summary")
