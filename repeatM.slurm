#!/bin/bash
#SBATCH -p compute
#SBATCH -t 4-0
#SBATCH --mem=64G
#SBATCH -c 100
#SBATCH -n 1
#SBATCH --job-name=repeatM
#SBATCH --output=o_repeatM.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

#------------------------------------#
#Softwares
ml purge
ml repeatmodeler/1.6
source /home/j/javier-tejeda/.bashrc
#------------------------------------#
# Define directory 
RUN_DIR='/flash/HusnikU/Javier/Pcit_SQC/MaskedGenome/rhmpph5cp_masked'
mkdir -p "$RUN_DIR"
cd "$RUN_DIR" || exit
DBname="Pcit"
#------------------------------------#
# Define files 
Mrg_np2="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/Mrg5C_polished/asm_Mrg.np2.fa"

refgenome="/flash/HusnikU/Javier/Ref_Genome/WSanger_Pcitri/GCA_950023065.1/GCA_950023065.1_ihPlaCitr1.1_genomic.fna"

rhmpph5cp="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/MrgHIFI_polished/RAFT_HIFi_Mrg_purged_polished_HIC5C.np2.fa"


#------------------------------------#
echo "Building DataBase"
BuildDatabase -name ${DBname} ${rhmpph5cp}
echo "DB created"

echo "Starting RepeatModeler"
RepeatModeler -database ${DBname} ${rhmpph5cp} -pa 96 -LTRStruct >& run.out

echo "Masking genome"
RepeatMasker -lib ${DBname}-families.fa -excln -pa 96 -xsmall -ali -gff -source -html ${rhmpph5cp}
