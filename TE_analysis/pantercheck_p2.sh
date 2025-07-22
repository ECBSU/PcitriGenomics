#!/bin/bash
#SBATCH -p compute
#SBATCH --output=panter-part2.out
#SBATCH -t 0-4
#SBATCH --mem=8G
#SBATCH -c 32

ml purge
ml bioinfo-ugrp-modules DebianMed/12.0 nf-core R/4.3.1 
# Paths to mafft and BLAST
export PATH="/apps/unit/HusnikU/mafft/bin:$PATH"
export PATH="/apps/unit/HusnikU/ncbi-blast-2.11.0+/bin:$PATH"

# Run the R script
Rscript /apps/unit/HusnikU/pantera/pantera.R -g gfas_list -c 32 -o ChromosomeLibs/
