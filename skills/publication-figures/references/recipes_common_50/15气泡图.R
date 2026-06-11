####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggpubr")


library(ggpubr)                 
inputFile="input.txt"           
outFile="ggballoonplot.pdf"     #输出文件
setwd("D:\\biowolf\\bioR\\15.ggballoonplot")       
data=read.table(inputFile,header=T,sep="\t",check.names=F,row.names=1)     #??ȡ?????ļ?

#绘制气泡图
pdf(file=outFile,width=8,height=7)
ggballoonplot(data, fill = 'value')+gradient_fill(c('blue', 'white', 'red'))
dev.off()

