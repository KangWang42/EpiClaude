####公众号:医学学霸帮####

####公众号:医学学霸帮####


inputFile="input.txt"       #输入
outFile="barplot.pdf"       #输出
setwd("D:\\biowolf\\bioR\\04.barplotPerent")    #工作目录

#读取文件，整理
data=read.table(inputFile,sep="\t",header=T,row.names=1,check.names=F)
data=t(data)  
col=rainbow(nrow(data),s=0.7,v=0.7)

#绘制
pdf(outFile,height=10,width=20)
par(las=1,mar=c(8,5,4,16),mgp=c(3,0.1,0),cex.axis=1.5)
a1=barplot(data,col=col,yaxt="n",ylab="Relative Percent",xaxt="n",cex.lab=1.8)
a2=axis(2,tick=F,labels=F)
axis(2,a2,paste0(a2*100,"%"))
axis(1,a1,labels=F)
par(srt=60,xpd=T);text(a1,-0.02,colnames(data),adj=1,cex=0.6);par(srt=0)
ytick2 = cumsum(data[,ncol(data)])
ytick1 = c(0,ytick2[-length(ytick2)])
legend(par('usr')[2]*0.98,par('usr')[4],legend=rownames(data),col=col,pch=15,bty="n",cex=1.3)
dev.off()


######Video source: https://ke.biowolf.cn
######??????ѧ??: https://www.biowolf.cn/
######΢?Ź??ںţ?biowolf_cn
######???????䣺biowolf@foxmail.com
######????΢??: 18520221056
