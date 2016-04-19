#goals=take NCBI accession number, convert to GI, then pull out ref seq from NCBI. Query list of seqs against hbird blast db, generate .tsv of hits. Then for each .tsv, use ID num of hits in our db to pull out corresponding seq

library(annotate)
library(Biostrings)

accnummRNA=read.csv("~/Dropbox/Hbird_rw/fan/HbirdmRNAaccnum.csv", header=TRUE)
accnumAA=read.csv("~/Dropbox/Hbird_rw/fan/HbirdAAaccnum.csv", header=TRUE)

#Step1: Generate list of ref seqs to blast
blast.list = list()
blast.df = data.frame(name=character(),sequence=character())
for (i in accnummRNA$Accnum) {
    blast.list=getGI(i)
    allSEQ=getSEQ(blast.list)
    blast.df=rbind(blast.df, data.frame(accnum=i, sequence=as.character(allSEQ)))
}

write.csv(blast.df,file="~/Dropbox/Hbird_rw/fan/160408_blastdf_test4.csv")

#Step1.5: Convert csv to fasta

csv=read.csv("~/Dropbox/Hbird_rw/fan/160408_blastdf_test4.csv",stringsAsFactors=FALSE)
seq=csv$sequence
names(seq)=csv$accnum
dna=DNAStringSet(seq)

for (i in seq(length(seq))){
    writeXStringSet(dna[i],append=TRUE,filepath="~/Dropbox/Hbird_rw/fan/fasta/blastmRNA2.fasta")
    }
    

#Step2: Blast seqs against db, drop all .tsvs in new folder

#Step3: Pull out sequence ID from .tsv, then generate sequence (only aligned sequence?) to append on the OG .tsv files
