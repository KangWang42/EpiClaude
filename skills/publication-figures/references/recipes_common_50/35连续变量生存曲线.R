####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("survival")
#install.packages("survminer")


#引用
library(survival)
library(survminer)
inputFile="input.txt"        
outFile="survival.pdf"       
var="MATN3"                   #用于生存分析的变量
setwd("D:\\biowolf\\bioR\\35.survivalContinuous")      


rt=read.table(inputFile, header=T, sep="\t", check.names=F)
rt=rt[,c("futime","fustat",var)]

#根据中位值，把样品分为两组
group=ifelse(rt[,3]>median(rt[,3]),"High","Low")
diff=survdiff(Surv(futime, fustat) ~group,data = rt)
pValue=1-pchisq(diff$chisq,df=1)
if(pValue<0.001){
	pValue="p<0.001"
}else{
	pValue=paste0("p=",sprintf("%.03f",pValue))
}
fit <- survfit(Surv(futime, fustat) ~ group, data = rt) #剩余数目
		
#绘制
surPlot=ggsurvplot(fit, 
		           data=rt,
		           conf.int=TRUE,
		           pval=pValue,
		           pval.size=5,
		           legend.labs=c("High", "Low"),
		           legend.title=var,
		           xlab="Time(years)",
		           break.time.by = 1,
		           risk.table.title="",
		           palette=c("red", "blue"),
		           risk.table=T,
		           risk.table.height=.25)
pdf(file=outFile,onefile = FALSE,width = 6,height =5)
print(surPlot)
dev.off()



