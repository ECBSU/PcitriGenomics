#!/bin/bash
#SBATCH -p compute 
#SBATCH --mem=75G
#SBATCH -c 32 
#SBATCH --time=72:00:00
#SBATCH -n 1
#SBATCH --job-name=gene_pre
#SBATCH --output=o_genepred_masked.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

outdir="/flash/HusnikU/Javier/pcit_RNA/MaskGenePred"
mkdir -p ${outdir}
cd ${outdir}

#------------------------------------#
# Define files 
## Unmasked genome
Mrg_np2="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/Mrg5C_polished/asm_Mrg.np2.fa"
Mrg_masked="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/Mrg5C_polished/asm_Mrg.np2.fa.masked"
## Trimed reads folder
Reads_p="/flash/HusnikU/Javier/pcit_RNA/assemblies/individual_reads/"
#------------------------------------#
ml purge
ml bioinfo-ugrp-modules
ml DebianMed/12.0
ml singularity
source /home/j/javier-tejeda/.bashrc
braker="/apps/unit/HusnikU/braker3.sif"

echo "Baker started"
singularity exec $braker braker.pl --species=Planoccous_citri --useexisting --genome=${Mrg_masked} \
       --rnaseq_sets_ids=bac1,bac2,bac3,bac4,bac5,body1,body2,body3,body4,body5,gut1,gut2,gut3,gut4,gut5 \
       --rnaseq_sets_dirs=${Reads_p} \
       --threads 32 --crf \
       --busco_lineage hemiptera_odb10 \


