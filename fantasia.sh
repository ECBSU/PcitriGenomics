#!/bin/bash
#SBATCH -p compute 
#SBATCH --mem=250G
#SBATCH -c 32 
#SBATCH --time=72:00:00
#SBATCH -n 1
#SBATCH --job-name=fantasia
#SBATCH --output=o_fantasia_easel_unf.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

#------------------------------------#
# Define files 
## Protein list from Braker
# proteins="/flash/HusnikU/Javier/pcit_RNA/MaskGenePred/braker/braker.aa"
# foldername="Pcit_braker_Masked"

## Proteins from Easel
## Filtered longest isoform peptides
# proteins="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/Easel/Pcit_easel_dta_bam_vL/final_predictions/P_citri_filtered_longest_isoform.pep"
# foldername="Pcit_easelFLI"
## Unfiltered peptides
proteins="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/Easel/Pcit_easel_dta_bam_vL/final_predictions/P_citri_unfiltered.pep"
foldername="Pcit_easel_unF"
#------------------------------------#

outdir="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/Fantasia/"${foldername}
mkdir -p ${outdir}
cd ${outdir}

ml purge
ml bioinfo-ugrp-modules
ml DebianMed/12.0
ml singularity
source /home/j/javier-tejeda/.bashrc

echo "Fantasia started"

singularity run /bucket/HusnikU/Conda-envs/fantasia_02152024_sha256.sif --infile ${proteins} \
--outpath ${outdir} \
--prefix Planococcus_citri_Okinawa