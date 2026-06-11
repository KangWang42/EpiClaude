####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("pheatmap")


library(pheatmap)          
inputFile="input.txt"      
groupFile="group.txt"  #分组文件   
outFile="heatmap.pdf"      
setwd("D:\\biowolf\\bioR\\17.heatmap")      
rt=read.table(inputFile,header=T,sep="\t",row.names=1,check.names=F)     #读取文件
ann=read.table(groupFile,header=T,sep="\t",row.names=1,check.names=F)    #读取样本属性文件


#绘制
pdf(file=outFile,width=6,height=5.5)
pheatmap(rt,
         annotation=ann,
         cluster_cols = T,
         color = colorRampPalette(c("blue", "white", "red"))(50),
         show_colnames = T,
         scale="row",  #矫正
         #border_color ="NA",
         fontsize = 8,
         fontsize_row=6,
         fontsize_col=6)
dev.off()

