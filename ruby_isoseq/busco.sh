#!/bin/bash

##be sure to clean headers before running, typically just a search and replace

sed 's,/,_,g' inputfile.fa

##Running BUSCO2

nameofrun=$1
geneset=$2
lineage=$3

case $lineage in
    aves )
	echo "Aves"
	refdb=/home/rworkman/ruby/busco/aves_odb9
	;;
    metazoan )
	echo "Metazoan"
	refdb=/home/rworkman/ruby/busco/metazoa
	;;
esac

python3 ~/repos/busco/BUSCO.py -o ${nameofrun} -i ${geneset} -l ${refdb} -m tran -f -c 8   

##Plotting BUSCO2

python3 ~/repos/busco/BUSCO_plot.py -wd /home/rworkman/ruby/busco/BUSCO_summaries





