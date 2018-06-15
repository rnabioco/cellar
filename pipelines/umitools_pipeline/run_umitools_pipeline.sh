#!/usr/bin/env bash
#BSUB -J scRNA 
#BSUB -o logs/scrna_%J.out
#BSUB -e logs/scrna_%J.err
#BSUB -R "select[mem>4] rusage[mem=4] " 

set -o nounset -o pipefail -o errexit -x

args=' -q normal -o {log}.out -e {log}.err -J {params.job_name} -R " {params.memory} span[hosts=1] " -n {threads} '

#### load necessary programs ####

# If programs are not all in the path then modify code to load
# the necessary programs

# load modules
. /usr/share/Modules/init/bash
module load modules modules-init modules-python
module load fastqc
module load samtools
module load star 

# featureCounts >= 1.6.0
# umi_tools >= 0.5.1

snakemake --drmaa "$args" \
  --snakefile umitools.snake \
  --jobs 12 \
  --resources max_cpus=36 \
  --latency-wait 50 \
  --rerun-incomplete  \
  --configfile umitools_config.yaml 
