#!/bin/bash
#$ -S /bin/bash
#$ -pe mpi 14

export PATH=/shared/conda/bin:$PATH

atropos -T 14 --aligner insert -a AGATCGGAAGAGC -A AGATCGGAAGAGC \
	-o /shared/data/trim1.fq.gz -p /shared/data/trim2.fq.gz \
	-pe1 /shared/data/read1.fq.gz -pe2 /shared/data/read2.fq.gz \
	-q 25 -i 10 -I 7
