#BSUB -n 1
#BSUB -J 10xcount_Jordan
#BSUB -o count_jordan_out.txt
#BSUB -e count_jordan_err.txt

####
# Run cellranger pipeline on single cell data
# cellranger directory added to .bashrc 
####

hg19_transcriptome="$HOME/Projects/shared_dbases/cell_ranger/refdata-cellranger-GRCh38-1.2.0/"
fqdir="$HOME/Projects/10x_scRNA/data/fastqs/"

cellranger count \
    --id=Brett_1 \
    --fastqs=$fqdir \
    --sample=Brett_1 \
    --lanes=1,2,3,4 \
    --indices=SI-GA-G3 \
    --jobmode=lsf \
    --maxjobs=24 \
    --transcriptome=$hg19_transcriptome

cellranger count \
    --id=Brett_2 \
    --fastqs=$fqdir \
    --sample=Brett_2 \
    --lanes=1,2,3,4 \
    --indices=SI-GA-F3 \
    --jobmode=lsf \
    --maxjobs=24 \
    --transcriptome=$hg19_transcriptome

cellranger count \
    --id=Brett_3 \
    --fastqs=$fqdir \
    --sample=Brett_3 \
    --lanes=1,2,3,4 \
    --indices=SI-GA-E3 \
    --jobmode=lsf \
    --maxjobs=24 \
    --transcriptome=$hg19_transcriptome

cellranger aggr \
  --id=Brett_123 \
  --csv=jordan_libraries.csv \
  --normalize=mapped \
  --jobmode=lsf \
  --maxjobs=24 
