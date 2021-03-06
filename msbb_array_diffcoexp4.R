library(org.Hs.eg.db)
library(dplyr)
library(magrittr)
library(data.table)
library(diffcoexp)


# setwd("/shared/hidelab2/user/md4zsa/Work/Data/MSBB_Array19/GSE84422/")
# 
# msbb_gse84422_series_matrix.GPL96=getGEO(filename = "./GSE84422-GPL96_series_matrix.txt.gz",GSEMatrix = F,AnnotGPL = T)
# msbb_gse84422_series_matrix.GPL97=getGEO(filename = "./GSE84422-GPL97_series_matrix.txt.gz",GSEMatrix = F,AnnotGPL = T)
# 
# #Read feature data and annotation for the GEO objects
# msbb_gse84422.fData=vector(mode = "list",length = 2)
# names(msbb_gse84422.fData)=c("GPL96","GPL97")
# msbb_gse84422.fData$GPL96=fData(msbb_gse84422_series_matrix.GPL96)[,c(1,3:4)]
# msbb_gse84422.fData$GPL97=fData(msbb_gse84422_series_matrix.GPL97)[,c(1,3:4)]
# 
# #Read phenotype data from GEO object
# msbb_gse84422.pData=vector(mode = "list",length = 2)
# names(msbb_gse84422.pData)=c("GPL96","GPL97")
# msbb_gse84422.pData$GPL96=pData(phenoData(msbb_gse84422_series_matrix.GPL96))
# msbb_gse84422.pData$GPL97=pData(phenoData(msbb_gse84422_series_matrix.GPL97))
# 
# msbb_gse84422.pData$GPL96$pseudoSampleID=msbb_gse84422.pData$GPL97$pseudoSampleID=paste("pSample",1:dim(msbb_gse84422.pData$GPL96)[1],sep = "")
# msbb_gse84422.pData=lapply(msbb_gse84422.pData,function(x){x$`brain region:ch1`=gsub(pattern = "^ ",replacement = "",x = x$`brain region:ch1`);x})
# msbb_gse84422.pData=lapply(msbb_gse84422.pData,function(x){x$`clinical dementia rating:ch1`=as.numeric(gsub(pattern = "^ ",replacement = "",x = x$`clinical dementia rating:ch1`));x})
# msbb_gse84422.pData=lapply(msbb_gse84422.pData,function(x){x$`braak neurofibrillary tangle score:ch1`=as.numeric(gsub(pattern = "^ ",replacement = "",x = x$`braak neurofibrillary tangle score:ch1`));x})
# msbb_gse84422.pData=lapply(msbb_gse84422.pData,function(x){x$`average neuritic plaque density:ch1`=as.numeric(gsub(pattern = "^ ",replacement = "",x = x$`average neuritic plaque density:ch1`));x})
# msbb_gse84422.pData=lapply(msbb_gse84422.pData,function(x){x$`neuropathological category:ch1`=gsub(pattern = "^ ",replacement = "",x = x$`neuropathological category:ch1`);x})
# msbb_gse84422.pData=lapply(msbb_gse84422.pData,function(x){x$`SampleTypeCDR`="OTHER";x})
# msbb_gse84422.pData=lapply(msbb_gse84422.pData,function(x){x$SampleTypeCDR[which(x$`clinical dementia rating:ch`==0)]="CDR0";x})
# msbb_gse84422.pData=lapply(msbb_gse84422.pData,function(x){x$SampleTypeCDR[which(x$`clinical dementia rating:ch`==1)]="CDR1";x})
# 
# 
# msbb_gse84422.pData=lapply(msbb_gse84422.pData,function(x){x$SampleType[which(x$SampleTypeCDR=="CDR0"&(x$`neuropathological category:ch1`=='Normal'))]="CONTROL";x})
# msbb_gse84422.pData=lapply(msbb_gse84422.pData,function(x){x$SampleType[which(x$SampleTypeCDR=="CDR1"&(x$`neuropathological category:ch1`!='Normal'))]="AD";x})
# msbb_gse84422_GPL96_97_samples.Control=msbb_gse84422.pData$GPL96$pseudoSampleID[msbb_gse84422.pData$GPL96$SampleType=="CONTROL"]
# msbb_gse84422_GPL96_97_samples.AD=msbb_gse84422.pData$GPL96$pseudoSampleID[msbb_gse84422.pData$GPL96$SampleType=="AD"]
# 
# 
# msbb_gse84422.exprs=vector(mode = "list",length = 2)
# names(msbb_gse84422.exprs)=c("GPL96","GPL97")
# msbb_gse84422.exprs$GPL96=exprs(msbb_gse84422_series_matrix.GPL96)
# msbb_gse84422.exprs$GPL97=exprs(msbb_gse84422_series_matrix.GPL97)
# 
#  
# colnames(msbb_gse84422.exprs$GPL96)=colnames(msbb_gse84422.exprs$GPL97)=msbb_gse84422.pData$GPL96$pseudoSampleID
#  
# msbb_gse84422_exprs.GPL96_97=rbind.data.frame(msbb_gse84422.exprs$GPL96,msbb_gse84422.exprs$GPL97)
# msbb_gse84422_exprs.GPL96_97$GeneSymbol=c(msbb_gse84422.fData$GPL96$`Gene symbol`,msbb_gse84422.fData$GPL97$`Gene symbol`)
# msbb_gse84422_exprs_GPL96_97.agg=aggregate.data.frame(x=msbb_gse84422_exprs.GPL96_97[,-which(colnames(msbb_gse84422_exprs.GPL96_97)=="GeneSymbol")],by=list(symbol=msbb_gse84422_exprs.GPL96_97$GeneSymbol),mean)
# rownames(msbb_gse84422_exprs_GPL96_97.agg)=msbb_gse84422_exprs_GPL96_97.agg$symbol
# msbb_gse84422_exprs_GPL96_97.agg=msbb_gse84422_exprs_GPL96_97.agg[,-which(colnames(msbb_gse84422_exprs_GPL96_97.agg)=="symbol")]
#  
# 
# 
# msbb_gse84422_GPL96_97_samplesToAnalyse=lapply(unique(msbb_gse84422.pData$GPL96$`brain region:ch1`),function(y)msbb_gse84422.pData$GPL96[which(msbb_gse84422.pData$GPL96$`brain region:ch1`==y&(msbb_gse84422.pData$GPL96$SampleType=="CONTROL"|msbb_gse84422.pData$GPL96$SampleType=="AD")),c('SampleType','pseudoSampleID')])
# names(msbb_gse84422_GPL96_97_samplesToAnalyse)=unique(msbb_gse84422.pData$GPL96$`brain region:ch1`)
# names(msbb_gse84422_GPL96_97_samplesToAnalyse)=gsub(pattern = " ",replacement = "_",x = names(msbb_gse84422_GPL96_97_byRegion.exprs))
# select_brain_regions=which(names(msbb_gse84422_GPL96_97_samplesToAnalyse)%in%c("Precentral_Gyrus","Prefrontal_Cortex","Putamen","Caudate_Nucleus","Superior_Parietal_Lobule"))
# msbb_gse84422_GPL96_97_samplesToAnalyse=msbb_gse84422_GPL96_97_samplesToAnalyse[-select_brain_regions]
# msbb_gse84422_GPL96_97_samplesToAnalyse.exprs=lapply(msbb_gse84422_GPL96_97_samplesToAnalyse,function(y)msbb_gse84422_exprs_GPL96_97.agg[-1,colnames(msbb_gse84422_exprs_GPL96_97.agg)%in%y$pseudoSampleID])
# 
# saveRDS(msbb_gse84422_GPL96_97_samplesToAnalyse,"msbb_gse84422_GPL96_97_earlyAD_samplesToAnalyse.RDS")
# saveRDS(msbb_gse84422_GPL96_97_samplesToAnalyse.exprs,"msbb_gse84422_GPL96_97_earlyAD_samplesToAnalyse_exprs.RDS")
setwd("/shared/hidelab2/user/md4zsa/Work/Data/MSBB_Array19/GSE84422/EarlyAD_diffcoexp")

msbb_gse84422_GPL96_97_samplesToAnalyse.exprs=readRDS("msbb_gse84422_GPL96_97_earlyAD_samplesToAnalyse_exprs.RDS")
msbb_gse84422_GPL96_97_samplesToAnalyse=readRDS("msbb_gse84422_GPL96_97_earlyAD_samplesToAnalyse.RDS")

#Diffcoexp analysis
for(i in 1:length(names(msbb_gse84422_GPL96_97_samplesToAnalyse))){
  c_exprs=msbb_gse84422_GPL96_97_samplesToAnalyse.exprs[[i]][,msbb_gse84422_GPL96_97_samplesToAnalyse[[i]]$SampleType=="CONTROL"]
  d_exprs=msbb_gse84422_GPL96_97_samplesToAnalyse.exprs[[i]][,msbb_gse84422_GPL96_97_samplesToAnalyse[[i]]$SampleType=="AD"]
  diffcoexp_out=diffcoexp(exprs.1 = c_exprs,exprs.2 = d_exprs,r.method="spearman",rth=0.6,q.diffth=0.1,q.dcgth=0.1)
  saveRDS(diffcoexp_out,paste(names(msbb_gse84422_GPL96_97_samplesToAnalyse.exprs)[i],"earlyAD_diffcoexp_results.RDS",sep = "_"))
  proc.time()
}
