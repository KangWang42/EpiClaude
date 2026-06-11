####公众号:医学学霸帮####

####公众号:医学学霸帮####



#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("karyoploteR")  #百度即可


library(karyoploteR)       
inputFile="input.txt"      
outFile="genome.pdf"       
setwd("D:\\biowolf\\bioR\\48.genome")             
rt=read.table(inputFile, header=T, sep="\t", check.names=F)    

#提取数据
data.points=makeGRangesFromDataFrame(rt)
mcols(data.points)=data.frame(y=rt[,4])

#可视化
ymin=quantile(rt[,4],0.1)
ymax=quantile(rt[,4],0.9)*2
pdf(file=outFile, width=10, height=7)
kp=plotKaryotype("hg38", plot.type=1)
kpDataBackground(kp, data.panel=1, color="white")
kpPoints(kp, data=data.points, pch=".", col="red", ymin=ymin, ymax=ymax, cex=6)
kpAddBaseNumbers(kp, tick.dist=10000000, minor.tick.dist=1000000)
dev.off()


