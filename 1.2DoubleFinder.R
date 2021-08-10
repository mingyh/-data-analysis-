library(Seurat)
library(tidyverse)
library(DoubletFinder)


test=read.table("testCount.txt",header = T,row.names = 1,sep = "\t")

test.seu <- CreateSeuratObject(counts = test)
test.seu <- NormalizeData(test.seu, normalization.method = "LogNormalize", scale.factor = 10000)
test.seu <- FindVariableFeatures(test.seu, selection.method = "vst", nfeatures = 2000)
test.seu <- ScaleData(test.seu, features = rownames(test.seu))
test.seu <- RunPCA(test.seu, features = VariableFeatures(test.seu),npcs = 50)
test.seu <- FindNeighbors(test.seu, dims = 1:20)
test.seu <- FindClusters(test.seu, resolution = 0.5)
test.seu <- RunUMAP(test.seu, dims = 1:20)
test.seu <- RunTSNE(test.seu, dims = 1:20)

sweep.res.list <- paramSweep_v3(test.seu, PCs = 1:10, sct = FALSE)
for(i in 1:length(sweep.res.list)){
  if(length(sweep.res.list[[i]]$pANN[is.nan(sweep.res.list[[i]]$pANN)]) != 0){
    if(i != 1){
      sweep.res.list[[i]] <- sweep.res.list[[i - 1]]
    }else{
      sweep.res.list[[i]] <- sweep.res.list[[i + 1]]
    }
  }
}
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pk_v <- as.numeric(as.character(bcmvn$pK))
pk_good <- pk_v[bcmvn$BCmetric==max(bcmvn$BCmetric)]

nExp_poi <- round(0.1*length(colnames(test.seu)))

test.seu <- doubletFinder_v3(test.seu, PCs = 1:10, pN = 0.25, pK = pk_good, nExp = nExp_poi, reuse.pANN = FALSE, sct = FALSE)

colnames(test.seu@meta.data)[ncol(test.seu@meta.data)]="DoubletFinder"

test.seu@meta.data$CB=rownames(test.seu@meta.data)
DF_df <- test.seu@meta.data[,c("CB","DoubletFinder")]
write.table(DF_df, file = "DoubletFinder_result.txt", quote = FALSE, sep = '\t', row.names = FALSE, col.names = TRUE)
DimPlot(test.seu,reduction = "tsne",pt.size = 2,group.by = "DoubletFinder")
ggsave("doubleFinder_tmp.png")