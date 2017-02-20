#!/bin/bash

##Gives settings used for BLAST to generate hits for COGENT gene families
blastp -db /home/shao4/blastDB/nr -query ./cogent_genefam.fa -outfmt "6 qacc sacc qstart qend qlen stitle" -num_threads 10 -max_target_seqs 1 >cogent_genefam_ID.txt
