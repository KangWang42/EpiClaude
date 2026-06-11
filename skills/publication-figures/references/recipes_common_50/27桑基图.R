####公众号:医学学霸帮####

####公众号:医学学霸帮####



#install.packages("ggplot2")
#install.packages("ggalluvial")


library(ggalluvial)
library(ggplot2)
library(dplyr)

inputFile="input.txt"         
outFile="ggalluvial.pdf"    
setwd("D:\\biowolf\\bioR\\27.ggalluvial")          
rt=read.table(inputFile, header = T, sep="\t", check.names=F)     
corLodes=to_lodes_form(rt, axes = 1:ncol(rt), id = "Cohort")

#得到输出文件
pdf(file=outFile,width=7,height=6)
mycol <- rep(c("#029149","#6E568C","#E0367A","#D8D155","#223D6C","#D20A13","#431A3D","#91612D","#FFD121","#088247","#11AA4D","#58CDD9","#7A142C","#5D90BA","#64495D","#7CC767"),15)
ggplot(corLodes, aes(x = x, stratum = stratum, alluvium = Cohort,fill = stratum, label = stratum)) +
  	 scale_x_discrete(expand = c(0, 0)) +  
  	 #用aes.flow控制线调颜色，forward说明颜色和前面一致，backward说明与后面一致
  	 geom_flow(width = 2/10,aes.flow = "forward") + 
	 geom_stratum(alpha = .9,width = 2/10) +
	 scale_fill_manual(values = mycol) +
	 #size = 2代表基因名字大小
	 geom_text(stat = "stratum", size = 2,color="black") +
	 xlab("") + ylab("") + theme_bw() + 
	 theme(axis.line = element_blank(),axis.ticks = element_blank(),axis.text.y = element_blank()) + #ȥ????????
	 theme(panel.grid =element_blank()) + 
	 theme(panel.border = element_blank()) + 
	 ggtitle("") + guides(fill = FALSE)                            
dev.off()



