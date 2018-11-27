install.packages("ImageMagick")
library(magick)

for (pageNum in 1:120){
  cells <- image_read_pdf("/Users/minhanho/Documents/BCB330/Pictures/cell_images_all_heatmaporder_jun26_2014.pdf", pages=c(pageNum))
  trimmed <- image_trim(cells)
  for(colNum in 1:5){
    dimCols <- paste("540x2750+", as.character(540*(colNum-1) + 12.5*(colNum-1)), sep="")
    cropCol <- image_crop(trimmed, dimCols)
    for (rowNum in 1:5){
      dimRows <- paste("540x540+0+", as.character(540*(rowNum-1) + 12.5*(rowNum-1)), sep="")
      cropRow <- image_crop(cropCol, dimRows)
      final <- image_crop(cropRow, "540x485+0+55")
      cellPath <- paste("cell",as.character(colNum*rowNum*pageNum), ".pdf", sep="")
      image_write(final, path= cellPath, format= "pdf")
    }
  }
}