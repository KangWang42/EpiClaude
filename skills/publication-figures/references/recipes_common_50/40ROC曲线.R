####公众号:医学学霸帮####

####公众号:医学学霸帮####



#install.packages("pROC")


library(pROC)             
inputFile="input.txt"      
outFile="ROC.pdf"         
x="TTYH3"                  #用于ROC的变量
setwd("D:\\biowolf\\bioR\\40.ROC")   

#读入文件，整理
rt=read.table(inputFile,header=T,sep="\t",check.names=F,row.names=1)
y=colnames(rt)[1]

#绘制
rocobj1=roc(rt[,y], as.vector(rt[,x]))
pdf(file=outFile,width=5,height=5)
plot(rocobj1, print.auc=TRUE, col="red")
dev.off()

