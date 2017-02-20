#!/bin/bash

<<<<<<< HEAD
refgenome=$1
toalign=$2

case $refgenome in
    gallus )
	echo "gallus"
	reffasta=/mithril/Data/NGS/Reference/chicken5/GCF_000002315.4_Gallus_gallus-5.0_genomic.fna.gz
	;;
    canna )
	echo "canna"
	reffasta=/mithril/Data/NGS/Reference/calypteanna2/Calypte_anna_Pacbio_FALCON_unzip_primary.fasta
	;;
esac

##to build a reference
/home/rworkman/tools/gmap/bin/gmap_build -g -D ./ -d ${reffasta}

##to run gmap

/home/rworkman/tools/gmap/bin/gmap -D ./ -d $refgenome -f samse -n 0 -z sense_force -t 8 ${toalign} > cogentalign.fa.sam 2>cogentalign_all.sam.log

##to summarize

python ~/repos/cDNA_Cupcake/sequence/summarize_gmap_sam.py ${toalign} ./cogentalign.fa.sam






=======
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
>>>>>>> 4e5b994472a365fe0cbe9a8a8288b42a04e46f4e
