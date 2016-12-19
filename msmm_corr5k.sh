#!/bin/bash
#Job time
#-l h_rt=08:00:00
#Request resources
#-l mem=64G -l rmem=32G
#Queue
#$ -P hidelab
#Job Name
#-N msmm_contScore_cocor
#Cores
#$ -pe openmp 16

module load apps/bin/R/3.2.0
module load compilers/gcc/5.3

R CMD BATCH --no-save --no-restore msmm_corr5k.R