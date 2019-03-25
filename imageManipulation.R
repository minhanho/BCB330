install.packages("magick")
install.packages("pdftools")
install.packages("here")
library(magick)
library(pdftools)
library(here)

#TO DO
cellImages = "[YOUR PATH HERE]/BCB330/data/cell_images_all_heatmaporder_jun26_2014.pdf"
processed = "[YOUR PATH HERE]/BCB330/data/processed"

dir.create(processed)

for (pageNum in 1:120){
  cells <- image_read_pdf(cellImages, pages=c(pageNum))
  
  text <- pdf_text(cellImages)
  
  page_text <- text[pageNum]
  page_text <- gsub("\n", " ", page_text)
  page_text <- gsub("i[=][0-9]+,", " ", page_text)
  cell_ids_in_page_order <- unlist(strsplit(trimws(page_text), split = "[ ]+"))
  
  trimmed <- image_trim(cells)
  counter <-1
  for(colNum in 1:5){
    dimCols <- paste("540x2750+", as.character(540*(colNum-1) + 12.5*(colNum-1)), sep="")
    cropCol <- image_crop(trimmed, dimCols)
    for (rowNum in 1:5){
      dimRows <- paste("540x540+0+", as.character(540*(rowNum-1) + 12.5*(rowNum-1)), sep="")
      cropRow <- image_crop(cropCol, dimRows)
      final <- image_crop(cropRow, "540x485+0+55")
      cellPath <- here("data", "processed", paste0("cell",cell_ids_in_page_order[counter], ".png"))
      counter <- counter + 1
      image_write(final, path= cellPath, format= "png")
      if (!file.exists(cellPath)) {
        stop("File not made")
      }
    }
  }
}