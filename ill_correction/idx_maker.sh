#!/bin/bash
#$ -S /bin/bash
#$ -pe mpi 14

##ref is set name - .fa

##Build bowtie2 library
bowtie2-build --threads 14 $ref.fa $ref



##Align reads (parallelize this, index job I suppose)



##pilon it


