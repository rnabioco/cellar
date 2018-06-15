#! /usr/bin/env bash
#BSUB -n 16
#BSUB -J 10x[1-2]%2 
#BSUB -e err_%J.out
#BSUB -o out_%J.out
#BSUB -R "select[mem>35] rusage[mem=35] span[hosts=1]" 
#BSUB -q normal

transcriptome="/vol3/home/riemondy/Projects/shared_dbases/cell_ranger/refdata-cellranger-vdj-GRCh38-alts-ensembl-2.0.0/"

fastq_path="/vol3/home/riemondy/Projects/10x_data/tcr/raw_data/2018-05-18_jurkat_raji"

SAMPLES=(
Tcell
Bcell
)

sample=${SAMPLES[$(($LSB_JOBINDEX - 1))]}

set -x
cellranger vdj \
    --id="VDJ_"$sample \
    --fastqs=$fastq_path \
    --sample=$sample \
    --localcores=16 \
    --localmem=30 \
    --reference=$transcriptome
