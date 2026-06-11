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
var="score"               
setwd("D:\\biowolf\\bioR\\43.multiTimeROC")      


rt=read.table(inputFile, header=T, sep="\t", check.names=F)

#绘制
ROC_rt=timeROC(T=rt$futime, delta=rt$fustat,
	           marker=rt[,var], cause=1,
	           weighting='aalen',
	           times=c(1,2,3), ROC=TRUE)
pdf(file=outFile,width=5,height=5)
plot(ROC_rt,time=1,col='green',title=FALSE,lwd=2)
plot(ROC_rt,time=2,col='blue',add=TRUE,title=FALSE,lwd=2)
plot(ROC_rt,time=3,col='red',add=TRUE,title=FALSE,lwd=2)
legend('bottomright',
	   c(paste0('AUC at 1 years: ',sprintf("%.03f",ROC_rt$AUC[1])),
	     paste0('AUC at 2 years: ',sprintf("%.03f",ROC_rt$AUC[2])),
	     paste0('AUC at 3 years: ',sprintf("%.03f",ROC_rt$AUC[3]))),
	     col=c("green",'blue','red'),lwd=2,bty = 'n')
dev.off()


