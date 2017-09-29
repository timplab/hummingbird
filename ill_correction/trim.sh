#!/bin/bash
#$ -S /bin/bash
#$ -pe mpi 14

atropos -T 14 --aligner insert -a AGATCGGAAGAGC -A AGATCGGAAGAGC \
	-o /shared/data/trim1.fq.gz -p /shared/data/trim2.fq.gz \
	-pe1 /shared/data/test1.fq.gz -pe2 /shared/data/test2.fq.gz \
	-q 25 -i 10 -I 7
