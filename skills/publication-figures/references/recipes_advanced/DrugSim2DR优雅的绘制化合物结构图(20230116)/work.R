# BiocManager::install("ChemmineR")
# install.packages("DrugSim2DR")
library(DrugSim2DR)
library(ChemmineR)
library(rvest)
GEP<-Gettest("GEP")

plotDrugstructure("DB01048")
plotDrugstructure("DB00780")


label<-Gettest("label")
# Calculate the zscore
DEscore<-CalDEscore(GEP,label)

drug_similarity<-DrugSimscore(DEscore,nperm = 0)
###view first ten drugs result
drug_similarity[1:5,]
