library(tidyverse)
library(googlesheets)

outdir="~/Dropbox/Data/Genetics/Hummingbird/171008_pilon/"

setwd(outdir)

for (round in 1:10){

    system(paste0("aws s3 cp s3://timpawsanalysis/171001_hbird/", round, ".pilon.changes ."))

}

system("wc -l *changes >pilon.changes.txt")

meta=read_table("pilon.changes.txt", col_names=F) %>%
    filter(X2 != "total")

colnames(meta)=c("num", "fname")

meta=meta %>%
    separate(fname, c("samp"), remove=F, extra="drop", convert=T)

pdf(file.path(outdir, "pilons.pdf"))

print(ggplot(meta, aes(x=samp, y=num))+theme_classic()+geom_line()+scale_y_log10())

dev.off()
