#BSUB -n 1
#BSUB -J 10xcount
#BSUB -o out.txt
#BSUB -e err.txt

####
# Run cellranger pipeline on single cell data
# cellranger directory added to .bashrc 
# execute module load bcl2fastq prior to submission 
####

transcriptome="$HOME/Projects/shared_dbases/cell_ranger/refdata-cellranger-GRCh38-1.2.0/"
illumina_run="$HOME/Projects/10x_scRNA/data/raw_data/"
outdir="$HOME/Projects/10x_scRNA/data/fastqs/"

cellranger mkfastq \
    --run=$illumina_run \
    --samplesheet=10x_samplesheet_illuminastyle.csv \
    --project=10x_demo_analysis \
    --jobmode=lsf \
    --maxjobs=24 \
    --output-dir $outdir

