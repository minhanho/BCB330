library(magrittr)
library(dplyr)
library(tidyr)
library(rhdf5)

table <- tbl_df(h5read("/Users/lfrench/Desktop/results/TF_FeatureExtraction/features.h5", "/resnet_v1_101/logits"))
table <- as_tibble(t(as.matrix(table)), .name.repair=NULL)

filenames <- h5read("/Users/lfrench/Desktop/results/TF_FeatureExtraction/features.h5", "filenames")
table %<>% mutate( fullFilename = filenames) 

filenames <- gsub(".*processed/", "", filenames)

table %<>% mutate( filename = filenames) %>% select(filename, everything())

table[1:5,1:5]
table %<>% mutate( filename = gsub("cell", "", filename))
table %<>% mutate( filename = gsub(".png", "", filename))
table %<>% mutate( filename = gsub("−", "_", filename))
table %<>%  rename(cell_id = filename)
#full filename is at the end if needed
tail(colnames(table))


linLabMatrix <- read_tsv("/Users/lfrench/Desktop/results/CellTypesAging/data/Zeisel/expression_mRNA_17-Aug-2014.tsv", col_names=F)
cellTable <- as_tibble(t(linLabMatrix[1:10,2:ncol(linLabMatrix)]), .name.repair=NULL)
colnames(cellTable) <- cellTable[1,]
(cellTable <- cellTable[-1,])

table <- inner_join(cellTable %>% select(cell_id, level1class), table)


table %>% write_csv("/Users/lfrench/Desktop/results/TF_FeatureExtraction/features_with_level1class.csv")
