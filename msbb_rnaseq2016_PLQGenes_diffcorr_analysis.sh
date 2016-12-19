#!/bin/bash 
#Job time 
#$-l h_rt=120:00:00 
#Request resources 
#$-l mem=8G -l rmem=8G 
#Cores 
#$ -pe openmp 8
#Job Name 
#$-N MSBB_PLQ_DiffCorr
module load apps/R/3.3.1
module load compilers/gcc/5.3 
R CMD BATCH --no-save --no-restore /shared/hidelab2/user/md4zsa/Work/Amberkar_Scripts/msbb_rnaseq2016_PLQGenes_diffcorr_analysis.R