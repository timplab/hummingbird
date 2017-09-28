#!/bin/bash

##Order, conda, pilon.make, get.data, bt.lib


if [ "$1" == "clean" ]; then
    rm -Rf /shared/install
    rm -Rf /shared/conda
    rm -Rf /shared/nanopolish
fi

if [ "$1" == "conda" ]; then
    cd /shared
    mkdir -p install
    cd /shared/install
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    ##Suggest install to /shared/conda
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /shared/conda
    
    echo 'export PATH=/shared/conda/bin:$PATH' >> ~/.bashrc  
fi

if [ "$1" == "get.data" ]; then

    mkdir -p /shared/data
    cd /shared/data
    scp timp@duchess.timplab.com:/atium/Data/NGS/Raw/170901_hbird/wtimp1_139123/FASTQ/HTCV7BCXY_2_0_1.fastq.gz /shared/data/read1.fq.gz
    scp timp@duchess.timplab.com:/atium/Data/NGS/Raw/170901_hbird/wtimp1_139123/FASTQ/HTCV7BCXY_2_0_2.fastq.gz /shared/data/read2.fq.gz
    #rsync -avz -e ssh timp@duchess.timplab.com:/atium/Data/NGS/Raw/170901_hbird/wtimp1_139123/FASTQ/HTCV7BCXY_2_0_* ./
    
    scp timp@duchess.timplab.com:/atium/Data/NGS/Aligned/170901_rubylex_hiseq/cogent_genefam.fa /shared/data/cogent_genefam.fa
    
    
fi


if [ "$1" == "installs" ]; then
    conda install -c bioconda bowtie2 pilon samtools atropos trim-galore
    
    pip install --upgrade atropos
fi

if [ "$1" == "trim.reads" ]; then

    echo "Trimming"
    
    atropos --aligner insert -a AGATCGGAAGAGC -A AGATCGGAAGAGC \
	    -o /shared/data/trim1.fq.gz -p /shared/data/trim2.fq.gz \
	    -pe1 /shared/data/test1.fq.gz -pe2 /shared/data/test2.fq.gz \
	    -q 25 -i 10 -I 7 --discard-trimmed
    ##--op-order ACQ

    
    #trim_galore --gzip -q 25 --paired --clip_R1 10 --clip_R2 7 test1.fq.gz test2.fq.gz
    #trim_galore --gzip --paired test1.fq.gz test2.fq.gz
	    
fi


if [ "$1" == "pilon.rounds" ]; then

    echo "Pilon"


fi

