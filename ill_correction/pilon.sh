#!/bin/bash
#$ -S /bin/bash
#$ -pe mpi 14

##set ref, round

workdir=/shared/data/

pilon --genome ${ref}.fa --frags ${ref}.aln.bt2.bam --changes --output ${round}.pilon





