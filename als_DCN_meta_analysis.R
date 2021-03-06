library(DESeq2)
library(org.Hs.eg.db)
library(igraph)
library(clusterProfiler)
library(data.table)

# setwd("/Users/sandeepamberkar/Work/Data/ALS_Claire_Datasets/Meta_Analysis/meta_test")
# diffcorr_results=vector(mode = "list",length = 5)
# names(diffcorr_results)=c("C9orf72","sALS","sALS_Neurons","PRGN","Muscle_VCP")
# diffcorr_results$C9orf72=fread("fcx_c9orf72_allResults_DiffCorr.txt",sep="\t",header=T,stringsAsFactors=F,showProgress=T)
# diffcorr_results$sALS=fread("fcx_sals_allResults_DiffCorr.txt",sep="\t",header=T,stringsAsFactors=F,showProgress=T)
# diffcorr_results$sALS_Neurons=fread("neurons_sals_allResults_DiffCorr.txt",sep="\t",header=T,stringsAsFactors=F,showProgress=T)
# diffcorr_results$PRGN=readRDS("GSE13162_PRGN_vs_Control_corr_change_allResults.RDS")
# diffcorr_results$Muscle_VCP=readRDS("muscle_VCP_vs_Control_corr_change_allResults.RDS")
# 
# ALS_FDR=mclapply(diffcorr_results[1:3],function(x)p.adjust(p=x$p.cocor,method="fdr"),mc.cores = 10)
# ALS_FDR$PRGN=diffcorr_results$PRGN$FDR
# ALS_FDR$Muscle_VCP=diffcorr_results$Muscle_VCP$FDR
# 
# C9orf72_unfiltered$FDR=p.adjust(p=C9orf72_unfiltered$p.cocor,method="fdr")
# C9orf72_unfiltered$FDR.c=p.adjust(p=C9orf72_unfiltered$p.c,method="fdr")
# C9orf72_unfiltered$FDR.t=p.adjust(p=C9orf72_unfiltered$p.t,method="fdr")
# sALS_unfiltered$FDR=p.adjust(p=sALS_unfiltered$p.cocor,method="fdr")
# sALS_unfiltered$FDR.c=p.adjust(p=sALS_unfiltered$p.c,method="fdr")
# sALS_unfiltered$FDR.t=p.adjust(p=sALS_unfiltered$p.t,method="fdr")
# sALS_neurons_unfiltered$FDR=p.adjust(p=sALS_neurons_unfiltered$p.cocor,method="fdr")
# sALS_neurons_unfiltered$FDR.c=p.adjust(p=sALS_neurons_unfiltered$p.c,method="fdr")
# sALS_neurons_unfiltered$FDR.t=p.adjust(p=sALS_neurons_unfiltered$p.t,method="fdr")
# diffcorr_results$C9orf72=C9orf72_unfiltered[which(C9orf72_unfiltered$FDR<=0.15),]
# diffcorr_results$sALS=sALS_unfiltered[which(sALS_unfiltered$FDR<=0.15),]
# diffcorr_results$sALS_Neurons=sALS_neurons_unfiltered[which(sALS_neurons_unfiltered$FDR<=0.1),]
# 
# ALS_DCN=vector(mode="list",length=5)
# names(ALS_DCN)=c("C9orf72","sALS","sALS_Neurons","PRGN","Muscle_VCP")
# ALS_DCN$C9orf72=ALS_DCN$sALS=ALS_DCN$sALS_Neurons=ALS_DCN$PRGN=ALS_DCN$Muscle_VCP=vector(mode = "list",length = 2)
# names(ALS_DCN$C9orf72)=c("Control","C9orf72")
# names(ALS_DCN$sALS)=c("Control","sALS")
# names(ALS_DCN$sALS_Neurons)=c("Control","sALS_Neurons")
# names(ALS_DCN$PRGN)=c("Control","PRGN")
# names(ALS_DCN$Muscle_VCP)=c("Control","Muscle_VCP")
# 
# ALS_DCN$C9orf72$Control=ALS_DCN$C9orf72$C9orf72=graph.data.frame(d=diffcorr_results$C9orf72[ALS_FDR_filtered_indices$C9orf72,c(1:2)],directed=F)
# ALS_DCN$sALS$Control=ALS_DCN$sALS$sALS=graph.data.frame(d=diffcorr_results$sALS[ALS_FDR_filtered_indices$sALS,c(1:2)],directed=F)
# ALS_DCN$sALS_Neurons$Control=ALS_DCN$sALS_Neurons$sALS_Neurons=graph.data.frame(d=diffcorr_results$sALS_Neurons[ALS_FDR_filtered_indices$sALS_Neurons,c(1:2)],directed=F)
# ALS_DCN$PRGN$Control=ALS_DCN$PRGN$PRGN=graph.data.frame(d=diffcorr_results$PRGN[ALS_FDR_filtered_indices$PRGN,c(2:3)],directed=F)
# ALS_DCN$Muscle_VCP$Control=ALS_DCN$Muscle_VCP$Muscle_VCP=graph.data.frame(d=diffcorr_results$Muscle_VCP[ALS_FDR_filtered_indices$Muscle_VCP,c(2:3)],directed=F)
# E(ALS_DCN$C9orf72$Control)$weight=diffcorr_results$C9orf72[ALS_FDR_filtered_indices$C9orf72]$r.c+1
# E(ALS_DCN$C9orf72$C9orf72)$weight=diffcorr_results$C9orf72[ALS_FDR_filtered_indices$C9orf72]$r.t+1
# E(ALS_DCN$sALS$Control)$weight=diffcorr_results$sALS[ALS_FDR_filtered_indices$sALS]$r.c+1
# E(ALS_DCN$sALS$sALS)$weight=diffcorr_results$sALS[ALS_FDR_filtered_indices$sALS]$r.t+1
# E(ALS_DCN$sALS_Neurons$Control)$weight=diffcorr_results$sALS_Neurons[ALS_FDR_filtered_indices$sALS_Neurons]$r.c+1
# E(ALS_DCN$sALS_Neurons$sALS_Neurons)$weight=diffcorr_results$sALS_Neurons[ALS_FDR_filtered_indices$sALS_Neurons]$r.t+1
# E(ALS_DCN$PRGN$Control)$weight=diffcorr_results$PRGN[ALS_FDR_filtered_indices$PRGN]$r.c+1
# E(ALS_DCN$PRGN$PRGN)$weight=diffcorr_results$PRGN[ALS_FDR_filtered_indices$PRGN]$r.t+1
# E(ALS_DCN$Muscle_VCP$Control)$weight=diffcorr_results$Muscle_VCP[ALS_FDR_filtered_indices$Muscle_VCP]$r.c+1
# E(ALS_DCN$Muscle_VCP$Muscle_VCP)$weight=diffcorr_results$Muscle_VCP[ALS_FDR_filtered_indices$Muscle_VCP]$r.t+1

ALS_DCN=readRDS("/Users/sandeepamberkar/Work/Data/ALS_Claire_Datasets/Meta_Analysis/meta_test/ALS_DCN_FDR01.RDS")
load("/Users/sandeepamberkar/Work/Data/ALS_Claire_Datasets/FCX_ALS_C9orf72_sALS/fcx_c9orf72_C9_genecounts_final.RData")
load("/Users/sandeepamberkar/Work/Data/ALS_Claire_Datasets/FCX_ALS_C9orf72_sALS/")
load("/Users/sandeepamberkar/Work/Data/ALS_Claire_Datasets/Neurons_ALS_sALS/Neurons_sALS_genecounts_final.RData")
ALS_DCN.filtered=vector(mode = "list",length = 5)
names(ALS_DCN.filtered)=names(ALS_DCN)
ALS_DCN.filtered$C9orf72=ALS_DCN.filtered$sALS=ALS_DCN.filtered$sALS_Neurons=ALS_DCN.filtered$PRGN=ALS_DCN.filtered$Muscle_VCP=vector(mode = "list",length = 2)
names(ALS_DCN.filtered$C9orf72)=names(ALS_DCN.filtered$sALS)=names(ALS_DCN.filtered$sALS_Neurons)=names(ALS_DCN.filtered$PRGN)=names(ALS_DCN.filtered$Muscle_VCP)=c("PosCoexp","NegCoexp")
ALS_DCN.filtered$C9orf72$PosCoexp=ALS_DCN.filtered$C9orf72$NegCoexp=vector(mode = "list",length = 2)
ALS_DCN.filtered$sALS$PosCoexp=ALS_DCN.filtered$sALS$NegCoexp=vector(mode = "list",length = 2)
ALS_DCN.filtered$sALS_Neurons$PosCoexp=ALS_DCN.filtered$sALS_Neurons$NegCoexp=vector(mode = "list",length = 2)
ALS_DCN.filtered$PRGN$PosCoexp=ALS_DCN.filtered$PRGN$NegCoexp=vector(mode = "list",length = 2)
ALS_DCN.filtered$Muscle_VCP$PosCoexp=ALS_DCN.filtered$Muscle_VCP$NegCoexp=vector(mode = "list",length = 2)
names(ALS_DCN.filtered$C9orf72$PosCoexp)=names(ALS_DCN.filtered$C9orf72$NegCoexp)=c("Control","C9orf72")
names(ALS_DCN.filtered$sALS$PosCoexp)=names(ALS_DCN.filtered$sALS$NegCoexp)=c("Control","sALS")
names(ALS_DCN.filtered$sALS_Neurons$PosCoexp)=names(ALS_DCN.filtered$sALS_Neurons$NegCoexp)=c("Control","sALS_Neurons")
names(ALS_DCN.filtered$PRGN$PosCoexp)=names(ALS_DCN.filtered$PRGN$NegCoexp)=c("Control","PRGN")
names(ALS_DCN.filtered$Muscle_VCP$PosCoexp)=names(ALS_DCN.filtered$Muscle_VCP$NegCoexp)=c("Control","Muscle_VCP")


ALS_DCN.filtered$C9orf72$PosCoexp$Control=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$C9orf72$Control,es = which(E(ALS_DCN$C9orf72$Control)$weight>1.5),names = T)),directed = F)
ALS_DCN.filtered$C9orf72$PosCoexp$C9orf72=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$C9orf72$C9orf72,es = which(E(ALS_DCN$C9orf72$C9orf72)$weight>1.5),names = T)),directed = F)
ALS_DCN.filtered$C9orf72$NegCoexp$Control=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$C9orf72$Control,es = which(E(ALS_DCN$C9orf72$Control)$weight<0.5),names = T)),directed = F)
ALS_DCN.filtered$C9orf72$NegCoexp$C9orf72=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$C9orf72$C9orf72,es = which(E(ALS_DCN$C9orf72$C9orf72)$weight<0.5),names = T)),directed = F)

ALS_DCN.filtered$sALS$PosCoexp$Control=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$sALS$Control,es = which(E(ALS_DCN$sALS$Control)$weight>1.5),names = T)),directed = F)
ALS_DCN.filtered$sALS$PosCoexp$sALS=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$sALS$sALS,es = which(E(ALS_DCN$sALS$sALS)$weight>1.5),names = T)),directed = F)
ALS_DCN.filtered$sALS$NegCoexp$Control=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$sALS$Control,es = which(E(ALS_DCN$sALS$Control)$weight<0.5),names = T)),directed = F)
ALS_DCN.filtered$sALS$NegCoexp$sALS=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$sALS$sALS,es = which(E(ALS_DCN$sALS$sALS)$weight<0.5),names = T)),directed = F)

ALS_DCN.filtered$sALS_Neurons$PosCoexp$Control=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$sALS_Neurons$Control,es = which(E(ALS_DCN$sALS_Neurons$Control)$weight>1.5),names = T)),directed = F)
ALS_DCN.filtered$sALS_Neurons$PosCoexp$sALS_Neurons=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$sALS_Neurons$sALS_Neurons,es = which(E(ALS_DCN$sALS_Neurons$sALS_Neurons)$weight>1.5),names = T)),directed = F)
ALS_DCN.filtered$sALS_Neurons$NegCoexp$Control=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$sALS_Neurons$Control,es = which(E(ALS_DCN$sALS_Neurons$Control)$weight<0.5),names = T)),directed = F)
ALS_DCN.filtered$sALS_Neurons$NegCoexp$sALS_Neurons=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$sALS_Neurons$sALS_Neurons,es = which(E(ALS_DCN$sALS_Neurons$sALS_Neurons)$weight<0.5),names = T)),directed = F)

ALS_DCN.filtered$PRGN$PosCoexp$Control=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$PRGN$Control,es = which(E(ALS_DCN$PRGN$Control)$weight>1.5),names = T)),directed = F)
ALS_DCN.filtered$PRGN$PosCoexp$PRGN=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$PRGN$PRGN,es = which(E(ALS_DCN$PRGN$PRGN)$weight>1.5),names = T)),directed = F)
ALS_DCN.filtered$PRGN$NegCoexp$Control=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$PRGN$Control,es = which(E(ALS_DCN$PRGN$Control)$weight<0.5),names = T)),directed = F)
ALS_DCN.filtered$PRGN$NegCoexp$PRGN=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$PRGN$PRGN,es = which(E(ALS_DCN$PRGN$PRGN)$weight<0.5),names = T)),directed = F)

ALS_DCN.filtered$Muscle_VCP$PosCoexp$Control=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$Muscle_VCP$Control,es = which(E(ALS_DCN$Muscle_VCP$Control)$weight>1.5),names = T)),directed = F)
ALS_DCN.filtered$Muscle_VCP$PosCoexp$Muscle_VCP=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$Muscle_VCP$Muscle_VCP,es = which(E(ALS_DCN$Muscle_VCP$Muscle_VCP)$weight>1.5),names = T)),directed = F)
ALS_DCN.filtered$Muscle_VCP$NegCoexp$Control=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$Muscle_VCP$Control,es = which(E(ALS_DCN$Muscle_VCP$Control)$weight<0.5),names = T)),directed = F)
ALS_DCN.filtered$Muscle_VCP$NegCoexp$Muscle_VCP=graph.data.frame(d=data.frame(ends(graph = ALS_DCN$Muscle_VCP$Muscle_VCP,es = which(E(ALS_DCN$Muscle_VCP$Muscle_VCP)$weight<0.5),names = T)),directed = F)


ALS_DCN.rewired=vector(mode = "list",length = 5)
names(ALS_DCN.rewired)=names(ALS_DCN)
ALS_DCN.rewired$C9orf72=ALS_DCN.rewired$sALS=ALS_DCN.rewired$sALS_Neurons=ALS_DCN.rewired$PRGN=ALS_DCN.rewired$Muscle_VCP=vector(mode = "list",length = 2)
names(ALS_DCN.rewired$C9orf72)=names(ALS_DCN.rewired$sALS)=names(ALS_DCN.rewired$sALS_Neurons)=names(ALS_DCN.rewired$PRGN)=names(ALS_DCN.rewired$Muscle_VCP)=c("PosCoexp_Rewired_DF","NegCoexp_Rewired_DF")
ALS_DCN.rewired$C9orf72$PosCoexp_Rewired_DF=data.frame(Common_Genes=intersect(V(ALS_DCN.filtered$C9orf72$PosCoexp$Control)$name,V(ALS_DCN.filtered$C9orf72$PosCoexp$C9orf72)$name),
                                   Control=degree(graph = ALS_DCN.filtered$C9orf72$PosCoexp$Control,v = intersect(V(ALS_DCN.filtered$C9orf72$PosCoexp$Control)$name,V(ALS_DCN.filtered$C9orf72$PosCoexp$C9orf72)$name)),
                                   C9orf72=degree(graph = ALS_DCN.filtered$C9orf72$PosCoexp$C9orf72,v = intersect(V(ALS_DCN.filtered$C9orf72$PosCoexp$Control)$name,V(ALS_DCN.filtered$C9orf72$PosCoexp$C9orf72)$name)),
                                   Difference=degree(graph = ALS_DCN.filtered$C9orf72$PosCoexp$Control,v = intersect(V(ALS_DCN.filtered$C9orf72$PosCoexp$Control)$name,V(ALS_DCN.filtered$C9orf72$PosCoexp$C9orf72)$name))-degree(graph = ALS_DCN.filtered$C9orf72$PosCoexp$C9orf72,v = intersect(V(ALS_DCN.filtered$C9orf72$PosCoexp$Control)$name,V(ALS_DCN.filtered$C9orf72$PosCoexp$C9orf72)$name)),stringsAsFactors = F)
ALS_DCN.rewired$sALS$PosCoexp_Rewired_DF=data.frame(Common_Genes=intersect(V(ALS_DCN.filtered$sALS$PosCoexp$Control)$name,V(ALS_DCN.filtered$sALS$PosCoexp$sALS)$name),
                                Control=degree(graph = ALS_DCN.filtered$sALS$PosCoexp$Control,v = intersect(V(ALS_DCN.filtered$sALS$PosCoexp$Control)$name,V(ALS_DCN.filtered$sALS$PosCoexp$sALS)$name)),
                                sALS=degree(graph = ALS_DCN.filtered$sALS$PosCoexp$sALS,v = intersect(V(ALS_DCN.filtered$sALS$PosCoexp$Control)$name,V(ALS_DCN.filtered$sALS$PosCoexp$sALS)$name)),
                                Difference=degree(graph = ALS_DCN.filtered$sALS$PosCoexp$Control,v = intersect(V(ALS_DCN.filtered$sALS$PosCoexp$Control)$name,V(ALS_DCN.filtered$sALS$PosCoexp$sALS)$name))-degree(graph = ALS_DCN.filtered$sALS$PosCoexp$sALS,v = intersect(V(ALS_DCN.filtered$sALS$PosCoexp$Control)$name,V(ALS_DCN.filtered$sALS$PosCoexp$sALS)$name)),stringsAsFactors = F)
ALS_DCN.rewired$sALS_Neurons$PosCoexp_Rewired_DF=data.frame(Common_Genes=intersect(V(ALS_DCN.filtered$sALS_Neurons$PosCoexp$Control)$name,V(ALS_DCN.filtered$sALS_Neurons$PosCoexp$sALS_Neurons)$name),
                                        Control=degree(graph = ALS_DCN.filtered$sALS_Neurons$PosCoexp$Control,v = intersect(V(ALS_DCN.filtered$sALS_Neurons$PosCoexp$Control)$name,V(ALS_DCN.filtered$sALS_Neurons$PosCoexp$sALS_Neurons)$name)),
                                        sALS_Neurons=degree(graph = ALS_DCN.filtered$sALS_Neurons$PosCoexp$sALS_Neurons,v = intersect(V(ALS_DCN.filtered$sALS_Neurons$PosCoexp$Control)$name,V(ALS_DCN.filtered$sALS_Neurons$PosCoexp$sALS_Neurons)$name)),
                                        Difference=degree(graph = ALS_DCN.filtered$sALS_Neurons$PosCoexp$Control,v = intersect(V(ALS_DCN.filtered$sALS_Neurons$PosCoexp$Control)$name,V(ALS_DCN.filtered$sALS_Neurons$PosCoexp$sALS_Neurons)$name))-degree(graph = ALS_DCN.filtered$sALS_Neurons$PosCoexp$sALS_Neurons,v = intersect(V(ALS_DCN.filtered$sALS_Neurons$PosCoexp$Control)$name,V(ALS_DCN.filtered$sALS_Neurons$PosCoexp$sALS_Neurons)$name)),stringsAsFactors = F)
ALS_DCN.rewired$PRGN$PosCoexp_Rewired_DF=data.frame(Common_Genes=intersect(V(ALS_DCN.filtered$PRGN$PosCoexp$Control)$name,V(ALS_DCN.filtered$PRGN$PosCoexp$PRGN)$name),
                                                    Control=degree(graph = ALS_DCN.filtered$PRGN$PosCoexp$Control,v = intersect(V(ALS_DCN.filtered$PRGN$PosCoexp$Control)$name,V(ALS_DCN.filtered$PRGN$PosCoexp$PRGN)$name)),
                                                    PRGN=degree(graph = ALS_DCN.filtered$PRGN$PosCoexp$PRGN,v = intersect(V(ALS_DCN.filtered$PRGN$PosCoexp$Control)$name,V(ALS_DCN.filtered$PRGN$PosCoexp$PRGN)$name)),
                                                    Difference=degree(graph = ALS_DCN.filtered$PRGN$PosCoexp$Control,v = intersect(V(ALS_DCN.filtered$PRGN$PosCoexp$Control)$name,V(ALS_DCN.filtered$PRGN$PosCoexp$PRGN)$name))-degree(graph = ALS_DCN.filtered$PRGN$PosCoexp$PRGN,v = intersect(V(ALS_DCN.filtered$PRGN$PosCoexp$Control)$name,V(ALS_DCN.filtered$PRGN$PosCoexp$PRGN)$name)),stringsAsFactors = F)
ALS_DCN.rewired$Muscle_VCP$PosCoexp_Rewired_DF=data.frame(Common_Genes=intersect(V(ALS_DCN.filtered$Muscle_VCP$PosCoexp$Control)$name,V(ALS_DCN.filtered$Muscle_VCP$PosCoexp$Muscle_VCP)$name),
                                                          Control=degree(graph = ALS_DCN.filtered$Muscle_VCP$PosCoexp$Control,v = intersect(V(ALS_DCN.filtered$Muscle_VCP$PosCoexp$Control)$name,V(ALS_DCN.filtered$Muscle_VCP$PosCoexp$Muscle_VCP)$name)),
                                                          Muscle_VCP=degree(graph = ALS_DCN.filtered$Muscle_VCP$PosCoexp$Muscle_VCP,v = intersect(V(ALS_DCN.filtered$Muscle_VCP$PosCoexp$Control)$name,V(ALS_DCN.filtered$Muscle_VCP$PosCoexp$Muscle_VCP)$name)),
                                                          Difference=degree(graph = ALS_DCN.filtered$Muscle_VCP$PosCoexp$Control,v = intersect(V(ALS_DCN.filtered$Muscle_VCP$PosCoexp$Control)$name,V(ALS_DCN.filtered$Muscle_VCP$PosCoexp$Muscle_VCP)$name))-degree(graph = ALS_DCN.filtered$Muscle_VCP$PosCoexp$Muscle_VCP,v = intersect(V(ALS_DCN.filtered$Muscle_VCP$PosCoexp$Control)$name,V(ALS_DCN.filtered$Muscle_VCP$PosCoexp$Muscle_VCP)$name)),stringsAsFactors = F)

ALS_DCN.rewired$C9orf72$NegCoexp_Rewired_DF=data.frame(Common_Genes=intersect(V(ALS_DCN.filtered$C9orf72$NegCoexp$Control)$name,V(ALS_DCN.filtered$C9orf72$NegCoexp$C9orf72)$name),
                                                       Control=degree(graph = ALS_DCN.filtered$C9orf72$NegCoexp$Control,v = intersect(V(ALS_DCN.filtered$C9orf72$NegCoexp$Control)$name,V(ALS_DCN.filtered$C9orf72$NegCoexp$C9orf72)$name)),
                                                       C9orf72=degree(graph = ALS_DCN.filtered$C9orf72$NegCoexp$C9orf72,v = intersect(V(ALS_DCN.filtered$C9orf72$NegCoexp$Control)$name,V(ALS_DCN.filtered$C9orf72$NegCoexp$C9orf72)$name)),
                                                       Difference=degree(graph = ALS_DCN.filtered$C9orf72$NegCoexp$Control,v = intersect(V(ALS_DCN.filtered$C9orf72$NegCoexp$Control)$name,V(ALS_DCN.filtered$C9orf72$NegCoexp$C9orf72)$name))-degree(graph = ALS_DCN.filtered$C9orf72$NegCoexp$C9orf72,v = intersect(V(ALS_DCN.filtered$C9orf72$NegCoexp$Control)$name,V(ALS_DCN.filtered$C9orf72$NegCoexp$C9orf72)$name)),stringsAsFactors = F)
ALS_DCN.rewired$sALS$NegCoexp_Rewired_DF=data.frame(Common_Genes=intersect(V(ALS_DCN.filtered$sALS$NegCoexp$Control)$name,V(ALS_DCN.filtered$sALS$NegCoexp$sALS)$name),
                                                    Control=degree(graph = ALS_DCN.filtered$sALS$NegCoexp$Control,v = intersect(V(ALS_DCN.filtered$sALS$NegCoexp$Control)$name,V(ALS_DCN.filtered$sALS$NegCoexp$sALS)$name)),
                                                    sALS=degree(graph = ALS_DCN.filtered$sALS$NegCoexp$sALS,v = intersect(V(ALS_DCN.filtered$sALS$NegCoexp$Control)$name,V(ALS_DCN.filtered$sALS$NegCoexp$sALS)$name)),
                                                    Difference=degree(graph = ALS_DCN.filtered$sALS$NegCoexp$Control,v = intersect(V(ALS_DCN.filtered$sALS$NegCoexp$Control)$name,V(ALS_DCN.filtered$sALS$NegCoexp$sALS)$name))-degree(graph = ALS_DCN.filtered$sALS$NegCoexp$sALS,v = intersect(V(ALS_DCN.filtered$sALS$NegCoexp$Control)$name,V(ALS_DCN.filtered$sALS$NegCoexp$sALS)$name)),stringsAsFactors = F)
ALS_DCN.rewired$sALS_Neurons$NegCoexp_Rewired_DF=data.frame(Common_Genes=intersect(V(ALS_DCN.filtered$sALS_Neurons$NegCoexp$Control)$name,V(ALS_DCN.filtered$sALS_Neurons$NegCoexp$sALS_Neurons)$name),
                                                            Control=degree(graph = ALS_DCN.filtered$sALS_Neurons$NegCoexp$Control,v = intersect(V(ALS_DCN.filtered$sALS_Neurons$NegCoexp$Control)$name,V(ALS_DCN.filtered$sALS_Neurons$NegCoexp$sALS_Neurons)$name)),
                                                            sALS_Neurons=degree(graph = ALS_DCN.filtered$sALS_Neurons$NegCoexp$sALS_Neurons,v = intersect(V(ALS_DCN.filtered$sALS_Neurons$NegCoexp$Control)$name,V(ALS_DCN.filtered$sALS_Neurons$NegCoexp$sALS_Neurons)$name)),
                                                            Difference=degree(graph = ALS_DCN.filtered$sALS_Neurons$NegCoexp$Control,v = intersect(V(ALS_DCN.filtered$sALS_Neurons$NegCoexp$Control)$name,V(ALS_DCN.filtered$sALS_Neurons$NegCoexp$sALS_Neurons)$name))-degree(graph = ALS_DCN.filtered$sALS_Neurons$NegCoexp$sALS_Neurons,v = intersect(V(ALS_DCN.filtered$sALS_Neurons$NegCoexp$Control)$name,V(ALS_DCN.filtered$sALS_Neurons$NegCoexp$sALS_Neurons)$name)),stringsAsFactors = F)
ALS_DCN.rewired$PRGN$NegCoexp_Rewired_DF=data.frame(Common_Genes=intersect(V(ALS_DCN.filtered$PRGN$NegCoexp$Control)$name,V(ALS_DCN.filtered$PRGN$NegCoexp$PRGN)$name),
                                                    Control=degree(graph = ALS_DCN.filtered$PRGN$NegCoexp$Control,v = intersect(V(ALS_DCN.filtered$PRGN$NegCoexp$Control)$name,V(ALS_DCN.filtered$PRGN$NegCoexp$PRGN)$name)),
                                                    PRGN=degree(graph = ALS_DCN.filtered$PRGN$NegCoexp$PRGN,v = intersect(V(ALS_DCN.filtered$PRGN$NegCoexp$Control)$name,V(ALS_DCN.filtered$PRGN$NegCoexp$PRGN)$name)),
                                                    Difference=degree(graph = ALS_DCN.filtered$PRGN$NegCoexp$Control,v = intersect(V(ALS_DCN.filtered$PRGN$NegCoexp$Control)$name,V(ALS_DCN.filtered$PRGN$NegCoexp$PRGN)$name))-degree(graph = ALS_DCN.filtered$PRGN$NegCoexp$PRGN,v = intersect(V(ALS_DCN.filtered$PRGN$NegCoexp$Control)$name,V(ALS_DCN.filtered$PRGN$NegCoexp$PRGN)$name)),stringsAsFactors = F)

ALS_DCN.rewired$Muscle_VCP$NegCoexp_Rewired_DF=data.frame(Common_Genes=intersect(V(ALS_DCN.filtered$Muscle_VCP$NegCoexp$Control)$name,V(ALS_DCN.filtered$Muscle_VCP$NegCoexp$Muscle_VCP)$name),
                                                          Control=degree(graph = ALS_DCN.filtered$Muscle_VCP$NegCoexp$Control,v = intersect(V(ALS_DCN.filtered$Muscle_VCP$NegCoexp$Control)$name,V(ALS_DCN.filtered$Muscle_VCP$NegCoexp$Muscle_VCP)$name)),
                                                          Muscle_VCP=degree(graph = ALS_DCN.filtered$Muscle_VCP$NegCoexp$Muscle_VCP,v = intersect(V(ALS_DCN.filtered$Muscle_VCP$NegCoexp$Control)$name,V(ALS_DCN.filtered$Muscle_VCP$NegCoexp$Muscle_VCP)$name)),
                                                          Difference=degree(graph = ALS_DCN.filtered$Muscle_VCP$NegCoexp$Control,v = intersect(V(ALS_DCN.filtered$Muscle_VCP$NegCoexp$Control)$name,V(ALS_DCN.filtered$Muscle_VCP$NegCoexp$Muscle_VCP)$name))-degree(graph = ALS_DCN.filtered$Muscle_VCP$NegCoexp$Muscle_VCP,v = intersect(V(ALS_DCN.filtered$Muscle_VCP$NegCoexp$Control)$name,V(ALS_DCN.filtered$Muscle_VCP$NegCoexp$Muscle_VCP)$name)),stringsAsFactors = F)



ALS_DCN.rewired_cluster=vector(mode = "list",length = 5)
names(ALS_DCN.rewired_cluster)=names(ALS_DCN)
ALS_DCN.rewired_cluster$C9orf72=ALS_DCN.rewired_cluster$sALS=ALS_DCN.rewired_cluster$sALS_Neurons=ALS_DCN.rewired_cluster$PRGN=ALS_DCN.rewired_cluster$Muscle_VCP=vector(mode = "list",length = 4)
names(ALS_DCN.rewired_cluster$C9orf72)=names(ALS_DCN.rewired_cluster$sALS)=names(ALS_DCN.rewired_cluster$sALS_Neurons)=names(ALS_DCN.rewired_cluster$PRGN)=names(ALS_DCN.rewired_cluster$Muscle_VCP)=c("PosCoexp_Gain","PosCoexp_Loss","NegCoexp_Gain","NegCoexp_Loss")
ALS_DCN.rewired_cluster$C9orf72$PosCoexp_Gain=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$C9orf72$PosCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$C9orf72$PosCoexp_Rewired_DF$Difference<0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]
ALS_DCN.rewired_cluster$C9orf72$PosCoexp_Loss=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$C9orf72$PosCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$C9orf72$PosCoexp_Rewired_DF$Difference>0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]

ALS_DCN.rewired_cluster$sALS$PosCoexp_Gain=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$sALS$PosCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$sALS$PosCoexp_Rewired_DF$Difference<0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]
ALS_DCN.rewired_cluster$sALS$PosCoexp_Loss=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$sALS$PosCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$sALS$PosCoexp_Rewired_DF$Difference>0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]

ALS_DCN.rewired_cluster$sALS_Neurons$PosCoexp_Gain=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$sALS_Neurons$PosCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$sALS_Neurons$PosCoexp_Rewired_DF$Difference<0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]
ALS_DCN.rewired_cluster$sALS_Neurons$PosCoexp_Loss=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$sALS_Neurons$PosCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$sALS_Neurons$PosCoexp_Rewired_DF$Difference>0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]

ALS_DCN.rewired_cluster$PRGN$PosCoexp_Gain=ALS_DCN.rewired$PRGN$PosCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$PRGN$PosCoexp_Rewired_DF$Difference<0)]
ALS_DCN.rewired_cluster$PRGN$PosCoexp_Loss=ALS_DCN.rewired$PRGN$PosCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$PRGN$PosCoexp_Rewired_DF$Difference>0)]

ALS_DCN.rewired_cluster$Muscle_VCP$PosCoexp_Gain=ALS_DCN.rewired$Muscle_VCP$PosCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$Muscle_VCP$PosCoexp_Rewired_DF$Difference<0)]
ALS_DCN.rewired_cluster$Muscle_VCP$PosCoexp_Loss=ALS_DCN.rewired$Muscle_VCP$PosCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$Muscle_VCP$PosCoexp_Rewired_DF$Difference>0)]

ALS_DCN.rewired_cluster$C9orf72$NegCoexp_Gain=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$C9orf72$NegCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$C9orf72$NegCoexp_Rewired_DF$Difference<0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]
ALS_DCN.rewired_cluster$C9orf72$NegCoexp_Loss=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$C9orf72$NegCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$C9orf72$NegCoexp_Rewired_DF$Difference>0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]

ALS_DCN.rewired_cluster$sALS$NegCoexp_Gain=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$sALS$NegCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$sALS$NegCoexp_Rewired_DF$Difference<0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]
ALS_DCN.rewired_cluster$sALS$NegCoexp_Loss=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$sALS$NegCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$sALS$NegCoexp_Rewired_DF$Difference>0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]

ALS_DCN.rewired_cluster$sALS_Neurons$NegCoexp_Gain=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$sALS_Neurons$NegCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$sALS_Neurons$NegCoexp_Rewired_DF$Difference<0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]
ALS_DCN.rewired_cluster$sALS_Neurons$NegCoexp_Loss=select(x = org.Hs.eg.db,keys = ALS_DCN.rewired$sALS_Neurons$NegCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$sALS_Neurons$NegCoexp_Rewired_DF$Difference>0)],columns = "ENTREZID",keytype = "SYMBOL")[,2]

ALS_DCN.rewired_cluster$PRGN$NegCoexp_Gain=ALS_DCN.rewired$PRGN$NegCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$PRGN$NegCoexp_Rewired_DF$Difference<0)]
ALS_DCN.rewired_cluster$PRGN$NegCoexp_Loss=ALS_DCN.rewired$PRGN$NegCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$PRGN$NegCoexp_Rewired_DF$Difference>0)]

ALS_DCN.rewired_cluster$Muscle_VCP$NegCoexp_Gain=ALS_DCN.rewired$Muscle_VCP$NegCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$Muscle_VCP$NegCoexp_Rewired_DF$Difference<0)]
ALS_DCN.rewired_cluster$Muscle_VCP$NegCoexp_Loss=ALS_DCN.rewired$Muscle_VCP$NegCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$Muscle_VCP$NegCoexp_Rewired_DF$Difference>0)]

ALS_DCN.genes=lapply(lapply(lapply(ALS_DCN,`[[`,1),`[`,1),function(x)names(x))
ALS_DCN.genes[1:3]=lapply(lapply(ALS_DCN.genes[1:3],select,x=org.Hs.eg.db,columns = "ENTREZID",keytype = "SYMBOL"),`[[`,2)

metaALS.DEG=scan("meta_test/Meta-TDP-43-DEGs.txt",sep = "\n",what = "char")
metaALS_DEG_DCN=list(metaDEG=metaALS.DEG,C9orf72_DCN=V(ALS_DCN$C9orf72$C9orf72)$name,PRGN_DCN=V(ALS_DCN$PRGN$PRGN)$name,VCP_DCN=V(ALS_DCN$Muscle_VCP$Muscle_VCP)$name)
metaALS_DEG_DCN[c(1:2)]=lapply(lapply(metaALS_DEG_DCN[c(1:2)],select,x=org.Hs.eg.db,columns = "ENTREZID",keytype = "SYMBOL"),`[[`,2)
metaALS_DEG_DCN
# names(metaALS.DEG)=c("C9orf72","sALS_Neurons")
# metaALS.DEG[[1]]=results(fcx_c9orf72_als_gene_counts.dds,pAdjustMethod = "BH",tidy = T)
# metaALS.DEG[[2]]=results(neurons_sals_gene_counts.dds,pAdjustMethod = "BH",tidy = T)
# metaALS.DEG=lapply(metaALS.DEG,function(x)x[which(x$padj<=0.05&x$log2FoldChange>=1),])


#DEG vs DCN
# sALS_DEG_DCN.CommonGenes=intersect(select(x = org.Hs.eg.db,keys = ALS_DCN.genes$sALS_Neurons,columns = "SYMBOL",keytype = "ENTREZID")[,2],select(x = org.Hs.eg.db,keys = metaALS.DEG$sALS_Neurons$row,columns = "SYMBOL",keytype = "ENSEMBL")[,2])
# sALS_DEG_DCN.Subnet=induced_subgraph(graph = ALS_DCN$sALS_Neurons$sALS_Neurons,vids = which(V(ALS_DCN$sALS_Neurons$sALS_Neurons)$name%in%sALS.DEG_GenesSymbol))
# 
# sALS_DCN_Degree=data.frame(Genes=V(ALS_DCN$sALS_Neurons$sALS_Neurons)$name[which(V(ALS_DCN$sALS_Neurons$sALS_Neurons)$name%in%sALS_DEG_DCN.CommonGenes)],Degree=degree(graph = ALS_DCN$sALS_Neurons$sALS_Neurons,v = which(V(ALS_DCN$sALS_Neurons$sALS_Neurons)$name%in%sALS_DEG_DCN.CommonGenes)))
# sALS_DEG_Degree=data.frame(Genes=V(sALS_DEG_DCN.Subnet)$name[which(V(sALS_DEG_DCN.Subnet)$name%in%sALS_DEG_DCN.CommonGenes)],Degree=degree(graph = sALS_DEG_DCN.Subnet,v = which(V(sALS_DEG_DCN.Subnet)$name%in%sALS_DEG_DCN.CommonGenes)))
# sALS_Comparison.Degree=rbind(sALS_DEG_Degree,sALS_DCN_Degree)
# 
# sALS_Comparison.Genes=vector(mode = "list",length = 2)
# names(sALS_Comparison.Genes)=c("DEG","DCN")
# sALS_Comparison.Genes$DEG=metaALS.DEG_Genes$sALS_Neurons
# sALS_Comparison.Genes$DCN=ALS_DCN.genes$sALS_Neurons
# 
# sALS_DEG_DCN_Overlap.random=list()
# human_genes=toTable(org.Hs.egSYMBOL)[,2]
# sALS.DEG_GenesSymbol=na.omit(select(x = org.Hs.eg.db,keys = metaALS.DEG$sALS_Neurons$row,keytype  = "ENSEMBL",columns = "SYMBOL")[,2])[1:970]
# for (i in 1:10000){
#   
#   sALS_Neurons_DCN_random=sample(x = human_genes,size = 16580,replace = F)
#   sALS_Neurons_DEG_random=sample(x = human_genes,size = length(sALS.DEG_GenesSymbol),replace = F)
#   sALS_DEG_DCN_Overlap.random[[i]]=length(intersect(sALS_Neurons_DEG_random,sALS_Neurons_DCN_random))
# }
# hist(unlist(sALS_DEG_DCN_Overlap.random),xlab = "#Overlaps",main="sALS DEG,DCN Overlap distribution",col="blue4",xlim = c(200,1000))
# abline(v=length(intersect(metaALS.DEG_GenesSymbol,V(ALS_DCN$sALS_Neurons$sALS_Neurons)$name)),col="red4",lwd=3)
# text(x = 880,y=0,paste("p=2.22e-16"),col="black",adj=c(-.1,-.1))
# 
# sALS_Comparison.KEGG=compareCluster(geneClusters = sALS_Comparison.Genes,fun = "enrichKEGG",pvalueCutoff=0.05)@compareClusterResult
# sALS_Comparison=vector(mode = "list",length = 3)
# names(sALS_Comparison)=c("sALS_DEG_only","sALS_DCN_only","sALS_DCN_DEG")
# sALS_Comparison$sALS_DEG_only=select(x = org.Hs.eg.db,keys = sALS.DEG_GenesSymbol[-which(sALS.DEG_GenesSymbol%in%V(ALS_DCN$sALS_Neurons$sALS_Neurons)$name)],columns = "ENTREZID",keytype = "SYMBOL")[,2]
# sALS_Comparison$sALS_DCN_only=select(x = org.Hs.eg.db,keys = V(ALS_DCN$sALS_Neurons$sALS_Neurons)$name[-which(V(ALS_DCN$sALS_Neurons$sALS_Neurons)$name%in%sALS.DEG_GenesSymbol)],columns = "ENTREZID",keytype = "SYMBOL")[,2]
# sALS_Comparison$sALS_DCN_DEG=select(x = org.Hs.eg.db,keys = sALS_DEG_DCN.CommonGenes,columns = "ENTREZID",keytype = "SYMBOL")[,2]
# 
# sALS_Neurons_PosCoexp_RewiredGenes_DF.Endocytosis=ALS_DCN.rewired$sALS_Neurons$PosCoexp_Rewired_DF[which(ALS_DCN.rewired$sALS_Neurons$PosCoexp_Rewired_DF$Common_Genes%in%select(x = org.Hs.eg.db,keys = unlist(strsplit(x = sALS_Comparison.KEGG[which(sALS_Comparison.KEGG$Description=="Endocytosis"),9],split = "/")),keytype = "ENTREZID",columns = "SYMBOL")[,2]),]
# sALS_Neurons_PosCoexp_RewiredGenes_DF.AxonGuidance=ALS_DCN.rewired$sALS_Neurons$PosCoexp_Rewired_DF[which(ALS_DCN.rewired$sALS_Neurons$PosCoexp_Rewired_DF$Common_Genes%in%select(x = org.Hs.eg.db,keys = unlist(strsplit(x = sALS_Comparison.KEGG[which(sALS_Comparison.KEGG$Description=="Axon guidance"),9],split = "/")),keytype = "ENTREZID",columns = "SYMBOL")[,2]),]
# sALS_Neurons_NegCoexp_RewiredGenes_DF.Endocytosis=ALS_DCN.rewired$sALS_Neurons$NegCoexp_Rewired_DF[which(ALS_DCN.rewired$sALS_Neurons$NegCoexp_Rewired_DF$Common_Genes%in%select(x = org.Hs.eg.db,keys = unlist(strsplit(x = sALS_Comparison.KEGG[which(sALS_Comparison.KEGG$Description=="Endocytosis"),9],split = "/")),keytype = "ENTREZID",columns = "SYMBOL")[,2]),]
# sALS_Neurons_NegCoexp_RewiredGenes_DF.AxonGuidance=ALS_DCN.rewired$sALS_Neurons$NegCoexp_Rewired_DF[which(ALS_DCN.rewired$sALS_Neurons$NegCoexp_Rewired_DF$Common_Genes%in%select(x = org.Hs.eg.db,keys = unlist(strsplit(x = sALS_Comparison.KEGG[which(sALS_Comparison.KEGG$Description=="Axon guidance"),9],split = "/")),keytype = "ENTREZID",columns = "SYMBOL")[,2]),]
# sALS_Neurons_PosCoexp_RewiredGenes.Endocytosis=ALS_DCN.rewired$sALS_Neurons$PosCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$sALS_Neurons$PosCoexp_Rewired_DF$Common_Genes%in%select(x = org.Hs.eg.db,keys = unlist(strsplit(x = sALS_Comparison.KEGG[which(sALS_Comparison.KEGG$Description=="Endocytosis"),9],split = "/")),keytype = "ENTREZID",columns = "SYMBOL")[,2]),1]
# sALS_Neurons_NegCoexp_RewiredGenes.Endocytosis=ALS_DCN.rewired$sALS_Neurons$NegCoexp_Rewired_DF$Common_Genes[which(ALS_DCN.rewired$sALS_Neurons$NegCoexp_Rewired_DF$Common_Genes%in%select(x = org.Hs.eg.db,keys = unlist(strsplit(x = sALS_Comparison.KEGG[which(sALS_Comparison.KEGG$Description=="Endocytosis"),9],split = "/")),keytype = "ENTREZID",columns = "SYMBOL")[,2]),1]
# C9orf72_unfiltered=read.table("fcx_c9orf72_allResults_DiffCorr.txt",sep="\t",header = T,as.is = T)
# sALS_unfiltered=read.table("sals_allResults_DiffCorr.txt",sep="\t",header = T,as.is = T)
# sALS_neurons_unfiltered=read.table("neurons_sals_allResults_DiffCorr.txt",sep="\t",header = T,as.is = T)