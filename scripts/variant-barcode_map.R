options(stringsAsFactors = F)
library(reshape2) 
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
varstat <- args[1]
bctxt <- args[2]
uniqbc <- args[3]
uniqbcN <- args[4]
rda <- args[5]

variant = read.table(varstat, header=T, sep="\t")

bclist = strsplit(variant$barcodes, split=",")
names(bclist) = variant$name
bcdat = melt(bclist)
colnames(bcdat) = c("barcode", "variant")

write.table(bcdat[,1], file=bctxt, row.names=F, col.names=F, quote=F)

system(paste0("sort ", bctxt, " | uniq -u > ", uniqbc)) # remove barcodes that are duplicated
system(paste0("grep -v N ", uniqbc, " > ", uniqbcN)) # remove barcodes with Ns

#########################
# Getting unique barcodes - never do this again, these unique bcs will work for all batches
#########################

bcdat_unique <- read.table(uniqbcN)
bcdat_unique <- unlist(bcdat_unique)

bcdat <- bcdat[bcdat$barcode %in% bcdat_unique,]

save(bcdat, file=rda)
