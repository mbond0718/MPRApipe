## Load libraries
library(data.table)

load("mpraOutput/mergedCounts_noOutliers.rda")

##Obtaining barcode names
nms <- mergedCounts_noOutliers[,1,drop=TRUE][[1]]

##Get sequences matching with the filtered indices
nmsplit = strsplit(nms, split="[|]")
seq = sapply(nmsplit, function(x) { y <- x[-length(x)]; paste(y, collapse=".") })

#Examing which seqs are mapped to multiple bcs
t <- table(table(seq))
tab <- table(seq)
#plot(density(tab))

##Culling variants which match with fewer than 5 bcs
mergedCounts_noOutliers <- cbind(mergedCounts_noOutliers, seq)
mergedCounts_noOutliers <- mergedCounts_noOutliers[mergedCounts_noOutliers$seq %in% names(which(table(mergedCounts_noOutliers$seq) >=5 )), ]

##Testing to see if worked
nms <- mergedCounts_noOutliers[,1,drop=TRUE][[1]]

##Get sequences matching with the filtered indices 
nmsplit = strsplit(nms, split="[|]")
seq = sapply(nmsplit, function(x) { y <- x[-length(x)]; paste(y, collapse=".") })
t <- table(table(seq))
t

##Formatting
barcode = sapply(nmsplit, function(x) { y <- x[length(x)] }) # barcode <- sub(".*\\|","",nms) 
batch <- cbind(barcode, mergedCounts_noOutliers)
batch <- batch[,-2]
setnames(batch, "seq", "variant")

save(batch, file="mpraOutput/mergedCounts_noOutliers_atLeastFiveBCs.rda")

## Plot the # of barcodes per variants
batch_ad = batch[grep("ad",batch$variant),]
bcrep = table(batch_ad$variant)
median(bcrep) # 11
mean(bcrep) # 12.08946

pdf(("mpraOutput/barcode_representation.pdf"), height=5, width=5)
hist(bcrep, xlab="# of barcodes per variant", cex=0.5,
     main=paste0("median=",median(signif(bcrep,2))))
abline(v=median(bcrep), col="blue")
dev.off()