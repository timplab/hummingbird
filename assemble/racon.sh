#!/bin/bash

#install
if [ "$1" == "install" ]; then
	git clone --recursive https://github.com/isovic/racon.git racon
        cd racon
        mkdir build
        cd build
        cmake -DCMAKE_BUILD_TYPE=Release ..
        make
	git clone https://github.com/lh3/minimap2
        cd minimap2 && make
fi

# need to cat fastqs first

if [ "$1" == "minimap" ]; then
#	cat /home/ubuntu/illumina/*.fastq.gz > ruby_illumina_seq.fastq.gz 
       /home/ubuntu/minimap2/minimap2 -t 72 -a ruby_polished_genome.fa ruby_illumina_seq.fastq.gz > illumina_reads.sam  
fi

if [ "$1" == "racon" ]; then
	# target sequences  = the assembly thats going to be corrected (fasta) -- the polished nanopore consensus 
	# sequences = the illumina reads 
	# overlaps = sam from minimap of illumina fastq to assembly fasta
	racon -t 72 ruby_illumina_seq.fastq.gz illumina_reads.sam  ruby_polished_genome.fa
fi
