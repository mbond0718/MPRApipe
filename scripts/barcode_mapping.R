##############################
### Barcode mapping ##########
##############################
options(stringsAsFactors = F)

args <- commandArgs(trailingOnly = TRUE)
controlFile <- args[1]
outputFile <- args[2]

bbmerge = "/proj/hyejunglab/program/bbmap/bbmerge.sh"
bcmappy = "python /proj/hyejunglab/program/barcode_mapping/barcode_mapping.py"
setup = "scripts/setup.sh"

libfile = args[1]
fastq1 = args[2]
fastq2 = args[3]
outputname = args[4]
outputtxt = args[5]
unmerge1 = args[6]
unmerge2 = args[7]
bcmapname = args[8]
bcstats = args[9]
varstats = args[10]
varpdf = args[11]

system(paste0(bbmerge, " in1=",fastq1, " in2=",fastq2, " out=", outputname, " outu1=", unmerge1, " outu2=", unmerge2))
system(paste0("sed -n '2~4p' ", outputname, " > ", outputtxt))
system(paste0(bcmappy, " ", outputtxt, " txt ",  libfile, " tab 150 25 start 20 ", bcmapname))
#system("mv barcode_statistics.txt bcMapOutput/")
#system("mv variant_statistics.txt bcMapOutput/")
system(paste0("mv barcode_statistics.txt ", bcstats))
system(paste0("mv variant_statistics.txt ", varstats))

## Digest the output
bcstat = read.table(bcstats, header=T)
varstat = read.table(varstats, header=T, sep="\t")

pdf(varpdf, height=5, width=10)
par(mfrow=c(1,2))
hist(bcstat$num_reads_most_common, xlim=c(0,100), xlab="# of reads per barcode", 
     main=paste0("barcode coverage\nmin=",min(bcstat$num_reads_most_common), "\nmax=",max(bcstat$num_reads_most_common),"\nmean=",mean(signif(bcstat$num_reads_most_common,2))))
hist(varstat$num_barcodes_unique, xlab="# of barcodes per variant", cex=0.5,
     main=paste0("min=",min(varstat$num_barcodes_unique), "\nmax=",max(varstat$num_barcodes_unique),"\nmean=",mean(signif(varstat$num_barcodes_unique,2)),"\nmedian=",median(signif(varstat$num_barcodes_unique,2))))
dev.off()