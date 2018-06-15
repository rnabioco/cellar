#! /usr/bin/env bash
#BSUB -n 16
#BSUB -J 10x[1-2]%2 
#BSUB -e err_%J.out
#BSUB -o out_%J.out
#BSUB -R "select[mem>35] rusage[mem=35] span[hosts=1]" 
#BSUB -q normal

transcriptome="/vol3/home/riemondy/Projects/shared_dbases/cell_ranger/refdata-cellranger-GRCh38-1.2.0/"

fastqs="~/Projects/10x_data/tcr/raw_data/2018-05-18_jurkat_raji"

SAMPLES=(
RajiExp
JurkatExp
)

sample=${SAMPLES[$(($LSB_JOBINDEX - 1))]}

set -x
cellranger count \
    --id="geneexp_"$sample \
    --fastqs=$fastqs \
    --sample=$sample \
    --localcores=16 \
    --localmem=30 \
    --transcriptome=$transcriptome
