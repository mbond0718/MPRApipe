## Select positive and negative controls to include in barcode mapping: 
## Path to control fasta is included in bcmapping config.yaml 

options(stringsAsFactors = F)
library(data.table)

args <- commandArgs(trailingOnly = TRUE)
controlFile <- args[1]
outputFile <- args[2]

fasta = fread(controlFile, header=F)
fasta.df = data.frame(names=fasta[seq(1,nrow(fasta),2)], 
                      seq=fasta[seq(2,nrow(fasta),2)])
colnames(fasta.df) = c("names", "seq")

controls = fasta.df[grep("TACTGGCCATGATTTCTCC",fasta.df$seq), ]
controls$names = gsub(">","",controls$names)

write.table(controls, row.names=F, col.names=T, sep="\t", quote=F, file=outputFile)