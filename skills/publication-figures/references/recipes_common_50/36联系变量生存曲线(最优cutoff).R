####公众号:医学学霸帮####

####公众号:医学学霸帮####



#install.packages("survival")
#install.packages("survminer")



library(survival)
library(survminer)
inputFile="input.txt"        
outFile="survival.pdf"      
var="MATN3"                  
setwd("D:\\biowolf\\bioR\\36.survivalCutoff")     


rt=read.table(inputFile, header=T, sep="\t", check.names=F)
rt=rt[,c("futime","fustat",var)]
colnames(rt)=c("futime","fustat","var")

#获取最优cutoff
res.cut=surv_cutpoint(rt, time = "futime", event = "fustat",variables =c("var"))
res.cut
res.cat=surv_categorize(res.cut)
fit=survfit(Surv(futime, fustat) ~var, data = res.cat)

#比较高低表达生存差异
diff=survdiff(Surv(futime, fustat) ~var,data =res.cat)
pValue=1-pchisq(diff$chisq,df=1)
if(pValue<0.001){
	pValue="p<0.001"
}else{
	pValue=paste0("p=",sprintf("%.03f",pValue))
}
		
#绘制
surPlot=ggsurvplot(fit, 
		           data=res.cat,
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


