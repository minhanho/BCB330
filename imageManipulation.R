text <- pdf_text("/Users/minhanho/Downloads/cell_images_all_heatmaporder_jun26_2014.pdf")
length(text)
text[1]

install.packages("ImageMagick")
library(magick)
#z <- image_read_pdf("/Users/minhanho/Downloads/cell_images_all_heatmaporder_jun26_2014.pdf")
#print(z)

z <- image_read_pdf("/Users/minhanho/Downloads/cell_images_all_heatmaporder_jun26_2014.pdf", pages=c(1))
print(z)
