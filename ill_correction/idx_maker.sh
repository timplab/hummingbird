#!/bin/bash
#$ -S /bin/bash
#$ -pe mpi 14

##ref is set name - .fa

export PATH=/shared/conda/bin:$PATH

##Build bowtie2 library
bowtie2-build --threads 14 $ref.fasta $ref



