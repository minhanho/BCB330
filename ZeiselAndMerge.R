library(corrr)

library(readr)
linLabMatrix <- read_tsv("/Users/lfrench/Desktop/results/CellTypesAging/data/Zeisel/expression_mRNA_17-Aug-2014.tsv", col_names=F)

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

length(intersect(linLabMatrixTranspose$cell_id, table$cell_id))


#here table comes out of nowhere - needs fixing - from h5ExampleCode       
intersect(head(sort(table$cell_id)), head(sort(linLabMatrixTranspose$cell_id)       ))


full_table <- inner_join(linLabMatrixTranspose, table)
dim(full_table)

system.time(full_table %>% summarise_at(vars(starts_with("V9")), funs(cor(., full_table$`4930431P03Rik`))))

32*10*17000/60/60/24

cor.test(full_table$`4930431P03Rik`, full_table$V998)

#full_table %>% summarise_at(vars(starts_with("V")), funs(cor(., full_table[, colVariable])))


#result = foreach(i = 1:5, .combine = rbind) %dopar% {
#  data.frame(x = runif(40), i = i)
#}