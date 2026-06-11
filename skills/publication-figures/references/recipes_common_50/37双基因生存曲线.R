####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("survival")
#install.packages("survminer")



library(survival)
library(survminer)
inputFile="input.txt"         
outFile="survival.pdf"        
var1="VCAN"                   #用于生存分析的变量1
var2="CXCR4"                  #用于生存分析的变量2
setwd("D:\\biowolf\\bioR\\37.survival2vars")      


rt=read.table(inputFile, header=T, sep="\t", check.names=F)

#根据基因表达，对数据分组
a=ifelse(rt[,var1]<median(rt[,var1]),paste0(var1," low"),paste0(var1," high"))
b=ifelse(rt[,var2]<median(rt[,var2]),paste0(var2," low"),paste0(var2," high"))
Type=paste(a,"+",b)
rt=cbind(rt,Type)

#生存差异统计
length=length(levels(factor(Type)))
diff=survdiff(Surv(futime, fustat) ~Type,data = rt)
pValue=1-pchisq(diff$chisq,df=length-1)
if(pValue<0.001){
	pValue="p<0.001"
}else{
	pValue=paste0("p=",sprintf("%.03f",pValue))
}
fit <- survfit(Surv(futime, fustat) ~ Type, data = rt)
		
#绘制生存曲线
surPlot=ggsurvplot(fit, 
		           data=rt,
		           conf.int=F,  #不含置信区间
		           pval=pValue,
		           pval.size=5,
		           legend.labs=levels(factor(rt[,"Type"])),
		           legend.title="Type",
		           #font.legend=6,
		           legend = "right",
		           xlab="Time(years)",
		           break.time.by = 1,
		           risk.table.title="",
		           risk.table=F,     #风险表格
		           risk.table.height=.25)
pdf(file=outFile,onefile = FALSE,width = 7.5,height =5)
print(surPlot)
dev.off()


