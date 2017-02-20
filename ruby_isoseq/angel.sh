#!/bin/bash

#running dumb ORF prediction, outputs training.cds, training.utr
python ~/repos/ANGEL/dumb_predict.py ~/ruby/cogent/20161001_collapsed_using_Cogent/cogent_genefam.fa --min_aa_length 300 --cpus 12

#making random training set, outputs training pickle
python angel_train.py ./ruby/final.training.cds ruby.final.training.utr ./ruby.training.pickle --cpus 12

#running best ORF prediction 
python ~/repos/ANGEL/angel_predict.py ~/ruby/cogent/20161001_collapsed_using_Cogent/cogent_genefam.fa ./ruby.training.pickle angelcogent --min_angel_aa_length 50 --min_dumb_aa_length 100 --output_mode best --cpus 10
