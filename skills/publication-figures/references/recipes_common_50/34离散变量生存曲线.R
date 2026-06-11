####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("survival")
#install.packages("survminer")


#引用包
library(survival)
library(survminer)
inputFile="input.txt"         
outFile="survival.pdf"        
var="Stage"                   #用于生存分析的变量
setwd("D:\\biowolf\\bioR\\34.survivalDiscrete")     #设置工作目录

#读取
rt=read.table(inputFile, header=T, sep="\t", check.names=F)
rt=rt[,c("futime","fustat",var)]
colnames(rt)[3]="Type"
groupNum=length(levels(factor(rt[,"Type"])))

#比较组间生存差异的P值
diff=survdiff(Surv(futime, fustat) ~Type,data = rt)
pValue=1-pchisq(diff$chisq,df=(groupNum-1))  #df自由度
if(pValue<0.001){
	pValue="p<0.001"
}else{
	pValue=paste0("p=",sprintf(".03f",pValue))
}
fit <- survfit(Surv(futime, fustat) ~ Type, data = rt)
		
#绘制
surPlot=ggsurvplot(fit, 
		           data=rt,
		           conf.int=F,  #置信区间
		           pval=pValue,
		           pval.size=5,
		           legend.labs=levels(factor(rt[,"Type"])),
		           legend.title=var,
		           xlab="Time(years)",
		           break.time.by = 1,
		           risk.table.title="",
		           risk.table=F,
		           risk.table.height=.25)
pdf(file=outFile,onefile = FALSE,width = 5,height =4.5)
print(surPlot)
dev.off()


