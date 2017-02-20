#!/bin/bash

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






