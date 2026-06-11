library(tidyverse)
library(ComplexHeatmap)
library(Hmisc)


m = cor(mtcars)
Heatmap(m)


cor_res<- Hmisc::rcorr(m) 
cor_mat<- cor_res$r

cor_mat[is.na(cor_mat)]<- 0
cor_p<- cor_res$P


cell_fun = function(j, i, x, y, w, h, fill){
  xy_numeric <- as.numeric(x) <= 1 - as.numeric(y) + 1e-6
  if(xy_numeric) {
    grid.rect(x, y, w, h, gp = gpar(fill = fill, col = fill))
  }
  
  if (!is.na(cor_p[i, j]) && !is.na(xy_numeric) && cor_p[i, j] < 0.01 & xy_numeric) {
    grid.text(paste0(sprintf("%.2f", cor_mat[i, j]),"**"), x, y, gp = gpar(fontsize = 8))
  } else if (!is.na(cor_p[i, j]) && !is.na(xy_numeric) && cor_p[i, j] < 0.01 & xy_numeric) {
    grid.text(paste0(sprintf("%.2f", cor_mat[i, j]),"*"), x, y, gp = gpar(fontsize = 8))
  }
}



Heatmap(m, rect_gp = gpar(type = "none"),
        column_dend_side = "bottom",row_names_side = "left",
        cell_fun = function(j, i, x, y, w, h, fill) {
          if(as.numeric(x) <= 1 - as.numeric(y) + 1e-6) {
            grid.rect(x, y, w, h, gp = gpar(fill = fill, col = fill))
          }
        })

ComplexHeatmap::Heatmap(m,rect_gp = gpar(type = "none"),
                        column_dend_side = "bottom",row_names_side = "left",
                        name="value",
                        cell_fun = cell_fun,
                        cluster_rows = T, cluster_columns = T)


library(circlize)
col1 = colorRamp2(c(-1, 0, 1), c("green", "black", "red"))
col2 = colorRamp2(c(-1, 0, 1), c("purple", "white", "orange"))



cell_fun2 = function(j, i, x, y, w, h, fill){
  xy_numeric <- as.numeric(x) <= 1 - as.numeric(y) + 1e-6
  if(i <= j) {
    grid.rect(x, y, w, h, gp = gpar(fill = fill, col = fill))
    if (!is.na(cor_p[i, j]) && !is.na(xy_numeric) && cor_p[i, j] < 0.01){
      grid.text(paste0(sprintf("%.2f", cor_mat[i, j]),"**"), x, y,gp = gpar(fontsize =6))
    } else if (!is.na(cor_p[i, j]) && !is.na(xy_numeric) && cor_p[i, j] <= 0.05) {
      grid.text(paste0(sprintf("%.2f", cor_mat[i, j]),"*"), x, y, gp = gpar(fontsize = 6))
    }
  }
}


ht1 <- Heatmap(m, rect_gp = gpar(type = "none"), col = col2,
               cluster_rows = F, cluster_columns = F,
               cell_fun = cell_fun2,name="value1",
               row_names_gp = gpar(col="white"),
               column_names_gp = gpar(fontsize=10),
               column_names_side = "top",row_names_side ="right")

ht2 <- Heatmap(m, rect_gp = gpar(type = "none"),
               cluster_rows = F, cluster_columns = F,
               row_names_gp = gpar(fontsize=10),
               column_names_gp = gpar(col="white"),
               cell_fun = cell_fun,name="value2",row_names_side="left")

draw(ht2 + ht1, ht_gap = unit(-90, "mm"))

