## Load libraries
library(data.table)
#install.packages("rlist")
#library(rlist)
library(dplyr)

# Loading and preparing count tables --------------------------------------
countMatrix <- fread("mpraOutput/countMatrix.txt", skip = 1)
countMatrix[,c("Chr","Start","End","Strand","Length"):=NULL]
numsamples <- round((length(colnames(countMatrix))-1)/2) #this will depend on the number of dna samples
countMatrix <- countMatrix %>% select(order(colnames(countMatrix)))
colnames(countMatrix) <- c("Geneid", "DNA", rep(paste0("RNA_Control", seq(1:numsamples/2))), rep(paste0("RNA_Treated", seq(1:numsamples/2))))

# Filtering to remove bcs with 0 measures and format variant table------------------------------

##Obtaining barcode names
nms <- countMatrix[,1,drop=TRUE][[1]]

##Obtaining row indices which have a value of greater than 0 across samples
idx <- rowSums(countMatrix[,2:(2*numsamples+1)]) > 0

##Filter dataframe by above indices to remove bcs with only 0s
variantTable <- countMatrix[idx,]

##Get sequences matching with the filtered indices
nmsplit = strsplit(nms[idx], split="[|]")
seq = sapply(nmsplit, function(x) { y <- x[-length(x)]; paste(y, collapse=".") })
bcs <- sub(".*\\|","",nms[idx])      

##Examing which seqs are mapped to multiple bcs
table(table(seq))
tab <- table(seq)
plot(density(tab))

##Summing RNA and DNA
rna <- rowSums(variantTable[,3:(numsamples*2)])
dna <- rowSums(variantTable[,2])

# Identifying outlier bcs -------------------------------------------------

##Restricting to bcs with dna>=100 #changing to 1 for now: 
logratio <- ifelse(rna >= 0 & dna >= 1, log2(rna) - log2(dna), NA)
logratio <- split(logratio, factor(seq))

##Making sure seqs have at least 2 bcs which are not NA: 
logratio <- logratio[ sapply(logratio, function(x) sum(!is.na(x)) > 1) ]

seqs_with_outlier <- sapply(logratio, function(x) { y <- x[!is.na(x)]; any(y > median(y) + 2) })
table(seqs_with_outlier)

lr_seqs_with_outlier <- logratio[ seqs_with_outlier ]
which_outlier <- sapply(lr_seqs_with_outlier, function(x) which(x > median(x, na.rm=TRUE) + 2))

outliers <- data.frame(seq=rep(names(which_outlier), lengths(which_outlier)), number=unlist(which_outlier))

##Removing seqs which had more than 1 outlier bc - didn't seem like an outlier upon inspection
questionable <- outliers$seq[duplicated(outliers$seq)]
outliers <- outliers[ !outliers$seq %in% questionable, ]

##Outliers contains the bc indices we want removed
head(outliers)

##Filtering out outlier barcodes
variantTable <- cbind(variantTable, seq)

outlier_indices <- match(outliers$seq, variantTable$seq) + outliers$number - 1

variantTable <- variantTable[-outlier_indices,]
variantTable$seq <- NULL

mergedCounts_noOutliers <- variantTable

save(mergedCounts_noOutliers, file="mpraOutput/mergedCounts_noOutliers.rda")
