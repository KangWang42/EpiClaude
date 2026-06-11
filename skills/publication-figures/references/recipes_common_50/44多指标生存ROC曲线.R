####公众号:医学学霸帮####

####公众号:医学学霸帮####





library(survival)
library(survminer)
library(timeROC)

inputFile="input.txt"    
outFile="ROC.pdf"       
setwd("D:\\biowolf\\bioR\\44.multiVarTimeROC")     


rt=read.table(inputFile, header=T, sep="\t", check.names=F, row.names=1)

#颜色
bioCol=rainbow(ncol(rt)-2)

#绘制
aucText=c()
pdf(file=outFile,width=6,height=6)
i=3
ROC_rt=timeROC(T=rt$futime,delta=rt$fustat,marker=rt[,i],cause=1,weighting='aalen',times=c(1),ROC=TRUE)
plot(ROC_rt,time=1,col=bioCol[i-2],title=FALSE,lwd=2)
aucText=c(paste0(colnames(rt)[i],", AUC=",sprintf("%.3f",ROC_rt$AUC[2])))
abline(0,1)

for(i in 4:ncol(rt)){
	ROC_rt=timeROC(T=rt$futime,delta=rt$fustat,marker=rt[,i],cause=1,weighting='aalen',times=c(1),ROC=TRUE)
	plot(ROC_rt,time=1,col=bioCol[i-2],title=FALSE,lwd=2,add=TRUE)
	aucText=c(aucText,paste0(colnames(rt)[i],", AUC=",sprintf("%.3f",ROC_rt$AUC[2])))
}
legend("bottomright", aucText,lwd=2,bty="n",col=bioCol[1:(ncol(rt)-2)])
dev.off()

