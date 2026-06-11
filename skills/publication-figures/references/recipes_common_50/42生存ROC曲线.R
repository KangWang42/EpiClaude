####公众号:医学学霸帮####

####公众号:医学学霸帮####



#install.packages("survival")
#install.packages("survminer")
#install.packages("timeROC")



library(survival)
library(survminer)
library(timeROC)

inputFile="input.txt"      
outFile="ROC.pdf"          
var="score"                #需要的变量
setwd("D:\\biowolf\\bioR\\42.timeROC")    

#读取
rt=read.table(inputFile, header=T, sep="\t", check.names=F)

#绘制
ROC_rt=timeROC(T=rt$futime, delta=rt$fustat,
	           marker=rt[,var], cause=1,
	           weighting='aalen',
	           times=c(1), ROC=TRUE) #预测时间1年
pdf(file=outFile, width=5, height=5)
plot(ROC_rt, time=1, col='red', title=FALSE, lwd=2)
text(0.65,0.45,paste0('AUC = ',sprintf("%.03f",ROC_rt$AUC[2])),cex=1.2)
dev.off()


