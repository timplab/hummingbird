#!/bin/bash
#$ -S /bin/bash
#$ -pe mpi 14

##set ref,

export PATH=/shared/conda/bin:$PATH

workdir=/shared/data/

cd ${workdir}


i=$(expr $SGE_TASK_ID - 1)

echo $i

fqname1=r1split$(printf "%04d" ${i}).fq.gz
fqname2=r2split$(printf "%04d" ${i}).fq.gz


##Align reads (parallelize this, index job I suppose)
bowtie2 -p 14 -t \
	-x ${workdir}/${ref} \
	-1 ${workdir}/${fqname1} \
	-2 ${workdir}/${fqname2} \
    | samtools view -bS - | samtools sort - -o ${workdir}/${ref}.${i}.aln.bt2.bam

samtools index ${workdir}/${ref}.${i}.aln.bt2.bam




