#!/bin/bash
#$ -S /bin/bash
#$ -pe mpi 14

##set ref, round

export PATH=/shared/conda/bin:$PATH

workdir=/shared/data/

cd ${workdir}

samtools merge ${round}.aln.merge.bam ${ref}.*.aln.bt2.bam
samtools index ${round}.aln.merge.bam

pilon --threads 14 -Xmx20G  --genome ${ref}.fa --frags ${round}.aln.merge.bam --changes --output ${round}.pilon





