
# Snakemake pipeline to run UMI-tools scRNA-Seq pipeline

This directory contains a snakemake pipeline for processing
single cell RNA-Seq data using UMI-Tools

See description of the pipeline:
https://github.com/CGATOxford/UMI-tools/blob/master/doc/Single_cell_tutorial.md


To run on new data edit `umitools_config.yaml` to specify the following important parameters:

1. `DATA`: This is the directory that the output results will be placed
   into. Also there should be a directory called `fastqs` in this
   directory that contains the raw fastq data. 
   
   i.e. if 
   ```
   DATA: `2018-02-08`
   ```
   
   Then fastq data should be in `2018-02-08/fastq`
2. `GENOME_FA`: Path to the genome fasta file

3. `STAR_IDX`: The name of the directory that contains the star index (or
   if there is no star index, where you would like the star index to be
   placed)

4. `TRANSCRIPTS`: This should point to the directory containing the
   transcript annotations in gtf format

5. `IDS`: Specify the samples that should be processed by the
   pipeline. The ID should be a string that includes the prefix prior to
   "_R[12]_001.fastq.gz". 

   i.e. 
   ```
   IDS:
     - sample_1_1_S1_L001 
     - sample_2_1_S1_L001
   ```
   
   The raw fastqs will be named 
   ```
   sample_1_1_S1_L001_R1_001.fastq.gz  
   sample_1_1_S1_L001_R2_001.fastq.gz  
   sample_2_1_S1_L001_R1_001.fastq.gz
   sample_2_1_S1_L001_R2_001.fastq.gz
   ```
    
6. `EXPECTED_CELL_COUNT`: The expected number of cells. This number will
   be used by the `umi-tools whitelist` command to estimate the number of
   cells in the experiment. 

7. `BARCODE_STRUCTURE`: Here provide arguments for specifying the barcode
   structure to `umi_tools extract` and `umi_tools whitelist`. You can provide
   additional arguments that will be passed to these commands.
   
   i.e.
   ```
   BARCODE_STRUCTURE: " --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN "
   ```

   or if working with inDrop barcodes:
   ```
   BARCODE_STRUCTURE:
     " --bc-pattern="(?P<cell_1>.{8,12})(?P<discard_1>GAGTGATTGCTTGTGACGCCTT)(?P<cell_2>.{8})(?P<umi_1>.{6})T{3}.* \"
     " --extract-method=regex " 

Lastly, the `run_umitools_pipeline.sh` script is a BSUB submission script that initiates the
snakemake executable.

