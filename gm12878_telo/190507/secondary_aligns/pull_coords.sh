#!/bin/bash
dir=/kyber/Data/Nanopore/Analysis/gmoney/gm12878_teloprime/190507_telo_gm12878

samtools view -f 0x100 -h ${dir}/gm128_trimmed_transcript.bam | cut -f1 | sort | uniq > ${dir}/ID.tmp
samtools view -h ${dir}/gm128_trimmed_transcript.bam | grep -f ${dir}/ID.tmp | awk 'BEGIN{OFS="\t"} {print $1,$2, $3, $4, $5}' > ${dir}/alignments.tsv
