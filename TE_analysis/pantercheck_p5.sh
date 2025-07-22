#!/bin/bash
#SBATCH -p compute
#SBATCH -t 4-0
#SBATCH --mem=100G
#SBATCH -c 120
#SBATCH -n 1
#SBATCH --job-name=repeatM
#SBATCH --output=PanterRepeat_WSI_Mask.out

#------------------------------------#
#Softwares
ml purge
ml repeatmodeler/1.6
source /home/j/javier-tejeda/.bashrc
#------------------------------------#
# Define files 
Pcit_Oki_5c="/flash/HusnikU/Javier/Ref_Genome/PanterComparison/repeat_data/asm_Mrg5C_np2Msk.fa"
Pcit_Oki_5c_unMask="/flash/HusnikU/Javier/Ref_Genome/PanterComparison/repeat_data/asm_Mrg.np2_unMsk.fa"
Pcit_WSI_5c="/flash/HusnikU/Javier/Ref_Genome/PanterComparison/repeat_data/GCA_950023065.1_ihPlaCitr1.1_genomic_5c.fa"
Pcit_WSI_5c_unMask="/flash/HusnikU/Javier/Ref_Genome/PanterComparison/repeat_data/GCA_950023065.1_ihPlaCitr1.1_genomic_5c_unMask.fa"

PanterLib="/flash/HusnikU/Javier/Ref_Genome/PanterComparison/repeat_data/pantera_lib_0_renamed_classified.fa"

#------------------------------------#
echo "Starting Repeatmasker on WSI assembly"
RepeatMasker -lib ${PanterLib} -pa 30 -no_is -xsmall -a -gff -html ${Pcit_WSI_5c}


