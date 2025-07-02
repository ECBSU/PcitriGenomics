#!/bin/bash
#SBATCH -p compute 
#SBATCH --mem=8G
#SBATCH -c 6 
#SBATCH --time=72:00:00
#SBATCH -n 1
#SBATCH --job-name=fantasia
#SBATCH --output=o_gapseq.log

#------------------------------------#
# Define files 
# Proteins with the sequences from Pcitri Moranella and tremblaya
proteins="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/KeggStand/source/P_citri_unfiltered_+MorTrem.fasta"
outdir="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/KeggStand/Out_Gapseq_v2/"
#------------------------------------#
mkdir -p ${outdir} 
cd ${outdir}

cp $proteins InsectDB.faa
cp $proteins BacterialDB.faa

#########################
#Run Gapseq
#########################
source /home/a/arno-hagenbeek/miniforge3/etc/profile.d/conda.sh #This and the following line initiate the conda env
conda activate /home/a/arno-hagenbeek/miniforge3/envs/gapseq

modelA="InsectDB"
modelB="BacterialDB"

# (1) Reaction & Pathway prediction
gapseq find -p all -b 200 -M prot -t Insecta -z 2 -l all $modelA.faa
gapseq find -p all -b 200 -M prot -t Bacteria -z 2 -l all $modelB.faa
echo "-------------------------Reaction and pathways predicted"

# # (2) Transporter prediction
# gapseq find-transport -b 200 $modelA.faa
# gapseq find-transport -b 200 $modelB.faa
# echo "---------------------------------Transporters predicted"

# # (3) Building Draft Model - based on Reaction-, Pathway-, and Transporter prediction
# gapseq draft -r $modelA-all-Reactions.tbl -t $modelA-Transporter.tbl -p $modelA-all-Pathways.tbl -u 200 -l 100 -c $modelA.faa
# gapseq draft -r $modelB-all-Reactions.tbl -t $modelB-Transporter.tbl -p $modelB-all-Pathways.tbl -u 200 -l 100 -c $modelB.faa
# echo "--------------------------------------Draft model built"

# # (4) Growth medium prediction
# gapseq medium -m $modelA-draft.RDS -p $modelA-all-Pathways.tbl
# gapseq medium -m $modelB-draft.RDS -p $modelB-all-Pathways.tbl
# echo "--------------------------------Growing Conditions predicted"

# # (5) Fill but later