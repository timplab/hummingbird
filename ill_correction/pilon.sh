#!/bin/bash
#$ -S /bin/bash
#$ -pe mpi 14

##set ref, round

export PATH=/shared/conda/bin:$PATH

workdir=/shared/data/

cd ${workdir}

samtools merge ${round}.aln.merge.bam ${ref}.*.aln.bt2.bam
rm *aln.bt2.bam

samtools view -b -f2 ${round}.aln.merge.bam | samtools sort - -o ${round}.filt.bam
samtools index ${round}.filt.bam
rm ${round}.aln.merge.bam

pilon --threads 14 -Xmx20G  --genome ${ref}.fa --frags ${round}.filt.bam --changes --output ${round}.pilon





