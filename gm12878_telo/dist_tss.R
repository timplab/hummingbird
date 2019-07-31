library(tidyverse)
library(data.table)

chr_list <- c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", 
              "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", 
              "chr19", "chr20", "chr21", "chr22", "chrX", "chrY")

chr_num <-as.character(c(1:22))
chr_num <- append(chr_num, c("X", "Y"))   
# read in data 
tss <- read_tsv("/kyber/Data/Nanopore/Analysis/gmoney/gm12878_teloprime/tss/mart_export.txt.gz", col_names = F) %>%
  filter(X4 %in%chr_num) %>%
  group_by(X4) %>%
  mutate(X3 = as.numeric(X3)) %>%
  group_split()

ont <- read_tsv("/kyber/Data/Nanopore/Analysis/gmoney/gm12878_teloprime/tss/ont.bed", col_names = F) %>%
  filter(X1 %in%chr_list) %>%
  group_by(X1) %>%
  group_split()

telo <- read_tsv("/kyber/Data/Nanopore/Analysis/gmoney/gm12878_teloprime/tss/teloprime.bed", col_names = F) %>%
  filter(X1 %in%chr_list) %>%
  group_by(X1) %>%
  group_split()

# find closest tss
ont_tss_total = data.frame()

for (i in 1:length(chr_list)){
  a=data.table(Value=ont[[i]]$X2)
  a[,merge:=Value]
  b=data.table(Value=tss[[i]]$X3)
  b[,merge:=Value]
  setkeyv(a,c('merge'))
  setkeyv(b,c('merge'))
  Merge_a_b=b[a,roll='nearest', allow.cartesian=TRUE]
  
  ont_tss <- as_tibble(Merge_a_b) %>%
    rename(nearest_tss = Value) %>%
    rename(ont_start = merge) %>%
    select(-c(i.Value)) %>%
    mutate(dist = abs(nearest_tss - ont_start)) %>%
    mutate(kit="ont") %>%
    mutate(i = paste("rep",i, sep = '')) %>%
    select(-c(nearest_tss,ont_start))
  ont_tss_total <- rbind(ont_tss, ont_tss_total)
}

telo_tss_total = data.frame()
for (i in 1:length(chr_list)){
  a=data.table(Value=telo[[i]]$X2)
  a[,merge:=Value]
  b=data.table(Value=tss[[i]]$X3)
  b[,merge:=Value]
  setkeyv(a,c('merge'))
  setkeyv(b,c('merge'))
  Merge_a_b=b[a,roll='nearest', allow.cartesian=TRUE]
  
  telo_tss <- as_tibble(Merge_a_b) %>%
    rename(nearest_tss = Value) %>%
    rename(telo_start = merge) %>%
    select(-c(i.Value)) %>%
    mutate(dist = abs(nearest_tss - telo_start)) %>%
    mutate(kit="telo") %>%
    mutate(i = paste("rep",i, sep = '')) %>%
    select(-c(nearest_tss,telo_start))
  telo_tss_total <- rbind(telo_tss, telo_tss_total)
}

dat1 <- rbind(telo_tss_total, ont_tss_total) 

dat <- dat1

dat$i[(dat$i)=="rep1"] <- "chr1"
dat$i[(dat$i)=="rep2"] <- "chr10"
dat$i[(dat$i)=="rep3"] <- "chr11"
dat$i[(dat$i)=="rep4"] <- "chr12"
dat$i[(dat$i)=="rep5"] <- "chr13"
dat$i[(dat$i)=="rep6"] <- "chr14"
dat$i[(dat$i)=="rep7"] <- "chr15"
dat$i[(dat$i)=="rep8"] <- "chr16"
dat$i[(dat$i)=="rep9"] <- "chr17"
dat$i[(dat$i)=="rep10"] <- "chr18"
dat$i[(dat$i)=="rep11"] <- "chr19"
dat$i[(dat$i)=="rep12"] <- "chr2"
dat$i[(dat$i)=="rep13"] <- "chr20"
dat$i[(dat$i)=="rep14"] <- "chr21"
dat$i[(dat$i)=="rep15"] <- "chr22"
dat$i[(dat$i)=="rep16"] <- "chr3"
dat$i[(dat$i)=="rep17"] <- "chr4"
dat$i[(dat$i)=="rep18"] <- "chr5"
dat$i[(dat$i)=="rep19"] <- "chr6"
dat$i[(dat$i)=="rep20"] <- "chr7"
dat$i[(dat$i)=="rep21"] <- "chr8"
dat$i[(dat$i)=="rep22"] <- "chr9"
dat$i[(dat$i)=="rep23"] <- "chrX"
dat$i[(dat$i)=="rep24"] <- "chrY"


ggplot(data =dat, aes(x = dist, color = kit))+geom_freqpoly()+theme_classic()+labs(x="distance to nearest TSS")+
  facet_wrap(~i, scales = "free_y")+xlim(0,5000)

# per chromosome stats
sum10 <- dat %>%
  group_by(kit,i) %>%
  mutate(total = n()) %>%
  filter(dist < 10) %>%
  mutate(ten = n()) %>%
  mutate(percent_10 = (ten/total)*100) %>%
  select(-c(dist)) %>%
  distinct()

sum100 <- dat %>%
  group_by(kit,i) %>%
  mutate(total = n()) %>%
  filter(dist < 100) %>%
  mutate(ten = n()) %>%
  mutate(percent_100 = (ten/total)*100) %>%
  select(-c(dist)) %>%
  distinct()

sum1000 <- dat %>%
  group_by(kit,i) %>%
  mutate(total = n()) %>%
  filter(dist < 1000) %>%
  mutate(ten = n()) %>%
  mutate(percent_1000 = (ten/total)*100) %>%
  select(-c(dist)) %>%
  distinct()

sum_stat <- cbind(sum10, sum100, sum1000) %>%
  select(kit, i, percent_10, percent_100, percent_1000)

ggplot(data =sum_stat, aes(x = i, y = percent_100, fill = kit))+geom_bar(stat = "identity", position = "dodge")+
  theme_classic()+
  labs(x= "chromosome", y = "Percent reads within 100bp of TSS")

# median distance to nearest TSS
ont_med <- median(ont_tss_total$dist)
telo_med <- median(telo_tss_total$dist)
