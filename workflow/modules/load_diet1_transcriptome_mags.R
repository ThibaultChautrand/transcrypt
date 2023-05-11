library(tximport)
library(mixOmics)
library(ppcor)
library(mgcv)
library(MDFS)
setwd("/home/thibault/Documents/internship/workflow/data")
files = Sys.glob("./kallisto_rep/AS_*/abundance.tsv")
txi <- tximport(files, type = "kallisto", txOut = TRUE)
diet1_meta = read.table("~/Downloads/samples_metaT.Diet1.txt", header = T)

diet1ab = txi$abundance

result <- lapply(files, function(x) {
  split_string <- unlist(strsplit(x, "R"))[-1]
  gsub("[^0-9]+", "", split_string[1])
})

colnames(diet1ab) = paste0("R", unlist(result))

#diet1ab_fs = diet1ab_f[,na.omit(match(diet1_meta$sample,colnames(diet1ab_f)))]

mags = read.table("./9-MAGs-post-analysis-rel-ab/Combined.Diet1_hybrid_MAGs_v3.p97.besthit.profile.genome.rel.prop.SGB.Arumugam.tsv", sep = "\t", header =T, comment.char = "")
mags_ab = mags[,grep("D[0-9]{1,3}", colnames(mags))]

mag_meta = read.table("~/Downloads/samples_metaG.Diet1.txt", header = T)

colnames(mags_ab) = sub("D", "R", colnames(mags_ab))
diet1ab = diet1ab[,-1]

mags_ab_sorted = mags_ab[,na.omit(match(colnames(diet1ab), colnames(mags_ab)))]
rownames(mags_ab_sorted)<-make.names(mags$Species, unique=TRUE)
diet1ab_filtered = diet1ab[,-which(colnames(diet1ab) %in% setdiff(colnames(diet1ab),colnames(mags_ab_sorted) ))]
diet1ab_filtered = diet1ab_filtered[rowSums(diet1ab_filtered) > 0.1,]

pls.result <- pls(t(mags_ab_sorted), t(diet1ab_filtered)) # run the method
#plotIndiv(pls.result)
#plotVar(pls.result)
cim(pls.result)

#cca.result<- rcc(t(mags_ab_sorted), t(diet1ab_filtered))
cor_species<-cor(t(mags_ab_sorted))
cor_samples<-cor(diet1ab_filtered)

cim(cor_species)
cim(cor_samples)
#cim(as.matrix(mags_ab_sorted))

#1st group = samples at time 0
diet1_meta$time[diet1_meta$sample %in% c("R127","R101","R90","R19","R49","R105","R10","R96","R109")]

#2nd group= PC compartment after some time (Hfi/SF)
diet1_meta$Compartment[diet1_meta$sample %in% c("R75","R99","R60","R108","R111","R102","R5","R97","R88","R64","R47","R81","R112","R40","R11","R83","R107","R78","R62","R50","R22","R33","R66","R43","R3","R123")]
diet1_meta$Condition[diet1_meta$sample %in% c("R75","R99","R60","R108","R111","R102","R5","R97","R88","R64","R47","R81","R112","R40","R11","R83","R107","R78","R62","R50","R22","R33","R66","R43","R3","R123")]
diet1_meta$time[diet1_meta$sample %in% c("R75","R99","R60","R108","R111","R102","R5","R97","R88","R64","R47","R81","R112","R40","R11","R83","R107","R78","R62","R50","R22","R33","R66","R43","R3","R123")]

# third group regroup HFa (after some time)
diet1_meta$Condition[diet1_meta$sample %in% c("R29","R32","R28","R46","R41","R38",'R89',"R119","R2","R110","R84","R73","R103","R74","R45","R79","R120","R80","R44","R76","R71","R17")]

# fourth group DC compartment after some time (Hfi/SF)
diet1_meta$Condition[diet1_meta$sample %in% c("R87","R121","R118","R106","R67","R125","R124","R98","R113","R1","R25","R129","R37")]
diet1_meta$time[diet1_meta$sample %in% c("R87","R121","R118","R106","R67","R125","R124","R98","R113","R1","R25","R129","R37")]
diet1_meta$Compartment[diet1_meta$sample %in% c("R87","R121","R118","R106","R67","R125","R124","R98","R113","R1","R25","R129","R37")]

#5th group DC (HFi/SF +2 HP) =4th group?
diet1_meta$Condition[diet1_meta$sample %in% c("R126","R48","R4","R91","R20","R15","R31","R65","R26","R70")]
diet1_meta$Compartment[diet1_meta$sample %in% c("R126","R48","R4","R91","R20","R15","R31","R65","R26","R70")]
diet1_meta$time[diet1_meta$sample %in% c("R126","R48","R4","R91","R20","R15","R31","R65","R26","R70")]

#6th group most diverse, HP>>HFa>SF>>>Hfi, bit higher time
diet1_meta$time[diet1_meta$sample %in% c("R104","R93","R115","R114","R77","R61","R117","R63","R14","R27","R16","R42","R128","R116","R36","R21","R68","R18","R69","R94","R12","R86","R35","R34","R30","R13","R82","R72","R39","R92","R85","R24","R23")]
diet1_meta$Compartment[diet1_meta$sample %in% c("R104","R93","R115","R114","R77","R61","R117","R63","R14","R27","R16","R42","R128","R116","R36","R21","R68","R18","R69","R94","R12","R86","R35","R34","R30","R13","R82","R72","R39","R92","R85","R24","R23")]
diet1_meta$Condition[diet1_meta$sample %in% c("R104","R93","R115","R114","R77","R61","R117","R63","R14","R27","R16","R42","R128","R116","R36","R21","R68","R18","R69","R94","R12","R86","R35","R34","R30","R13","R82","R72","R39","R92","R85","R24","R23")]

cor_species_sample<-cor(mags_ab_sorted)
cim(cor_species_sample)

#data_pcor<-t(mags_ab_sorted)[,1:2]
#data_pcor<-cbind(data_pcor,counts=t(diet1ab_filtered)[,1])
#model <-gam(counts, s(lstat), data=data_pcor)

#datacomp<-cbind(counts=t(diet1ab_filtered)[,1],t(mags_ab_sorted))
#contrast<-GenContrastVariables(datacomp)
#MIG.Result <- ComputeMaxInfoGains(contrast$x)
#ComputeInterestingTuples(datacomp, require.all.vars = TRUE)
