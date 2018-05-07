#!/usr/bin/env python3
import argparse
import os, sys
import gzip
import re
import glob
import subprocess

def concatenate_fq(outfq, lst_of_fq, outdirectory):
    
    output = os.path.join(outdirectory, outfq)
    
    outfile = open(output, "w")

    cmd = ["cat"] + lst_of_fq 
    
    subprocess.run(cmd, stdout=outfile)
    
    outfile.close()
    
    for fq in lst_of_fq:
        print("{} {}".format(fq, output), file=sys.stderr)

def combine_fastqs(ids, in_directory, out_directory):

    fqs = glob.glob(in_directory + "/*.fastq.gz")
    
    if len(fqs) == 0:
        sys.exit("Error: no fastqs found at {}".format(in_directory))
    
    sample_names = [x.strip() for x in ids]
    
    # initalize logging
    print("input_fastq output_fastq", file=sys.stderr)

    for sample in sample_names:
        fqs_with_name = [x for x in fqs if sample in x]
        
        # determine the set of lanes, and pick a sample id (take first)

        fqregex = re.compile(".*_(S[0-9]+)_(L00[1-8])_[IR][12]_001[.]fastq[.]gz")
        
        fqregex_novaseq = re.compile(".*_(S[0-9]+)_[IR][12]_001[.]fastq[.]gz")

        lanes = set()
        sample_id = ""
        novaseq = False

        for fq in fqs_with_name:
            try:
                sid, lane = fqregex.match(fq).groups()
            except AttributeError:
                try:
                    sid = fqregex_novaseq.match(fq).groups()[0]
                    novaseq = True
                except:
                    sys.exit("Unable to extract sample, lane from fastq name")
            
            if sample_id == "":
                sample_id = sid
            
            if not novaseq:
                lanes.add(lane)
        
        R1_fqs = []
        R2_fqs = []
        
        if novaseq:
            
            R1_fqs = [x for x in fqs_with_name if "_R1_" in x]
            R2_fqs = [x for x in fqs_with_name if "_R2_" in x]
            
            # make output directory
            if not os.path.exists(out_directory):
                os.makedirs(out_directory)
            
            # add dummmy lane info for 10x cell ranger
            # i.e. [Sample Name]_S1_L00[Lane Number]_[ReadType]_001.fastq.gz
            lane = "L001"
            
            if R1_fqs and R2_fqs:
                outname_r1 = sample + "_" + sample_id + "_" + lane + "_R1_001.fastq.gz"
                concatenate_fq(outname_r1, R1_fqs, out_directory)
                
                outname_r2 = sample + "_" + sample_id + "_" + lane + "_R2_001.fastq.gz"
                r2_fqs = [x.replace("_R1_001.fastq.gz", "_R2_001.fastq.gz") for x in R1_fqs]
                concatenate_fq(outname_r2, r2_fqs, out_directory)
            
            continue
        
        for lane_id in lanes:
            
            per_lane_fqs = [x for x in fqs_with_name if lane_id in x]
            
            R1s = [x for x in per_lane_fqs if "_R1_" in x]
            R2s = [x for x in per_lane_fqs if "_R2_" in x]
            R1_fqs += R1s          
            R2_fqs += R2s          
            
        # make output directory
        if not os.path.exists(out_directory):
            os.makedirs(out_directory)
        
        if R1_fqs and R2_fqs:
            ## keep same order for R1 and R2 
            outname_r1 = sample + "_" + sample_id + "_" + lane + "_R1_001.fastq.gz"
            concatenate_fq(outname_r1, R1_fqs, out_directory)
       
            outname_r2 = sample + "_" + sample_id + "_" + lane + "_R2_001.fastq.gz"
            r2_fqs = [x.replace("_R1_001.fastq.gz", "_R2_001.fastq.gz") for x in R1_fqs]
            concatenate_fq(outname_r2, r2_fqs, out_directory)
        
def main():

    parser = argparse.ArgumentParser(description="""
    Combine fastqs based on a common sample id. Useful for combining fastqs 
    from the 4 indices per sample for 10x genomics output. R1 and R2 fastqs will
    be combined seperately. """)

    parser.add_argument('-s',
                          '--samples',
                          help ='Text file with sample names to combine. 1 per line',
                       required = True),
    parser.add_argument('-f',
                          '--fastq_directory',
                          help ='directory containing fastqs to combine',
                       required = True)
    parser.add_argument('-o',
                          '--output_fastq_directory',
                          help ='directory containing fastqs to combine',
                       required = True)

    args=parser.parse_args()
    
    sample_ids = open(args.samples, 'r')
    in_directory = args.fastq_directory
    out_directory = args.output_fastq_directory

    combine_fastqs(sample_ids, in_directory, out_directory)
    
    sample_ids.close()

if __name__ == '__main__': main()

