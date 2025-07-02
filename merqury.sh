#!/bin/bash
#SBATCH -p compute
#SBATCH -t 0-2
#SBATCH --mem=60G
#SBATCH -c 64
#SBATCH -n 1
#SBATCH --job-name=merqury
#SBATCH --output=out_merq_alt.log
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javier-tejeda@oist.jp

#-------------Softwares--------------#
source /home/j/javier-tejeda/.bashrc
#------------------------------------#
# Define directory 
RUN_DIR='/flash/HusnikU/Javier/Pcit_SQC/merqury'
# mkdir -p "$RUN_DIR"
cd "$RUN_DIR" || exit
#------------------------------------#
# Define files and names 
Mrg_np2="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/Mrg5C_polished/asm_Mrg.np2.fa"
hap1_np2="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/hap1_5C_polished/asm_hap1.np2.fa"
hap2_np2="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/hap2_5C_polished/asm_hap2.np2.fa"
raw_reads="/bucket/HusnikU/Sequencing_data/38_PacBio_HF_ID567_Javier/m64150e_230224_073054.hifi_reads.fastq"
raconp10="/flash/HusnikU/Javier/Pcit_SQC/Racon_polish/Pcit_HIFIintHIC_purged/racon10/Pcit_HIFIintHIC_purged_Racon10.fasta"
FunP="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_Mrg_YAHS/RAFT-HIFIwHICp_Mrg_JBAT.FINAL.fa"

rhmpph5cp="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/MrgHIFI_polished/RAFT_HIFi_Mrg_purged_polished_HIC5C.np2.fa"

#------------------------------------#
# echo "fastk started"
FastK -k31 -t1 -p -T64 -M64 -v -Nkmertable ${raw_reads}
echo "fastk done"

ktab="/flash/HusnikU/Javier/Pcit_SQC/merqury/kmertable.ktab"

#------------------------------------#
# echo "merqury started for colapsed assembly"
# /apps/unit/HusnikU/MERQURY.FK/MerquryFK -v -lfs -pdf -z -T60 ${ktab} ${Mrg_np2} Mrg_ASMstats

# echo "merqury started for haplotipes assembly" 
# /apps/unit/HusnikU/MERQURY.FK/MerquryFK -v -lfs -pdf -z -T60 ${ktab} ${hap1_np2} ${hap2_np2} Haps_ASMstats

 
/apps/unit/HusnikU/MERQURY.FK/MerquryFK -v -lfs -pdf -z -T60 ${ktab} ${rhmpph5cp} rhmpph5cp


