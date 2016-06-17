from Bio.Blast.Applications import NcbiblastnCommandline
from Bio import SearchIO


humdb="/mithril/Data/Pacbio/Aligned/151019_proc/blast/humiso_blast"

blastn_cline=NcbiblastnCommandline(query="temp.fasta", db=humdb, gapopen=1, gapextend=2, word_size=9, reward=1, evalue=10, outfmt=5, out="try.xml")

stdout, stderr=blastn_cline()

bres=SearchIO.read("try.xml", 'blast-xml')
SearchIO.write(bres, 'try.tsv', 'blast-tab')

##ok - this was nice, but can't output because blast is pairwise, and I think we actually want a MAF

