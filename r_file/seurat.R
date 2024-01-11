
# libraries

library("argparse")
library("findpython")
library("hdf5r")
library("sp")
library("SeuratObject")
library("Seurat")



# parse data
args = commandArgs(trailingOnly=TRUE)



seurat_obj <- Read10X_h5(args[1],
                             use.names = TRUE,
                             unique.features = TRUE)

Seurat <- CreateSeuratObject(counts = seurat_obj)




#% MT reads----------------------------------
Seurat[["percent.mt"]] <- PercentageFeatureSet(Seurat, pattern = "^MT-")



#Filtering---------------------------------
Seurat <- subset(Seurat, subset =percent.mt < 12)




#3. Normalize data--------------------------
Seurat <- NormalizeData(Seurat)
print("normalization done")


#4. Identify highly variable features------------------
Seurat <- FindVariableFeatures(Seurat, selection.method = "vst", nfeatures = 2000)
print("features done")



#5. Scaling--------------------------
all.genes <- rownames(Seurat)
Seurat <- ScaleData(Seurat, features = all.genes)
print("scaling done")


saveRDS(Seurat_, file = args[2])
write.table(out, scaling$output)
