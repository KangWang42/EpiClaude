####公众号:医学学霸帮####

####公众号:医学学霸帮####


#本节课的代码注释可以参考KEGG圈图，都是一样的


#install.packages("colorspace")
#install.packages("stringi")
#install.packages("ggplot2")
#install.packages("digest")
#install.packages("GOplot")

#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("org.Hs.eg.db")  #直接输进百度即可
#BiocManager::install("DOSE")
#BiocManager::install("clusterProfiler")
#BiocManager::install("enrichplot")



library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(ggplot2)
library(GOplot)

#过滤
pFilter=0.05
adjPfilter=0.05

inputFile="input.txt"
setwd("D:\\biowolf\\bioR\\31.GOcircos")           
rt=read.table(inputFile,sep="\t",header=T,check.names=F)       
genes=as.vector(rt[,1])
entrezIDs=mget(genes, org.Hs.egSYMBOL2EG, ifnotfound=NA)        #找出基因对应的id
entrezIDs=as.character(entrezIDs)
rt=cbind(rt,entrezID=entrezIDs)
rt=rt[is.na(rt[,"entrezID"])==F,]                               #删掉没有基因ID的
gene=rt$entrezID

#GO
GO=enrichGO(gene = gene,
            OrgDb = org.Hs.eg.db, 
            pvalueCutoff =1, 
            qvalueCutoff = 1,
            ont="all",
            readable =T)
GO=as.data.frame(GO)
GO=GO[(GO$pvalue<pFilter & GO$p.adjust<adjPfilter),]
write.table(GO,file="GO.txt",sep="\t",quote=F,row.names = F)       #

#??ȡGO??Ϣ
go=data.frame(Category = GO$ONTOLOGY,ID = GO$ID,Term = GO$Description, Genes = gsub("/", ", ", GO$geneID), adj_pval = GO$p.adjust)
#??ȡ??????logFC
genelist=data.frame(ID = rt$gene, logFC = rt$logFC)
row.names(genelist)=genelist[,1]

circ <- circle_dat(go, genelist)
termNum = 5                                     #限定GO数目
termNum=ifelse(nrow(go)<termNum,nrow(go),termNum)
geneNum = nrow(genelist)                        #限定基因数目

#绘制
chord <- chord_dat(circ, genelist[1:geneNum,], go$Term[1:termNum])
pdf(file="GOcircos.pdf",width = 10,height = 10.2)
GOChord(chord, 
        space = 0.001,           #基因之间的间距
        gene.order = 'logFC',    #排序基因
        gene.space = 0.25,       #基因离圆圈距离
        gene.size = 3,           #
        border.size = 0.1,     
        process.label = 7)       #GO名称大小
dev.off()

#聚类圈图
pdf(file="GOcluster.pdf",width = 12,height = 9)
GOCluster(circ, as.character(go[1:termNum,3]))
dev.off()



