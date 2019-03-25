library(magrittr)
library(dplyr)
library(tidyr)
library(rhdf5)
library(readr)

#TO DO
mRNAexpression = "[YOUR PATH HERE]/BCB330/CellTypesAging/data/Zeisel/expression_mRNA_17-Aug-2014.tsv"
features = "[YOUR PATH HERE]/BCB330/TF_FeatureExtraction/features.h5"
featuresLevel1 = "[YOUR PATH HERE]/BCB330/TF_FeatureExtraction/features_with_level1class.csv"

totalTable <- tbl_df(h5read(features, "/resnet_v1_101/logits"))
totalTable <- as_tibble(t(as.matrix(totalTable)), .name.repair=NULL)

filenames <- h5read(features, "filenames")
totalTable %<>% mutate( fullFilename = filenames) 
filenames <- gsub(".*processed/", "", filenames)

totalTable %<>% mutate( filename = filenames) %>% select(filename, everything())
totalTable %<>% mutate( filename = gsub("cell", "", filename))
totalTable %<>% mutate( filename = gsub(".png", "", filename))
totalTable %<>% mutate( filename = gsub("−", "_", filename))
totalTable %<>%  rename(cell_id = filename)
#full filename is at the end if needed

linLabMatrix <- read_tsv(mRNAexpression, col_names=F)
cellTable <- as_tibble(t(linLabMatrix[1:10,2:ncol(linLabMatrix)]), .name.repair=NULL)
colnames(cellTable) <- cellTable[1,]
(cellTable <- cellTable[-1,])
totalTable <- inner_join(cellTable %>% select(level1class), totalTable)
totalTable %<>%  rename(target = level1class)#TPOT processing

totalTable %>% write_csv(featuresLevel1)
