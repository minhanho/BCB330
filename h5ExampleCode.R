library(dplyr)
library(rhdf5)

h5ls("/Users/lfrench/Desktop/results/TF_FeatureExtraction/features.h5")

(mydata <- h5read("/Users/lfrench/Desktop/results/TF_FeatureExtraction/features.h5", "/resnet_v1_101"))
table <- tbl_df(mydata <- h5read("/Users/lfrench/Desktop/results/TF_FeatureExtraction/features.h5", "/resnet_v1_101/logits"))

filenames <- h5read("/Users/lfrench/Desktop/results/TF_FeatureExtraction/features.h5", "filenames")
filenames <- gsub(".*processed/", "", filenames)
colnames(table) <- filenames
#make.names(filenames)
table[1:5,1:5]

logits <- h5read("/Users/lfrench/Desktop/results/TF_FeatureExtraction/features.h5", "/resnet_v1_101/logits")

