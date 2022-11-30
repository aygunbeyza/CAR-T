#get sample id and directories
setwd("~/Desktop/Bioinformatic/Car-T/SRP238929/K_quant")
base_dir <- "./quant"
sample_id <- dir(file.path(base_dir))
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, id))
condition_df <- read.delim("SraRunTable.txt", sep = ",")
s2c <- data.frame(path=kal_dirs,sample=sample_id,condition=condition_df,row.names = NULL,stringsAsFactors = FALSE)
#ensmeble mart
#mart <- biomaRt::useMart(biomart = "ENSEMBL_MART_ENSEMBL",dataset = "hsapiens_gene_ensembl",host = 'ensembl.org')
#t2g <- biomaRt::getBM( attributes = c("ensembl_transcript_id", "transcript_version", "ensembl_gene_id", "external_gense_name", "description","transcript_biotype"),mart = mart)
#t2g <- dplyr::rename(t2g, target_id = ensembl_transcript_id,ens_gene = ensembl_gene_id, ext_gene = external_gene_name)

#merge txt file
library(reshape)
setwd("~/Desktop/Bioinformatic/Car-T/SRP238929/K_quant/abundace/")
file_list <- list.files()

list_of_files <- data.frame(lapply(file_list, read.csv, sep="\t"))# Read in each file if its a csv file or `read.table` or `read.delim`
#subset the dataframe into 2 and add abundance data to them  ARE DATAFRAME!!

library(data.table)
#1kontrol
#birlşetirme
SRR10777215<-subset(list_of_files, select = c(target_id, tpm))
SRR10777216<-subset(list_of_files, select=c(target_id.1, tpm.1))
names(SRR10777216) [1] <- "target_id"
target_and_tpm1<-merge(SRR10777215, SRR10777216, by= "target_id", all.x = TRUE)
library(stringr)
target_and_tpm1$target_id<-gsub("\\.[0−9]*$","",(target_and_tpm1$target_id))


library(tidyverse)
#fit
#so <- sleuth_prep(s2c, target_mapping = a, aggregation_column = 'ext_gene', gene_mode = TRUE, extra_bootstrap_summary = TRUE)
#so <- sleuth_fit(so)
#so <- sleuth_wt(so,which_beta="timepointt24h")
#sleuth_live(so)
#matrix
library(biomaRt)
ensembl <- useEnsembl(biomart = "genes", dataset = "hsapiens_gene_ensembl")
a <- biomaRt::getBM( attributes = c("ensembl_transcript_id", "transcript_version", "ensembl_gene_id", "external_gene_name", "description","transcript_biotype"),mart = ensembl)
a <- dplyr::rename(a, target_id = ensembl_transcript_id,ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
son<-merge(target_and_tpm1, a, by= "target_id", all.x = TRUE,all.y = TRUE)

write.table(son, 'count_son.txt', col.names = TRUE)



