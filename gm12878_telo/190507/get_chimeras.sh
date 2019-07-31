#!/bin/bash 
indir=/kyber/Data/Nanopore/Analysis/gmoney/gm12878_teloprime/190507_telo_gm12878
# first get read IDs of all the reads porechop included 

#awk 'NR %4==1' ${indir}/190507_gm128_telo_trimmed.fastq | cut -d " " -f1 > ID_trim.tmp
#awk 'NR %4==1' /kyber/Data/Nanopore/projects/gm12878_teloprime/190507_telo_gm12878.fastq | cut -d " " -f1 > ID_all.tmp
#cat ID_all.tmp ID_trim.tmp | sort | uniq -u > uniq_IDs
grep -f uniq_IDs -A 3 -v /kyber/Data/Nanopore/projects/gm12878_teloprime/190507_telo_gm12878.fastq > ${indir}/chimeras.fastq

#cat ${indir}/190507_gm128_telo_trimmed.fastq /kyber/Data/Nanopore/projects/gm12878_teloprime/190507_telo_gm12878.fastq | paste -d"\t" - - - - | sort | uniq -u | tr "\t" "\n" > ${indir}/chimeric.fastq
# tr "\t" "\n"
