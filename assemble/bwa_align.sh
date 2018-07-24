#!/bin/bash

genome=$2

fastq=`ls /atium/Data/10X/180411_redwood/fastq_path/SEGI21/*fastq*`
echo $fastq

if [ $1 == "index" ]; then
    bwa index $genome
fi

if [ $1 == "align" ]; then
    bwa mem -p -t 8 ${genome} ${fastq} > 180519_segi21_10xalign.pe.sam
fi

#bwa index ~/ruby/annadata/Calypte_anna.cds

#bwa mem ~/ruby/annadata/Calypte_anna.cds /atium/Data/NGS/Raw/170726_hbirdnextera/170726-hbirdliverrna502_S2_L001_R1_001.fastq /atium/Data/NGS/Raw/170726_hbirdnextera/170726-hbirdliverrna502_S2_L001_R2_001.fastq > canna_bwaaln.pe.sam
