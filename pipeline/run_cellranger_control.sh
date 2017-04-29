#BSUB -n 1
#BSUB -J 10xcount
#BSUB -o count_out.txt
#BSUB -e count_err.txt

####
# Run cellranger pipeline on single cell data
# cellranger directory added to .bashrc 
####

hg19_transcriptome="$HOME/Projects/shared_dbases/cell_ranger/refdata-cellranger-GRCh38-1.2.0/"
mixed_transcriptome="$HOME/Projects/shared_dbases/cell_ranger/refdata-cellranger-hg19_and_mm10-1.2.0/"
illumina_run="$HOME/Projects/10x_scRNA/data/raw_data/"
fqdir="$HOME/Projects/10x_scRNA/data/fastqs/"

cellranger count \
    --id=control \
    --fastqs=$fqdir \
    --sample=Control \
    --lanes=1,2,3,4 \
    --indices=SI-GA-H3 \
    --jobmode=lsf \
    --maxjobs=24 \
    --transcriptome=$mixed_transcriptome

