#!/bin/bash
#SBATCH -p compute
#SBATCH --output=panter-part4.out
#SBATCH -t 4-0
#SBATCH --mem=64G
#SBATCH -c 86

ml purge
ml bioinfo-ugrp-modules DebianMed/12.0 nf-core R/4.3.1 
# Paths to mafft and BLAST
export PATH="/apps/unit/HusnikU/mafft/bin:$PATH"
export PATH="/apps/unit/HusnikU/ncbi-blast-2.11.0+/bin:$PATH"

#3a- (Optional) Identify structural features in the sequences
# Run the R script
Rscript /apps/unit/HusnikU/pantera/F_pantercheck.R /flash/HusnikU/Javier/Ref_Genome/PanterComparison/ChromosomeLibs/Classified/pantera_lib_0.fa.classified




