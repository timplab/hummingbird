#!/bin/bash 


if [ "$1" == "aln" ]; then
    /home/ubuntu/minimap2/minimap2 -d ruby_ref.mmi ruby.contigs.fasta
    /home/ubuntu/minimap2/minimap2 -t 72 -ax map-ont ruby_ref.mmi mg96.98.clean.fq.gz |
    samtools view -b  | samtools sort -o ruby.align.bam
    samtools index ruby.align.bam
fi


if [ "$1" == "index" ]; then
       # conda activate polish
       /home/ubuntu/yfan/nanopolish/nanopolish index -d /home/ubuntu/data/ -s summaryCAT.txt  mg96.98.clean.fq.gz
fi


outdir='/home/ubuntu/polished_vcf/'

if [ "$1" == "consensus" ]; then
   # conda activate polish
    python /home/ubuntu/ag/nanopolish/scripts/nanopolish_makerange.py ruby.contigs.fasta | parallel --results nanopolish.results -P 9 \
	/home/ubuntu/ag/nanopolish/nanopolish variants --consensus -o ${outdir}/polished.{1}.vcf -w {1} -r mg96.98.clean.fq.gz -b ruby.align.bam -g ruby.contigs.fasta -t 8 --min-candidate-frequency 0.1
fi

if [ "$1" == "merge" ]; then
      /home/ubuntu/ag/nanopolish/nanopolish vcf2fasta -g ruby.contigs.fasta ./polished_vcf/polished.*.vcf > ruby_polished_genome.fa

fi


