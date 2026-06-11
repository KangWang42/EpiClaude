####公众号:医学学霸帮####

####公众号:医学学霸帮####



#install.packages("ggpubr")


library(ggpubr)              
inputFile="input.txt"        
outFile="Deviation.pdf"      
setwd("D:\\biowolf\\bioR\\16.Deviation")    

#读取
rt=read.table(inputFile,sep="\t",header=T,check.names=F)
x=colnames(rt)[1]
y=colnames(rt)[2]
colnames(rt)=c("Name","Value")
rt$Regulate=factor(ifelse(rt$Value<0, "Down", "Up"), levels = c("Up", "Down"))

#绘制
pdf(file=outFile,width=6,height=5)
ggbarplot(rt, x="Name", y="Value", fill = "Regulate", color = "white", 
          palette = "jco", 
          sort.val = "desc", sort.by.groups = FALSE, 
          x.text.angle=90, 
          xlab = x, ylab = y,
          legend.title="Regulate", rotate=TRUE, ggtheme = theme_minimal())   #rotatex设置x/y对调
dev.off()


