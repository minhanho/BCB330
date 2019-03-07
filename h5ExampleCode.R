library(magrittr)
library(dplyr)
library(tidyr)
library(rhdf5)
library(readr)

table <- tbl_df(h5read("/Users/minhanho/Documents/BCB330/TF_FeatureExtraction/features.h5", "/resnet_v1_101/logits"))
table <- as_tibble(t(as.matrix(table)), .name.repair=NULL)

filenames <- h5read("/Users/minhanho/Documents/BCB330/TF_FeatureExtraction/features.h5", "filenames")
table %<>% mutate( fullFilename = filenames) 
filenames <- gsub(".*processed/", "", filenames)

table %<>% mutate( filename = filenames) %>% select(filename, everything())
table %<>% mutate( filename = gsub("cell", "", filename))
table %<>% mutate( filename = gsub(".png", "", filename))
table %<>% mutate( filename = gsub("−", "_", filename))
table %<>%  rename(cell_id = filename)
#full filename is at the end if needed

linLabMatrix <- read_tsv("/Users/minhanho/Documents/BCB330/CellTypesAging/data/Zeisel/expression_mRNA_17-Aug-2014.tsv", col_names=F)
cellTable <- as_tibble(t(linLabMatrix[1:10,2:ncol(linLabMatrix)]), .name.repair=NULL)
colnames(cellTable) <- cellTable[1,]
(cellTable <- cellTable[-1,])
table <- inner_join(cellTable %>% select(level1class), table)
table %<>%  rename(target = level1class)#TPOT processing

table %>% write_csv("/Users/minhanho/Documents/BCB330/TF_FeatureExtraction/features_with_level1class.csv")
