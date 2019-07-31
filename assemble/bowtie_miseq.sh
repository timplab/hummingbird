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
  path_to_my_fastqfiles=/kyber/Data/temp/gmoney/hummingbird/data/190417_miseq
  outdir=/kyber/Data/temp/gmoney/hummingbird/data/190417_miseq/alignment
  bowtie2 -x /kyber/Data/temp/gmoney/hummingbird/ill_alignment/ruby -1 ${path_to_my_fastqfiles}/100417-hbird-gDNA_S1_L001_R1_001.fastq -2 ${path_to_my_fastqfiles}/100417-hbird-gDNA_S1_L001_R2_001.fastq -S ${outdir}/miseq.sam | samtools view -b | samtools sort -o ${outdir}/miseq.bam
  samtools index ${outdir}/miseq.bam
fi

