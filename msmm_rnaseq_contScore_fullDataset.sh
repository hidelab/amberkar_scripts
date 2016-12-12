#!/bin/bash 
#Job time 
#-l h_rt=96:00:00 
#Request resources 
#-l mem=8G -l rmem=8G 
#Cores 
#$ -pe openmp 12
#Job Name 
#-N MSMM_FDS
module load apps/R/3.3.1
module load compilers/gcc/5.3 
R CMD BATCH --no-save --no-restore /shared/hidelab2/user/md4zsa/Work/Amberkar_Scripts/msmm_rnaseq_contScore_fullDataset.R