library(Biostrings)
library(GenomicRanges)

output=file.path("home/rworkman/Dropbox/Hbird_rw")

alldata=readDNAStringSet("/mithril/Data/Pacbio/Aligned/101915_proc/blast/full_final.fa")

#loading sample list
hbirdsamplist=read.csv("~/Dropbox/Hbird_rw/010516_hbird_GLUT.csv", header=TRUE)

##Init protein output
#prot.trim=AAStringSet()

##loop
##how many things to test
#mRNA=RNAStringSet()
mRNA.list = list()
mRNA.df = data.frame(name=character(),sequence=character())
for (i in hbirdsamplist$SubjectID) {

        ##search for sample name within samplist, pull out and generate table
    
    ##samptest=which(hbirdsamplist$subjectid == "c76411/161018")
    
    ##look here:
                                        #head(names(alldata))
    ##so instead you need to not assume exact match, you need to see if your string is in the name at all
    number=which(grepl(i, names(alldata))) 
         
                                        #read in data as string
                                        ##edited
                                        ##double-bracket to get out XString instead of XStringSet
    untrimRNA=RNAString(alldata[[number]])
    
   mRNA.list[[i]] = RNAStringSet(untrimRNA)
    mRNA.df = rbind(mRNA.df,data.frame(name=i,sequence=as.character(RNAStringSet(untrimRNA))))
   # mRNA=c(mRNA, RNAStringSet(untrimRNA))

 }                                      #transcribe to mRNA

write.csv(mRNA.df, file=("~/Dropbox/Hbird_rw/GLUTmRNA.csv"))
 
##untrimCDS=RNAStringSet("untrimDNA")
    
    ##Find possible start sites
    #matchPattern("AUG", untrimRNA)
#    startlocs=start(matchPattern("AUG", untrimRNA))
        
    ##Translate first
#  prot=translate(untrimRNA)


    ##Then look for * - which is AA string representation of stop
    
  #  stoplocs=start(matchPattern("*", prot))
    
   prot.trim=c(prot.trim,AAStringSet(prot))

    ##and Voila
}

tocat=as.character(prot.trim, 
