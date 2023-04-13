### Generation of the fasta file
library(Biostrings)
library(data.table)
options(stringsAsFactors = F)

args <- commandArgs(trailingOnly = TRUE)
rda <- args[[1]]
fasta <- args[[2]]
saf <- args[[3]]

load(rda)
bcdat$variant = gsub(" ", "_", bcdat$variant)

seqstr = DNAStringSet(bcdat$barcode) 
names(seqstr) = paste(bcdat$variant, bcdat$barcode, sep="|")

writeXStringSet(seqstr, file=fasta)
#system("mv barcode.fasta ./batch2/output")

system("module load bwa")
system(paste0("bwa index ", fasta, " mpra")) #not working? 

### Generation of the saf file

geneID = paste(bcdat$variant, bcdat$barcode, sep="|")
chr = paste(bcdat$variant, bcdat$barcode, sep="|")

safFile = data.frame(GeneID=geneID, Chr=chr, Start=1, End=20, Strand="*")

fwrite(safFile, file=saf, sep="\t")