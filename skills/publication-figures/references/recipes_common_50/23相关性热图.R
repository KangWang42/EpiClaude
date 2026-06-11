####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("corrplot")

rm(list=ls())
library(corrplot)           
inputFile="input.txt"       
setwd("D:\\3-VSCODE\\1-R\\2 统计方法\\1 付费资料\\2 code_50_visual\\23相关性热图") 

rt=read.table(inputFile,sep="\t",header=T,row.names=1)      #读取文件
rt=t(rt)      #数据转置
M=cor(rt)     #相关型矩阵

#绘制相关性图形

corrplot(M,
         method = "circle",
         order = "hclust", #聚类
         type = "upper",
         col=colorRampPalette(c("green", "white", "red"))(50)
         )




#第二个图

corrplot(M,
         order="original",
         method = "color",
         number.cex = 0.7, #相关系数
         addCoef.col = "black",
         diag = TRUE,
         tl.col="black",
         col=colorRampPalette(c("blue", "white", "red"))(50))


