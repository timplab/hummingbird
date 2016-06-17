#goals=take NCBI accession number, convert to GI, then pull out ref seq from NCBI. Query list of seqs against hbird blast db, generate .tsv of hits. Then for each .tsv, use ID num of hits in our db to pull out corresponding seq

library(annotate)
library(Biostrings)
library(msa)

workdir="/mithril/Data/Pacbio/Aligned/160511_blasting"
outdir="/home/timp/Dropbox/Data/Genetics/Hummingbird/160617_blasting"


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

##Make clean name
acc.num.mRNA$clean.name=acc.num.mRNA$Enzyme.Name
acc.num.mRNA$clean.name=gsub("[ :]", ".", acc.num.mRNA$clean.name)
acc.num.mRNA$clean.name=gsub("[()]", "", acc.num.mRNA$clean.name)

acc.mRNA=DNAStringSet(acc.num.mRNA$seq)
names(acc.mRNA)=acc.num.mRNA$clean.name


##Database location
hum.db="/mithril/Data/Pacbio/Aligned/151019_proc/blast/humiso_blast"
    
##Full mRNA Pacbio stuff
hum.mRNA=readDNAStringSet(file="/mithril/Data/Pacbio/Aligned/151019_proc/blast/full_final.fa")
##Trim out extra stuff from names
names(hum.mRNA)=unlist(lapply(strsplit(names(hum.mRNA), split=" "), function(x) {x[1]}))

setwd(outdir)
##Could loop, for now just running first one
for (i in 1:length(acc.mRNA)) {
    temp.fasta=file.path(outdir, paste0(acc.num.mRNA$clean.name[i], ".fasta"))
    temp.blast=file.path(outdir, paste0(acc.num.mRNA$clean.name[i], ".blast.tsv"))
    temp.html=file.path(outdir, paste0(acc.num.mRNA$clean.name[i], ".blast.html"))
    temp.align.fasta=file.path(outdir, paste0(acc.num.mRNA$clean.name[i], ".align.fasta"))
    temp.msa.fasta=file.path(outdir, paste0(acc.num.mRNA$clean.name[i], ".msa.fasta"))
    temp.msa.pdf=file.path(outdir, paste0(acc.num.mRNA$clean.name[i], ".msa.pdf"))
    
    ##DNA instead of RNA because apparently accession is for cDNA?
    
    writeXStringSet(acc.mRNA[i], temp.fasta, append=FALSE, format="fasta")
        
    system(paste("blastn", "-db", hum.db, "-query", temp.fasta, "-gapopen 1 -gapextend 2 -word_size 9 -reward 1 -evalue .01 -outfmt '7 std qseq sseq stitle' -out", temp.blast))
    
    system(paste0("~/Code/mview/bin/mview -in blast ", temp.blast, " -html head -coloring identity -moltype dna >", temp.html))
    system(paste0("~/Code/mview/bin/mview -in blast ", temp.blast, " -out fasta >", temp.align.fasta))


    ##Ok MSA

    fields=c("query.id", "subject.id", "per.identity", "alignment.length", "mismatches" , "gap.opens", "q.start", "q.end", "s.start", "s.end", "evalue", "bit.score", "query.seq", "subject.seq", "subject.title")

    blast.res=read.delim(temp.blast, skip=5, header=F, col.names=fields)
    blast.res=blast.res[-nrow(blast.res),]
    
    hum.match=hum.mRNA[pmatch(unique(blast.res$subject.id), names(hum.mRNA))]
    
    msa.res=msa(c(acc.mRNA[i], hum.match))

    msaPrettyPrint(msa.res, output="pdf", askForOverwrite=FALSE, file=temp.msa.pdf, alFile=temp.msa.fasta, verbose=FALSE, paperWidth=11, paperHeight=8.5)
    
}
