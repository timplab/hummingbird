#!/bin/bash
sumdir=/kyber/Data/temp/gmoney/hummingbird/data/summary
out=/kyber/Data/temp/gmoney/hummingbird/alignment/sum/summaryCAT.txt
sums=$(find $sumdir -name "*tsv.gz")
gunzip -c $sums |\
  awk 'NR==1||$1!="filename"{ print }' > $out
