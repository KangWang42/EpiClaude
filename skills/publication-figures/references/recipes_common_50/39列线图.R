####公众号:医学学霸帮####

####公众号:医学学霸帮####



#install.packages("rms")


library(rms)                
inputFile="input.txt"        
setwd("D:\\biowolf\\bioR\\39.Nomo")       


rt=read.table(inputFile,header=T,sep="\t",check.names=F,row.names=1)

#数据打包
dd <- datadist(rt)
options(datadist="dd")
#生成函数
f <- cph(Surv(futime, fustat) ~ Age+Gender+Grade+T+M+N+VCAN, x=T, y=T, surv=T, data=rt, time.inc=1)
surv <- Survival(f)
#建立nomogram
nom <- nomogram(f, fun=list(function(x) surv(1, x), function(x) surv(2, x), function(x) surv(3, x)), 
    lp=F, funlabel=c("1-year survival", "2-year survival", "3-year survival"), 
    maxscale=100, 
    fun.at=c(0.99, 0.9, 0.8, 0.7, 0.5, 0.3,0.1,0.01))  

#nomogram可视化
pdf(file="Nomogram.pdf",height=7,width=8.5)
plot(nom)
dev.off()

#calibration curve
time=3   #预测三年calibration
f <- cph(Surv(futime, fustat) ~ Age+Gender+Grade+T+M+N+VCAN, x=T, y=T, surv=T, data=rt, time.inc=time)
cal <- calibrate(f, cmethod="KM", method="boot", u=time, m=100, B=1000) #m样品数目1/3
pdf(file="calibration.pdf",height=6,width=7)
plot(cal,xlab="Nomogram-Predicted Probability of 3-Year OS",ylab="Actual 3-Year OS(proportion)",col="red",sub=F)
dev.off()


