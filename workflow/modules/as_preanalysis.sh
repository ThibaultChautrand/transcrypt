#!/bin/bash

module load tools
module load perl
module load ncbi-blast/2.13.0+ 
module load barrnap/0.7 
module load signalp/6.0g
module load hmmer/3.3.2
module load prodigal/2.6.3
module load aragorn/1.2.36
module load tbl2asn/20200706
module load infernal/1.1.4
module load rnammer/1.2 
module load jdk/20 java/1.8.0 jre/1.8.0
module load minced/0.4.2 
module load prokka/1.14.5

cd /home/projects/dtu_00009/people/thihcha/transcrypt/data/
prokka --force --centre X --compliant --outdir PROKKA --prefix DIET1 Metagenomes_concatenated.fasta