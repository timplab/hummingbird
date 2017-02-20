#Given a set of orthologous group names, this script isolates the names of groups unique to a given pairing and then pulls the affiliated sequence of the group, given that the sequence name is conserved between the fasta and the orthologous group list. 

library(Biostrings)
library(GenomicRanges)

#Upload set of orthologs for ruby-throated hummingbird, X species pair
zebra=read.table("~/ruby/orthomcl/pairs/orthv1/orthv2/ot_wz_whumm.txt", stringsAsFactors=FALSE)
budgi=read.table("~/ruby/orthomcl/pairs/orthv1/orthv2/ot_bw_whumm.txt", stringsAsFactors=FALSE)
annas=read.table("~/ruby/orthomcl/pairs/orthv1/orthv2/ot_aw_whumm.txt", stringsAsFactors=FALSE)
swift=read.table("~/ruby/orthomcl/pairs/orthv1/orthv2/ot_cw_whumm.txt", stringsAsFactors=FALSE)
gallus=read.table("~/ruby/orthomcl/pairs/orthv1/orthv2/ot_gw_whumm.txt", stringsAsFactors=FALSE)

#Make dataframe containing all orthologs except for anna's hummingbird/ruby-throated overlap
allbutanna=rbind(zebra, budgi, swift, gallus)
abamat=as.matrix(allbutanna)
annamat=as.matrix(annas)
annaunique=setdiff(annamat, abamat)

annaunique.df=data.frame(annaunique)
colnames(annaunique.df)=c("matchID")

#Upload fasta of ruby-throated sequences for matching
seqs=readAAStringSet("~/ruby/orthomcl/adjusted/whumm.fasta")

#Loop to pull out sequences for unique groups
sequencelist=list()
anna.omcl.df=data.frame(name=character(), sequence=character(), stringsAsFactors=FALSE)
for (i in annaunique.df$matchID) {
    matches=which(i==names((seqs)))
    sequence=AAString(seqs[[matches]])
    sequencelist[[i]]=AAStringSet(sequence)
    anna.omcl.df=rbind(anna.omcl.df, data.frame(name=i, sequence=as.character(AAStringSet(sequence))))
}

#print sequences to file
seq=anna.omcl.df$sequence
AAtofile=AAStringSet(seq, use.names=TRUE)
writeXStringSet(AAtofile, file="~/ruby/orthomcl/rubyunique.fa")






    
