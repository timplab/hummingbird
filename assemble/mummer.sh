#!/bin/bash 
if [ "$1" == "mummer" ]; then
ref=/home/ubuntu/hbird/assemblies/CAnna_ref.fa 
qry=/home/ubuntu/hbird/assemblies/ruby_polished_genome.fa

/home/ubuntu/repos/MUMmer3.23/nucmer --prefix=canna_ruby $ref $qry

/home/ubuntu/repos/MUMmer3.23/show-coords -rcl canna_ruby.delta > canna_ruby.coords

/home/ubuntu/repos/MUMmer3.23/show-aligns canna_ruby.delta   > canna_ruby.aligns

/home/ubuntu/repos/MUMmer3.23/show-tiling canna_ruby.delta > canna_ruby.tiling

/home/ubuntu/repos/MUMmer3.23/delta-filter -q canna_ruby.delta > canna_ruby.filter

mummerplot canna_ruby.tiling -R $ref -Q $query --filter --layout
fi

if [ "$1" == "plot" ]; then
ref=/kyber/Data/temp/gmoney/hummingbird/assembly/CAnna_ref.fa
qry=/kyber/Data/temp/gmoney/hummingbird/assembly/ruby_polished_genome.fa
source activate mummer_env 
#/home/gmoney/.conda/envs/mummer_env/mummer-4.0.0beta2/bin/delta-filter -q canna_ruby.delta > canna_ruby.filter
/home/gmoney/.conda/envs/mummer_env/mummer-4.0.0beta2/bin/mummerplot --png /kyber/Data/temp/gmoney/hummingbird/canna_ruby.filter -l -R $ref -Q $qry
fi
