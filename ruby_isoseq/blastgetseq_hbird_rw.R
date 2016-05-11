#goals=take NCBI accession number, convert to GI, then pull out ref seq from NCBI. Query list of seqs against hbird blast db, generate .tsv of hits. Then for each .tsv, use ID num of hits in our db to pull out corresponding seq

library(annotate)
library(Biostrings)

workdir="/mithril/Data/Pacbio/Aligned/160511_blasting"

acc.num.mRNA=read.csv(file.path(workdir, "HbirdmRNAaccnum.csv"), header=TRUE)
acc.num.AA=read.csv(file.path(workdir, "HbirdAAaccnum.csv"), header=TRUE)

#Step1: Generate list of ref seqs to blast

#error = function(e) {print(paste0(acc.num.mRNA$Enzyme.Name, " error")); return(NA)})

for (i in 1:dim(acc.num.mRNA)[1]) {
    ##If accnum isn't an accession, dies, so error catch here
    ginum=tryCatch(getGI(acc.num.mRNA$Accnum[i]),
                   error = function(e) {print(paste0(acc.num.mRNA$Enzyme.Name[i]," error")); return(NA)})
    if (!is.na(ginum)) {
        acc.num.mRNA$gi.num[i]=ginum
        acc.num.mRNA$seq=getSEQ(ginum)
    } else {
        acc.num.mRNA$gi.num[i]=NA
        acc.num.mRNA$seq[i]=NA
    }
}

##Remove all NAs
acc.num.mRNA=acc.num.mRNA[!is.na(acc.num.mRNA$seq),]

#write.csv(blast.df,file="~/Dropbox/Hbird_rw/fan/160408_blastdf_test4.csv")

#Step1.5: Convert csv to fasta

#csv=read.csv("~/Dropbox/Hbird_rw/fan/160408_blastdf_test4.csv",stringsAsFactors=FALSE)
#seq=csv$sequence
#names(seq)=csv$accnum
#dna=DNAStringSet(seq)

#for (i in seq(length(seq))){
#    writeXStringSet(dna[i],append=TRUE,filepath="~/Dropbox/Hbird_rw/fan/fasta/blastmRNA2.fasta")
#    }

#Step2: Blast seqs against db, drop all .tsvs in new folder

##ok - simplest answer is to make some temp files and do a system call

##Could loop, for now just running first one
i=1

temp.fasta=file.path(workdir, "temp.fasta")
temp.blast=file.path(workdir, "temp.blast.tsv")

##DNA instead of RNA because apparently accession is for cDNA?

writeXStringSet(DNAStringSet(acc.num.mRNA$seq[i]), temp.fasta, append=FALSE, format="fasta")

##Database location
hum.db="/mithril/Data/Pacbio/Aligned/151019_proc/blast/humiso_blast"

system(paste("blastn", "-db", hum.db, "-query", temp.fasta, "-gapopen 1 -gapextend 2 -word_size 9 -reward 1 -evalue 10 -outfmt 7 -out", temp.blast))

#Step3: Pull out sequence ID from .tsv, then generate sequence (only aligned sequence?) to append on the OG .tsv files
##column names for blast fmt 7
blast.cnames=c("query id", "subject id", "per.identity", "alignment.length", "mismatches", "gap.opens", "q.start", "q.end", "s.start", "s.end", "evalue", "bit.score")

blast.res=read.delim(temp.blast, header=F, skip=5, col.names=blast.cnames)
##Remove the last line that just says processing
blast.res=blast.res[!is.na(blast.res$evalue),]

##Do whatever filtering?

##Write out file of hits?  Get out seqs of hits?  plot alignment?  Not sure what next?
