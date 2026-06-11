####公众号:医学学霸帮####

####公众号:医学学霸帮####




#source("https://neuroconductor.org/neurocLite.R")
#neuro_install("gganatogram")

#install.packages("devtools")
#library(devtools)
#devtools::install_github("jespermaag/gganatogram")



library(gganatogram)
library(dplyr)
library(viridis)
library(gridExtra)

inputFile="male.txt"           
outFile="gganatogram.pdf"     
gender="male"                 
setwd("D:\\biowolf\\bioR\\51.gganatogram")    
rt=read.table(inputFile, header=T, sep="\t", check.names=F, stringsAsFactors=F)     #??ȡ?????ļ?


pdf(outFile,width=8,height=6)
gganatogram(data=rt, fillOutline='white', organism='human', sex=gender, fill="value")+ theme_void() +
    scale_fill_gradient2(low = "green", mid="black", high = "red",midpoint = 3)
dev.off()


