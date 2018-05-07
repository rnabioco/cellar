#!/usr/bin/env bash
#BSUB -J 10xscRNA 
#BSUB -o logs/10x_%J.out
#BSUB -e logs/10x_%J.err
#BSUB -R "select[mem>4] rusage[mem=4] " 
#BSUB -q normal
#BSUB -m "compute16"

set -o nounset -o pipefail -o errexit -x

args=' -q rna -o {log}.out -e {log}.err -J {params.job_name} -R "
{params.memory} span[hosts=1] " -n {threads} -m "compute03 compute07
    compute16 " '

snakemake --drmaa "$args" --snakefile Snakefile --jobs 3 \
  --latency-wait 50 --rerun-incomplete  --configfile config_jordan.yaml 
