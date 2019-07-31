#!/bin/bash 

#first align all reads to make separate bams in minimap
if [ "$1" == "aln" ]; then
   # /home/ubuntu/minimap2/minimap2 -d ruby_polished_ref.mmi ruby_polished_genome.fa
    path_to_my_fastqfiles=/home/ubuntu/np_fastq
    outdir=/home/ubuntu/methylation/bam
    file=$(find $path_to_my_fastqfiles -name "*fastq.gz")
    for i in $file
    do
      echo $i
      basename "$i"
      f=$(basename "$i" .fastq)
      f=${f::-9}
      echo $f
      /home/ubuntu/minimap2/minimap2 -t 72 -ax map-ont ruby_polished_ref.mmi $i |
      samtools view -b  | samtools sort -o ${outdir}/${f}.bam
      samtools index ${outdir}/ ${f}.bam
    done
fi

if [ "$1" == "meth" ]; then
  path_to_my_fastqfiles=/home/ubuntu/np_fastq
  outdir=/home/ubuntu/methylation
  path_to_sum=/home/ubuntu/summary
  path_to_fast5=/home/ubuntu/data
  file=$(find $path_to_my_fastqfiles -name "*fastq.gz")
  for i in $file
  do
    echo $i
    basename "$i"
    f=$(basename "$i" .fastq.gz)
    # f=${f::-9}
    echo $f
    /home/ubuntu/ag/nanopolish/nanopolish index -d ${path_to_fast5}/${f} -s ${path_to_sum}/${f}.tsv ${i}
    /home/ubuntu/ag/nanopolish/nanopolish call-methylation -t 72 -r $i -b ${path_to_bam}/${f}.bam -g ruby_polished_genome.fa  > ${outdir}/${f}.methylation_calls.tsv
  done
fi
