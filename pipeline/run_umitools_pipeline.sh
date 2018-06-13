#!/usr/bin/env bash
#BSUB -J 10xscRNA 
#BSUB -o logs/10x_%J.out
#BSUB -e logs/10x_%J.err
#BSUB -R "select[mem>4] rusage[mem=4] " 

set -o nounset -o pipefail -o errexit -x

args=' -q rna -o {log}.out -e {log}.err -J {params.job_name} -R " {params.memory} span[hosts=1] " -n {threads} '

#### load necessary programs ####

# If programs are not all in the path then modify code to load
# the necessary programs

# load modules
. /usr/share/Modules/init/bash
module load modules modules-init modules-python
module load fastqc/0.10.1
module load samtools
module load python3/3.6.5

# featureCounts >= 1.6.0
# umi_tools >= 0.5.3

snakemake --drmaa "$args" \
  --snakefile umitools.snake \
  --jobs 12 \
  --resources max_cpus=36 \
  --latency-wait 50 \
  --rerun-incomplete  \
  --configfile umitools_config.yaml 
