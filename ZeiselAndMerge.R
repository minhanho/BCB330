library(ggplot2)
library(here)
library(reshape2)
library(dplyr)
library(magrittr)
library(readr)
library(rhdf5)

run_correlations <- function(path){

  mRNAexpression = paste(path, "/BCB330/CellTypesAging/data/Zeisel/expression_mRNA_17-Aug-2014.tsv", sep="")
  features = paste(path, "/BCB330/TF_FeatureExtraction/features.h5", sep="")
  
  if ((file.exists(mRNAexpression)) & (file.exists(features)))
  {
    linLabMatrix <- read_tsv(mRNAexpression, col_names=F)
    cellTable <- as_tibble(t(linLabMatrix[1:10,2:ncol(linLabMatrix)]), .name.repair=NULL)
    colnames(cellTable) <- cellTable[1,]
    (cellTable <- cellTable[-1,])
    
    colnames(linLabMatrix) <- linLabMatrix[8,]
    linLabMatrix[1:15,1:15]
    linLabMatrix <- linLabMatrix[12:nrow(linLabMatrix),]
    linLabMatrix <- dplyr::select(linLabMatrix, -cell_id)
    colnames(linLabMatrix)[1] <- "geneName"
    
    #now it can be melted
    linLabMelted <- reshape2::melt(linLabMatrix,factorsAsStrings = TRUE, id.vars=c("geneName"), variable.name = "cell_id", value.name = "moleculeCount")
    linLabMelted <- tbl_df(linLabMelted)
    linLabMelted$moleculeCount <- as.numeric(linLabMelted$moleculeCount)
    linLabMelted <- mutate(linLabMelted, log1Expression = log(1+moleculeCount))
    linLabMelted %<>% select(geneName, cell_id, log1Expression)
    linLabMatrixTranspose <- as_tibble(reshape2::dcast(linLabMelted, formula=  cell_id ~ geneName))
    linLabMatrixTranspose$cell_id <- as.character(linLabMatrixTranspose$cell_id)
    
    corTable <- tbl_df(h5read(features, "/resnet_v1_101/logits"))
    
    corTable <- as_tibble(t(as.matrix(corTable)), .name.repair=NULL)
    
    filenames <- h5read(features, "filenames")
    
    corTable %<>% mutate( fullFilename = filenames) 
    filenames <- gsub(".*processed/", "", filenames)
    
    corTable %<>% mutate( filename = filenames) %>% select(filename, everything())
    corTable %<>% mutate( filename = gsub("cell", "", filename))
    corTable %<>% mutate( filename = gsub(".png", "", filename))
    corTable %<>% mutate( filename = gsub("−", "_", filename))
    corTable %<>%  rename(cell_id = filename)
    #full filename is at the end if needed
    
    length(intersect(linLabMatrixTranspose$cell_id, corTable$cell_id))
    full_table <- inner_join(linLabMatrixTranspose, corTable)
    full_table %>% summarise_at(vars(starts_with("V9")), funs(cor(., full_table$`4930431P03Rik`)))
    
    #plotting code from Leon
    for_plot <- full_table %>% select(cell_id, Tspan13, V932)
    for_plot <- inner_join(for_plot, cellTable %>% select(cell_id, level1class))
    ggplot(data = for_plot, aes(x=Tspan13, y= V932, color= level1class)) + geom_point() + geom_smooth(method='lm')
    
    for_plot <- full_table %>% select(cell_id, Trf, V249)
    for_plot <- inner_join(for_plot, cellTable %>% select(cell_id, level1class))
    ggplot(data = for_plot, aes(x=Trf, y= V249, color= level1class)) + geom_point() + geom_smooth(method='lm')
    
    
    #correlate full table
    system.time(full_cor <- cor(full_table %>% select_if(is.numeric)))
    #takes 15 minutes on Leon's machine
    dim(full_cor)
    as_tibble(full_cor)
    tail(colnames(full_cor))
    
    #cut it down to just image features in cols
    full_cor <- full_cor[, grepl("^V[0-9]+$", colnames(full_cor))]
    full_cor <- full_cor[setdiff(rownames(full_cor), colnames(full_cor)), ]
    
    full_cor_melted <- as_tibble(melt(full_cor))
    full_cor_melted %<>% rename(gene_symbol=Var1, image_feature = Var2, correlation=value)
    full_cor_melted %<>% arrange(-abs(correlation))
    
  } else{
    print("Incorrect path")
  }
}
#TO DO
run_correlations(path = "[YOUR PATH HERE]")