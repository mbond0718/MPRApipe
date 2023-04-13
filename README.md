  <h3 align="center">MPRApipe</h3>

  <p align="center">
    A snakemake pipeline to process MPRA data and perform barcode mapping
    <br />
    <br />
  </p>
</div>


<!-- ABOUT THE Pipeline -->
## About The Pipeline

This is a pipeline that performs all processing necessary to analyze MPRA data. There are two workflows

* barcode mapping: performs variant-barcode mapping and generates reference file
* processMPRA: processes MPRA data from fastqs 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

This pipeline was built with snakemake.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Quickstart: processMPRA

The `procMPRA` workflow is designed to take raw MPRA fastqs and generate a count matrix where all of the barcodes are aligned to a barcode reference genome. To begin, take the following steps: 

1. Clone workflow into working directory:
   ```sh
   git clone https://github.com/mbond0718/MPRApipe.git
   ```

2. Edit the tab separated `MPRAsamplesheet.txt` with project information, cell type, whether the sample is RNA or DNA, replicate information, the R1 fastq and the sequencing directory path. 

3. Edit the `config/configMPRA.yaml` file for your particular analysis. Important aspects to change include
* `mergeBy` parameters if there are sequencing replicates
* paths to reference `.fasta` and `.saf` files (see `bcMap` workflow below)
* adapter 1 and 2 sequences to trim

4. Submit to SLURM: 
   ```sh
   sbatch processMPRA.sh
   ```

After running the following steps, `processMRPA.sh` will launch a job for each of the samples being processed, while maintaining one continuously running job that runs while the other rules are running. 

The following output files will be generated: 
```
* MPRAoutput/{group}/{group}_aligned.sai
* MPRAoutput/{group}/{group}_aligned.sam
* MPRAoutput/countMatrix.txt
* MPRAoutput/countMatrix.txt.summary
* MPRAoutput/mergedCounts_noOutliers.rda
* MPRAoutput/mergedCounts_noOutliers_atLeastFiveBCs.rda
* MPRAoutput/barcode_representation.pdf
```

Output directory structure: 

[TO BE ADDED LATER]

## Mapping barcodes to variants with bcMap

The `bcMap` workflow is designed to map barcodes to variants from raw fastq files. This should be run once per experiment and will generate the `fasta` and `saf` files used in the `procMPRA` workflow. To run, do as follows: 

1. Clone workflow into working directory:
   ```sh
   git clone https://github.com/mbond0718/MPRApipe.git
   ```

2. Edit the tab separated `BCsamplesheet.txt` with project information, which MPRA library is being mapped, and sequencing replicates, taking care to address sequencing replicates.  

3. Edit the `config/configBCmap.yaml` file for your particular analysis. Important aspects to change include
* `mergeBy` parameters if there are sequencing replicates
* paths reference MPRA `fasta` to include as positive and negative controls 

4. Submit to SLURM: 
   ```sh
   sbatch barcodeMapping.sh
   ```

After running the following steps, `barcodeMapping.sh` will launch a job for each of the samples being processed, while maintaining one continuously running job that runs while the other rules are running. 

The following output files will be generated: 
```
* bcMapOutput/fastq/AD_BCMAP_merged_R1.fastq.gz
* bcMapOutput/fastq/AD_BCMAP_merged_R1.fastq.gz
* bcMapOutput/fastq/AD_BCMAP_unmerged1.fastq
* bcMapOutput/fastq/AD_BCMAP_unmerged2.fastq
* bcMapOutput/fastq/AD_BCMAP_merged.fastq
* bcMapOutput/fastq/AD_BCMAP_merged.txt
* bcMapOutput/fastq/AD_BCMAP_bcMap.txt
* bcMapOutput/AD_BCMAP_mpra_ad_posneg.txt
* bcMapOutput/AD_BCMAP_barcode_statistics.txt
* bcMapOutput/AD_BCMAP_variant_statistics.txt
* bcMapOutput/AD_BCMAP_variant_statistics.pdf
* bcMapOutput/AD_BCMAP_barcode.txt
* bcMapOutput/AD_BCMAP_bcdatBarcodesUniq.txt
* bcMapOutput/AD_BCMAP_bcdatBarcodesUniq_woN.txt 
* bcMapOutput/AD_BCMAP_unique_bcdat.rda
* bcMapOutput/ref/AD_BCMAP.fasta
* bcMapOutput/ref/AD_BCMAP.fasta.amb
* bcMapOutput/ref/AD_BCMAP.fasta.ann
* bcMapOutput/ref/AD_BCMAP.fasta.bwt
* bcMapOutput/ref/AD_BCMAP.fasta.pac
* bcMapOutput/ref/AD_BCMAP.fasta.sa
* bcMapOutput/ref/AD_BCMAP.fasta.saf
```

Output directory structure: 

[TO BE ADDED LATER]


### Workflow

[DESCRIBE THE WORKFLOW HERE]

[ADD DAG SCHEMATICS]

### Setup & Dependencies

MPRApipe uses snakemake version 5.10.0. See `requirements.txt` file for a list of python dependencies. Using the shell scripts to launch MPRApipe workflows in a cluster setting will automatically run the pipeline in a python virtual environment with the required dependencies.

### Unlocking

For a failed MPRApipe workflow use the unlock script with either "procMPRA", "bcMap" as the first argument:
   ```sh
   ./unlock.sh procMPRA
   ```

<!-- ROADMAP -->
## Roadmap

- [ ] Add DAG workflows
- [ ] Add output file structures
- [ ] Add `unlock.sh` script
- [ ] Come up with a better name and a logo
- [ ] Add previews of samplesheets to `README.md`
- [ ] Add MPRA to names of samples, somewhere in the samplesheet (i.e. data column in sample sheet) 
- [ ] Test on larger dataset 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Marielle Bond - [@marielle_bond](https://twitter.com/marielle_bond) - marielle_bond@med.unc.edu

Project Link: [https://github.com/mbond0718/MPRApipe](https://github.com/mbond0718/MPRApipe)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
