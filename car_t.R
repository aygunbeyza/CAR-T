
# libraries
#equire(sp)
#.libPaths("/Library/Frameworks/R.framework/Versions/4.2/Resources/library")
library("argparse")
library("findpython")
library("hdf5r")
library("sp")
library("SeuratObject")
library("Seurat")


#rule read10X_h5----------------------

# parse data
args = commandArgs(trailingOnly=TRUE)



GSM3489182_obj <- Read10X_h5(args[1],
                             use.names = TRUE,
                             unique.features = TRUE)

Seurat_GSM3489182 <- CreateSeuratObject(counts = GSM3489182_obj)




#% MT reads----------------------------------
Seurat_GSM3489182[["percent.mt"]] <- PercentageFeatureSet(Seurat_GSM3489182, pattern = "^MT-")



#Filtering---------------------------------
Seurat_GSM3489182 <- subset(Seurat_GSM3489182, subset =percent.mt < 12)




#3. Normalize data--------------------------
Seurat_GSM3489182 <- NormalizeData(Seurat_GSM3489182)
print("normalization done")


#4. Identify highly variable features------------------
Seurat_GSM3489182 <- FindVariableFeatures(Seurat_GSM3489182, selection.method = "vst", nfeatures = 2000)
print("features done")



#5. Scaling--------------------------
all.genes <- rownames(Seurat_GSM3489182)
Seurat_GSM3489182 <- ScaleData(Seurat_GSM3489182, features = all.genes)
print("scaling done")


saveRDS(Seurat_GSM3489182, file = args[2])
write.table(out, scaling$output)
