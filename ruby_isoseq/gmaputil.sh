#!/bin/bash

#build a ref
/home/rworkman/tools/gmap/bin/gmap_build -g -D ./ -d galgal5 /mithril/Data/NGS/Reference/chicken5/GCF_000002315.4_Gallus_gallus-5.0_genomic.fna.gz 

###RUNNING gmap
#nice -n 2 /home/rworkman/tools/gmap/bin/gmap -D ~/ruby/GMAP -d canna -f samse -n 0 -z sense_force -t 8 ~/ruby/dnanexus/rubyallcluster.consensus_isoforms.fasta >rubyalign.fa.sam 2>rubyalign_all.sam.log

#nice -n 1 /home/rworkman/tools/gmap/bin/gmap -D ~/ruby/GMAP -d canna -f samse -n 0 -z sense_force -t 8 ~/ruby/GMAP/cogent_genefam.fa >cogentalign.fa.sam 2>cogentalign.sam.log


nice -n 1 /home/rworkman/tools/gmap/bin/gmap -D ~/ruby/GMAP -d galgal5 -f samse -n 0 -z sense_force -t 10 ~/ruby/GMAP/cogent_genefam.fa >galrubyCCDalign.sam 2>galrubyCCDalign.sam.log


###GMAP summary
#python ~/repos/cDNA_Cupcake/sequence/summarize_gmap_sam.py ~/ruby/dnanexus/rubyallcluster.consensus_isoforms.fasta ./rubyalign.fa.sam &>log2.gmap.summ.txt

#python ~/repos/cDNA_Cupcake/sequence/summarize_gmap_sam.py ~/ruby/dnanexus/rubyallcluster.hq_isoforms.fasta ./HQDrubyalign.sam



#samtools view -bS rubyallcluster.consensus_isoforms.fasta.sam > rubyallcluster.bam

#samtools sort rubyallcluster.bam ~/ruby/rubyallcluster.consensus_isoforms.fasta

#samtools index rubyallcluster.bam
