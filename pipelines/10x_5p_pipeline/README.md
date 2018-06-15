
# Example BSUB scripts for running 10x genomics 5' gene expression or Ig/TCR reconstruction

See the [10x website](https://support.10xgenomics.com/single-cell-vdj/software/vdj-and-gene-expression/latest/overview) for documentation on running cellranger for VDJ assembly.

The 10x 5' gene-expression data is processed using cellranger count in an identical fashion to the 3' gene-expression data. Included here is an exampled BSUB script `run_5pcount_local.sh` to run on two samples. Alternatively the `10x_3p_pipeline` can be run. 

The 10x Ig/TCR data is not currently in a snakemake pipeline. cellranger has an additional command called `vdj` that will perform VDJ assembly. Included here is an exampled BSUB script `run_vdj_local.sh` to run assembly on either TCR or Ig enriched samples. `vdj` will automatically determine whether the data is TCR or Ig enrichment. 


The bsub scripts assumes that you have the fastqs from 5' gene expression (Exp) or Ig/TCR (B/Tcell) named as follows:

For example raw data see here on tesla:
`/vol3/home/riemondy/Projects/10x_data/tcr/raw_data/2018-05-18_jurkat_raji`

```bash
Bcell_S1_L001_R1_001.fastq.gz      
Bcell_S1_L001_R2_001.fastq.gz     
Tcell_S1_L001_R1_001.fastq.gz
Tcell_S1_L001_R2_001.fastq.gz
JurkatExp_S1_L001_R1_001.fastq.gz  
JurkatExp_S1_L001_R2_001.fastq.gz  
RajiExp_S1_L001_R1_001.fastq.gz
RajiExp_S1_L001_R2_001.fastq.gz
```
