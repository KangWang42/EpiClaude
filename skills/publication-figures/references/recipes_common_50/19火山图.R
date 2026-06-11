####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggplot2")


library(ggplot2)          
inputFile="input.txt"      
outFile="vol.pdf"          
logFCfilter=1               #logFC过滤阈值
fdrFilter=0.05              #矫正后p值阈值ֵ
setwd("D:\\biowolf\\Desktop\\bioR\\19.vol")      #设置工作目录

#读取文件
rt=read.table(inputFile,sep="\t",header=T,check.names=F)

#定义显著性
Significant=ifelse((rt$fdr<fdrFilter & abs(rt$logFC)>logFCfilter), ifelse(rt$logFC>logFCfilter,"Up","Down"), "Not")
#绘制火山图
p = ggplot(rt, aes(logFC, -log10(fdr)))+
    geom_point(aes(col=Significant))+
    scale_color_manual(values=c("green", "black", "red"))+
    labs(title = " ")+
    theme(plot.title = element_text(size = 16, hjust = 0.5, face = "bold"))
p=p+theme_bw()

#出图
pdf(outFile,width=5.5,height=4.5)
print(p)
dev.off()


