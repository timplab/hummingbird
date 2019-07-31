#!/bin/bash 
#indir=
outdir=/kyber/Data/temp/gmoney/hummingbird/gm1278_teloprime/alignment/190507-gm12878-telo
ref=/home/gmoney/c9orf72/ref/GRCh38.primary_assembly.genome.fa
indir=/kyber/Data/Nanopore/projects/gm12878_teloprime

minimap2 -ax splice $ref ${indir}/190507_telo_gm12878.fastq > ${outdir}/gm128_transcript.sam
samtools view -S -b ${outdir}/gm128_transcript.sam | samtools sort -o ${outdir}/gm128_transcript.bam
samtools index ${outdir}/gm128_transcript.bam
rm ${outdir}/gm128_transcript.sam
