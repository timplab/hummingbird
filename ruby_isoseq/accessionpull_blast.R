#Takes NCBI accession number, convert to GI, then pull out ref seq from NCBI. Query list of seqs against hbird blast db, generate .tsv of hits. Then for each .tsv, use ID num of hits in our db to pull out corresponding seq

library(annotate)
library(Biostrings)
library(msa)

#Set working directories, upload relevant files containing list of accession numbers for a given enzyme
workdir="/home/rworkman/ruby/pathway"
outdir="/home/rworkman/ruby/pathway/blastingAA"
acc.num.mRNA=read.csv(file.path(workdir, "aa_pathway_updated.csv"), header=TRUE)
acc.num.AA=read.csv(file.path(workdir, "aa_pathway_updated.csv"), header=TRUE)
colnames(acc.num.AA)=c("organism", "enzyme", "accnum")

#Step1: Generate list of ref seqs to blast

for (i in 1:dim(acc.num.AA)[1]) {
    ##If accnum isn't an accession, dies, so error catch here
    ginum=tryCatch(getGI(acc.num.AA$accnum[i]),
                   error = function(e) {print(paste0(acc.num.AA$enzyme[i]," error")); return(NA)})
    ginum
    if (!is.na(ginum)) {
        acc.num.AA$gi.num[i]=ginum
        acc.num.AA$seq[i]=getSEQ(ginum)
    } else {
        acc.num.AA$gi.num[i]=NA
        acc.num.AA$seq[i]=NA
    }
}

##Remove all NAs
acc.num.AA=acc.num.AA[!is.na(acc.num.AA$seq),]
names(acc.num.AA)=c("pathway", "organism", "names", "accnum","notes", "gi", "seq")

##Make clean name
acc.num.AA$clean.name=acc.num.AA$enzyme
acc.num.AA$clean.name=gsub("[ :]", ".", acc.num.AA$clean.name)
acc.num.AA$clean.name=gsub("[()]", "", acc.num.AA$clean.name)

#add species to clean name if running same enzymes for multiple organisms
acc.num.AA$clean.name=paste(acc.num.AA$organism, acc.num.AA$clean.name, sep="_")
acc.AA=AAStringSet(acc.num.AA$seq)
names(acc.AA)=acc.num.AA$clean.name

##set BLAST database location
hum.db="~/ruby/blast/humiso_pepArrow/HQarrow_ruby.ANGEL.pep"
    
##upload file containing whole dataset for matching 
hum.AA=readAAStringSet(file="~/ruby/blast/humiso_pepArrow/HQarrow_ruby.ANGEL.pep")

##Trim out extra stuff from names
names(hum.AA)=unlist(lapply(strsplit(names(hum.AA), split=" "), function(x) {x[1]}))

setwd(outdir)
for (i in 1:length(acc.AA)) {
    temp.fasta=file.path(outdir, paste0(acc.num.AA$clean.name[i], ".fasta"))
    temp.blast=file.path(outdir, paste0(acc.num.AA$clean.name[i], ".blast.tsv"))
    temp.html=file.path(outdir, paste0(acc.num.AA$clean.name[i], ".blast.html"))
    temp.align.fasta=file.path(outdir, paste0(acc.num.AA$clean.name[i], ".align.fasta"))
    temp.msa.fasta=file.path(outdir, paste0(acc.num.AA$clean.name[i], ".msa.fasta"))
    temp.msa.pdf=file.path(outdir, paste0(acc.num.AA$clean.name[i], ".msa.pdf"))
    
    writeXStringSet(acc.AA[i], temp.fasta, append=FALSE, format="fasta")
        
    system(paste("blastp", "-db", hum.db, "-query", temp.fasta, "-evalue .01 -outfmt '7 std qseq sseq stitle' -out", temp.blast))
    
    system(paste0("~/Code/mview/bin/mview -in blast ", temp.blast, " -html head -coloring identity -moltype dna >", temp.html))
    system(paste0("~/Code/mview/bin/mview -in blast ", temp.blast, " -out fasta >", temp.align.fasta))

    ##Ok MSA

    fields=c("query.id", "subject.id", "per.identity", "alignment.length", "mismatches" , "gap.opens", "q.start", "q.end", "s.start", "s.end", "evalue", "bit.score", "query.seq", "subject.seq", "subject.title")

    blast.res=read.delim(temp.blast, skip=5, header=F, col.names=fields)
    blast.res=blast.res[-nrow(blast.res),]
    
    hum.match=hum.AA[pmatch(unique(blast.res$subject.id), names(hum.AA))]
    
    msa.res=msa(c(acc.mRNA[i], hum.match))

    msaPrettyPrint(msa.res, output="pdf", askForOverwrite=FALSE, file=temp.msa.pdf, alFile=temp.msa.fasta, verbose=FALSE, paperWidth=11, paperHeight=8.5)
    
}
