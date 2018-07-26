
# Snakemake pipeline to run 10x genomics cellranger

This directory contains a snakemake pipeine to execute the 10x genomics
cellranger count and aggregate pipelines on multiple samples. 

The cellranger software is available on tesla/bodhi as a module, but we don't recommend using 
the module as it won't take advantage of the pipelining functionality built into cellranger. Instead 
add the cellranger executable in the following directory to your PATH in your `.bashrc`.

i.e.
```bash
#if on tesla add:
PATH=${PATH}:"/vol3/home/riemondy/src/cellranger-2.1.1"

#if on bodhi
PATH=${PATH}:"/beevol/home/riemondy/src/cellranger-2.1.1"
```

To run this pipeline on new data edit `10x_3p_config.yaml` to specify the following important parameters:

1. `DATA`: This is the directory that the output results will be placed
   into. Also there should be a directory called `raw_data` in this
   directory that contains the raw fastq data. 
   
   i.e. if 
   ```
   DATA: `2018-02-08`
   ```
   
   Then fastq data should be in `2018-02-08/raw_data`
   (/beevol/home/riemondy/tmp/example_10x_fastqs)

   The `count` and `aggr` 10x executables will generate output in
   a `results` directory located in DATA.

2. `PROJECT`: String that describes the project. This metadata will be
   incorporated into the 10x output

3. `TRANSCRIPTOME`: This should point to the directory containing the 10x
   genomics formatted references. 

4. `SAMPLES`: Specify the samples that should be processed by the
   pipeline as a list. The genomics core often outputs 4 fastqs for each sample.
   This snakemake pipeline will match the common prefix from the
   samplename and pass all of the fastqs to cellranger count. Check the
   log (stderr) from the cellranger count commands to make sure that the
   right fastqs are passed to cellranger.  

   i.e. 
   ```
   SAMPLES:
     - sample_1 
     - sample_2
   ```
   
   The raw fastqs will likely be named:
   ```
   sample_1_1_S1_L001_R1_001.fastq.gz  
   sample_1_2_S2_L001_R1_001.fastq.gz  
   sample_1_3_S3_L001_R1_001.fastq.gz
   sample_1_4_S4_L001_R1_001.fastq.gz
   sample_2_1_S1_L001_R1_001.fastq.gz
   sample_2_2_S2_L001_R1_001.fastq.gz
   sample_2_3_S3_L001_R1_001.fastq.gz
   sample_2_4_S4_L001_R1_001.fastq.gz
   ```
    
   The cellranger count log that contains the list of fastqs is here:
   `DATA/sample_1/SC_RNA_COUNTER_CS/SC_RNA_COUNTER/SETUP_CHUNKS/fork0/_outs`

5. `EXPT_GROUPS`: Specify which samples to group together for aggregation
   as a csv separated string.The sample names should match those provided in the SAMPLES list. If
   you have multiple aggregations, then supply them as additional list
   entries. 

   i.e. to aggregate `sample_1` and `sample_2`:
   ```
   EXPT_GROUPS:
     - sample_1,sample_2
   ```

6. `MAX_10X_JOBS`: This argument is passed to ` --maxjobs` argument for
   `count` and `aggr`. Note that this is the maximum number of jobs
   submitted not maximum number of cores used. 

Lastly, the `run_10x_3p_pipeline.sh` script is a BSUB submission script that initiates the
snakemake executable.

