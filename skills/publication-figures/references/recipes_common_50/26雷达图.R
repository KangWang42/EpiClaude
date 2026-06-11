####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("fmsb")


library(fmsb)             
inputFile="input.txt"     
outFile="radar.pdf"       
col="red"                 #定义颜色
setwd("D:\\biowolf\\bioR\\26.radar")      

data=read.table(inputFile,header=T,sep="\t",row.names=1,check.names=F)    
data=as.data.frame(t(data))       #转置
maxValue=ceiling(max(abs(data))*10)/10  #设置刻度
data=rbind(rep(maxValue,ncol(data)),rep(-maxValue,ncol(data)),data)

#输出结果
pdf(file=outFile,height=7,width=7)
radarchart( data, axistype=1, 
            pcol=col,                    #线条颜色
            plwd=2 ,                     #线条粗细
            plty=1,                      #虚线，实线
            cglcol="grey",               #背景线条颜色
            cglty=1,                     #背景线条虚线，实线1
            caxislabels=seq(-maxValue,maxValue,maxValue/2),    #坐标刻度
            cglwd=1.2,                   #背景线条粗细
            axislabcol="blue",           #刻度颜色
            vlcex=0.8                    #字体大小
)
dev.off()



