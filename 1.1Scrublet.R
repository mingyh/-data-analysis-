library(Seurat)
library(tidyverse)


test=read.table("testCount.txt",header = T,row.names = 1,sep = "\t")
SR_df=read.table("Scrublet_result.txt",header = T,sep = "\t",stringsAsFactors = F)

test.seu <- CreateSeuratObject(counts = test)
#Normalize
test.seu <- NormalizeData(test.seu, normalization.method = "LogNormalize", scale.factor = 10000)
#FindVariableFeatures
test.seu <- FindVariableFeatures(test.seu, selection.method = "vst", nfeatures = 2000)
#Scale
test.seu <- ScaleData(test.seu, features = rownames(test.seu))
#PCA
test.seu <- RunPCA(test.seu, features = VariableFeatures(test.seu),npcs = 50)
#cluster
test.seu <- FindNeighbors(test.seu, dims = 1:20)
test.seu <- FindClusters(test.seu, resolution = 0.5)
test.seu <- RunUMAP(test.seu, dims = 1:20)
test.seu <- RunTSNE(test.seu, dims = 1:20)

test.seu@meta.data$CB=rownames(test.seu@meta.data)
test.seu@meta.data=inner_join(test.seu@meta.data,SR_df,by="CB")
rownames(test.seu@meta.data)=test.seu@meta.data$CB
DimPlot(test.seu,reduction = "pca",pt.size = 2,group.by = "Scrublet")
ggsave("scrublet_tmp.png")