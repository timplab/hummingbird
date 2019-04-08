#!/bin/bash 
# Building a large index
if [ "$1" == "index" ]; then
  bowtie2-build --large-index /kyber/Data/temp/gmoney/hummingbird/assembly/ruby_polished_genome.fa /kyber/Data/temp/gmoney/hummingbird/ill_alignment/ruby
fi

# Inspecting the entire lambda virus index (large index)
if [ "$1" == "inspect" ]; then
  bowtie2-inspect --large-index /kyber/Data/temp/gmoney/hummingbird/ill_alignment/ruby
fi
# Aligning paired reads
if [ "$1" == "align" ]; then
  path_to_my_fastqfiles=/kyber/Data/temp/gmoney/hummingbird/data/illumina/fastq
  outdir=/kyber/Data/temp/gmoney/hummingbird/ill_alignment

  file=$(find $path_to_my_fastqfiles -name "*fastq")
  for i in $file
  do 
    echo $i
    basename "$i"
    f=$(basename "$i" .fastq)
    echo $f
    f=${f::-2}
    echo $f
    bowtie2 -x /kyber/Data/temp/gmoney/hummingbird/ill_alignment/ruby -1 ${path_to_my_fastqfiles}/${f}_1.fastq -2 ${path_to_my_fastqfiles}/${f}_2.fastq -S ${outdir}/$f.sam
#| samtools view -b | samtools sort -o ${outdir}/$i.bam
   # samtools index ${outdir}/$i.bam
  done
fi
