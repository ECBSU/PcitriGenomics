#!/bin/bash
#SBATCH -p compute 
#SBATCH --mem=64G
#SBATCH -c 32 
#SBATCH --time=0-4
#SBATCH -n 1
#SBATCH --job-name=radiant
#SBATCH --output=o_radiant_unf.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

#------------------------------------#
# Define files 
## Unfiltered peptides
proteins="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/Easel/Pcit_easel_dta_bam_vL/final_predictions/P_citri_unfiltered.pep"
foldername="Pcit_easel_unF"
#------------------------------------#

outdir="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/ProteinDomains/Radiant_unfilterd"${foldername}
mkdir -p ${outdir}
cd ${outdir}

ml purge
source /home/j/javier-tejeda/.bashrc
mamba activate /bucket/HusnikU/Conda-envs/RADIANT

echo "Radiant started"

radiant -i ${proteins} -d /bucket/HusnikU/Databases/Radiant_Pfam/radiant_db_pfam37 -o Easel_unf_Radiant_annotation.txt