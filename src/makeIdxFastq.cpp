#include <zlib.h>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>

extern "C" {
#include "kseq.h"
}

// takes a compressed fastq and return the index sequence as a separate
// fastq. The index is assumed to be 8bp long, and there will be dummy
// quality scores added for the index
// 
// http://attractivechaos.github.io/klib/#Kseq%3A%20stream%20buffer%20and%20FASTA%2FQ%20parser

// STEP 1: declare the type of file handler and the read() function
KSEQ_INIT(gzFile, gzread)

int main(int argc, char *argv[])
{
  gzFile fp;
  kseq_t *seq;

  if (argc == 1) {
    fprintf(stderr, "Usage: %s <in.fastq.gz> \n", argv[0]);
    return 1;
  }

  fp = gzopen(argv[1], "r"); // STEP 2: open the file handler
  seq = kseq_init(fp); // STEP 3: initialize seq

  std::string dummy_qual = std::string(8, 'G') ; // set dummy quality for output
  int l ;
  while ((l = kseq_read(seq)) >= 0) { // STEP 4: read sequence

    if (!seq->comment.l) {
      std::cerr << "index sequence not found " << std::endl;
      return -1;
    }

    std::string index_str = seq->comment.s ;
    std::string idx = index_str.substr(6,13); //extract out index seq

    std::cout << "@" << seq->name.s << " " << index_str  << std::endl
           << idx << std::endl
           << "+" << std::endl
           <<  dummy_qual<< std::endl ;
  }

  kseq_destroy(seq); // STEP 5: destroy seq
  gzclose(fp); // STEP 6: close the file handle

  return 0;
}

