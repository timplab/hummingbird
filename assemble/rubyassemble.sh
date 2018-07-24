#!/bin/bash

##installs

if [ "$1" == "depend" ]; then
    sudo apt-get update
    sudo apt-get install default-jdk
    sudo apt-get install gnuplot-nox
    source ~/.bashrc
fi

if [ "$1" == "canu" ]; then
    wget https://github.com/marbl/canu/archive/v1.7.tar.gz
    gunzip -dc v1.7.tar.gz | tar -xf -
    cd canu-1.7/src
    make -j 8
    cd ..
fi

if ["$1" == "canu.java"]; then
    sed 's/"java -showversion"/"java -version"/g' /shared/ > /shared/
    cd /shared/canu-1.7/src
    make -j 8
    cd ..
fi

##running example usage

if [ "$1" == "run" ]; then
    /shared/canu-1.7/Linux-amd64/bin/canu -p ruby -d ruby.assemble genomeSize=1g -nanopore-raw /shared/*.fastq.gz -batMemory=56 -merylMemory=56 gnuplotTested=true corMhapMemory=56 ovsMethod=sequential 'corMhapOptions=--threshold 0.8 --num-hashes 512 --ordered-sketch-size 1000 --ordered-kmer-size 14' cnsErrorRate=0.25
fi

if [ "$1" == "aln" ]; then
    source activate minimap2
    minimap2 -ax map-ont -t 8 ./ruby.assemble/ruby.contigs.fasta mg96.98.clean.fq | samtools sort -o rubyalign.sorted.bam -T reads.tmp
    samtools index rubyalign.sorted.bam
fi

if [ "$1" == "index" ]; then
    source activate polish
    nanopolish index -d ruby.fast5/ mg96.98.clean.fq
fi

if [ "$1" == "consensus" ]; then
    source activate polish
    python nanopolish_makerange.py ruby.contigs.fasta | parallel --results nanopolish.results -P 8 \
	   nanopolish variants --consensus polished.{1}.fa -w {1} -r mg96.98.clean.fq -b rubyalign.sorted.bam -g ruby.contigs.fasta -t 4 --min-candidate-frequency 0.1

    
