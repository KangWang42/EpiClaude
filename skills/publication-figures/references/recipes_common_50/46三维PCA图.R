####公众号:医学学霸帮####

####公众号:医学学霸帮####




#install.packages("scatterplot3d")


library(scatterplot3d)      
inputFile="input.txt"      
outFile="PCA.pdf"          
setwd("D:\\biowolf\\bioR\\46.3dPCA")    

rt=read.table(inputFile,header=T,sep="\t",check.names=F,row.names=1)
data=rt[,c(2:ncol(rt))]
Type=rt[,1]  #提取分组信息
var=colnames(rt)[1]

#颜色
group=levels(factor(Type))
bioCol=c("red","blue","green","yellow")
col= bioCol[match(Type,group)]

#PCA分析
data.pca=prcomp(data, scale. = TRUE)
pcaPredict=predict(data.pca)

#绘制
pdf(file=outFile, height=5, width=6)
par(oma=c(0.5,0.5,0.5,0.5))
s3d=scatterplot3d(pcaPredict[,1:3], pch = 16, color=col)
legend("top", legend =group,pch = 16, inset = -0.2, box.col="white",xpd = TRUE, horiz = TRUE,col=bioCol[1:length(group)])
dev.off()


