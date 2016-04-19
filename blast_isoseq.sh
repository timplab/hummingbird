#!/bin/bash

##This is more random lines of code to be pasted than a script

#After gunzipping chicken
#makeblastdb -in /mithril/Data/Pacbio/Aligned/101915_proc/blast/full_final.fa -out /mithril/Data/Pacbio/Aligned/101915_proc/blast/humiso_blast -dbtype nucl -input_type fasta

#makeblastdb -in /mithril/Data/Pacbio/Aligned/011116_trinotate/full_final.fa.transdecoder.cds -out ~/blastdb/humiso_cds/160412_cds_blastdb -dbtype nucl -input_type fasta
 
#makeblastdb -in /mithril/Data/Pacbio/Aligned/011116_trinotate/full_final.fa.transdecoder.pep -out ~/blastdb/humiso_pep/160412_pep_blastdb -dbtype prot -input_type fasta

#blastn -db /mithril/Data/NGS/Reference/chicken/gal4blast -query gal_pyruvate_carboxylate.fasta -gapopen 5 -gapextend 2 -word_size 11 -evalue 1e-20

#blastall -p blastn -d /mithril/Data/NGS/Reference/human/hg19blast -i AF509529.fasta -G 5 -E 2 -W 15 -r 2 -F "m D" -e 10 -m 1
#blastall -p blastn -d /mithril/Data/NGS/Reference/human/hg19blast -i AF509529.fasta -G 5 -E 2 -W 15 -r 2 -F "m D" -e 10 -m 6

blastn -db /mithril/Data/Pacbio/Aligned/101915_proc/blast/humiso_blast -query /home/rworkman/Dropbox/Hbird_rw/XM_008503695_GLUT1cal.fasta -gapopen 1 -gapextend 2 -word_size 9 -reward 1 -evalue 10 -outfmt 7 >/home/rworkman/Dropbox/Hbird_rw/isoseq_calypte_GLUT1.tsv

blastn -db /mithril/Data/Pacbio/Aligned/101915_proc/blast/humiso_blast -query /home/rworkman/Dropbox/Hbird_rw/XM_008503695.fasta -gapopen 1 -gapextend 2 -word_size 9 -reward 1 -evalue 10 -outfmt 7 >/home/rworkman/Dropbox/Hbird_rw/isoseq_calypte_fgt1.tsv





