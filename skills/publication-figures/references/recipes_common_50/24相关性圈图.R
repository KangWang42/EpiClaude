####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("corrplot")
#install.packages("circlize")


#引用包
options(stringsAsFactors=F)
library(corrplot)
library(circlize)

inputFile="input.txt"     
outFile="circos.pdf"      
setwd("D:\\biowolf\\bioR\\24.corCircos")   

#读取输入文件
rt=read.table(inputFile,sep="\t",header=T,check.names=F,row.names=1)
rt=t(rt)  #转置

#计算基因间相关系数
cor1=cor(rt)

#设置图形颜色
col = c(rgb(1,0,0,seq(1,0,length=32)),rgb(0,1,0,seq(0,1,length=32)))
cor1[cor1==1]=0  #删掉相关性=1
c1 = ifelse(c(cor1)>=0,rgb(1,0,0,abs(cor1)),rgb(0,1,0,abs(cor1)))
col1 = matrix(c1,nc=ncol(rt))

#绘制圈图
pdf(outFile,width=7,height=7)
par(mar=c(2,2,2,4))
circos.par(gap.degree=c(3,rep(2, nrow(cor1)-1)), start.degree = 180)
chordDiagram(cor1, grid.col=rainbow(ncol(rt)), col=col1, transparency = 0.5, symmetric = T)
par(xpd=T)
colorlegend(col, vertical = T,labels=c(1,0,-1),xlim=c(1.1,1.3),ylim=c(-0.4,0.4))       #????ͼ??
dev.off()
circos.clear()


