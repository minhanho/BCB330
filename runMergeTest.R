library(testthat) 

source("/Users/minhanho/Documents/BCB330/ZeiselAndMerge.R")

test_results <- test_dir("/Users/minhanho/Documents/BCB330/testMerge", reporter="summary")
