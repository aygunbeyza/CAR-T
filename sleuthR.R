#library calls
library("sleuth")
library("biomaRt")
library("dplyr")
#arguments
args = commandArgs(trailingOnly=TRUE)
base_dir <- args[1]
condition_df <- read.table(args[2] ,sep = "\n",col.names = "condition")
setwd(base_dir)
#get sample id and directories
sample_id <- dir(file.path(base_dir,"quant"))
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir,"quant", id))
s2c <- data.frame(path=kal_dirs,sample=sample_id,condition=condition_df,row.names = NULL,stringsAsFactors = FALSE)
#ensmeble mart
mart <- biomaRt::useMart(biomart = "ENSEMBL_MART_ENSEMBL",dataset = "hsapiens_gene_ensembl",host = 'ensembl.org')
t2g <- biomaRt::getBM( attributes = c("ensembl_transcript_id", "transcript_version", "ensembl_gene_id", "external_gene_name", "description","transcript_biotype"),mart = mart)
t2g <- dplyr::rename(t2g, target_id = ensembl_transcript_id,ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
#fit
so <- sleuth_prep(s2c, target_mapping = t2g, aggregation_column = 'ext_gene', gene_mode = TRUE, extra_bootstrap_summary = TRUE)
#matrix
matrix <- sleuth_to_matrix(so, "obs_norm", "scaled_reads_per_base")
write.table(matrix, 'count_matrix.txt', col.names = TRUE)


