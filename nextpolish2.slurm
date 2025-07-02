#!/bin/bash
#SBATCH -p compute
#SBATCH -t 1-0
#SBATCH --mem=100G
#SBATCH -c 120
#SBATCH -n 1
#SBATCH --job-name=nextpolish
#SBATCH --output=o_nextpolish2_mrg_fr.log
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javier-tejeda@oist.jp

source /home/j/javier-tejeda/.bashrc

#-------------Softwares--------------#
NEXTPOLISH2="/apps/unit/HusnikU/Conda-envs/nextpolish2/bin/nextPolish2"
YAK_NP2="/apps/unit/HusnikU/Conda-envs/nextpolish2/bin/yak"
#------------------------------------#
# Define directory 
RUN_DIR='/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/MrgHIFI_polished'
mkdir -p "$RUN_DIR"
cd "$RUN_DIR" || exit
#------------------------------------#
# Define files and names 
## PAth to assemblie(s)
RAFT_HIFintHIC_Mrg_5C="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_Mrg_YAHS/5C_RAFT-HIFIwHICp_Mrg_JBAT.FINAL.fa"
RAFT_HIFintHIC_hap1_5C="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_hap1_YAHS/5C_RAFT-HIFIwHICp_hap1_JBAT.FINAL.fa"
RAFT_HIFintHIC_hap2_5C="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_hap2_YAHS/5C_RAFT-HIFIwHICp_hap2_JBAT.FINAL.fa"
RAFT_HIFi_Mrg_purged="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_Mrg/curated.fasta"
RAFT_HIFi_Mrg_purged_polished_HIC5C="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_Mrg_polished_YAHS/HiFipolished_JBAT.FINAL.5C.fa"
## Rawreads
raw_reads="/bucket/HusnikU/Sequencing_data/38_PacBio_HF_ID567_Javier/m64150e_230224_073054.hifi_reads.fastq"

#------------------------------------#
echo "starting mapping with minimap2"
minimap2 -ax map-hifi -t 100 ${RAFT_HIFi_Mrg_purged_polished_HIC5C} ${raw_reads}|samtools sort -o hifi.map.sort.bam -
samtools index hifi.map.sort.bam

source /home/j/javier-tejeda/.bashrc
conda activate /apps/unit/HusnikU/Conda-envs/nextpolish2

echo "prep of K-me datasets"
${YAK_NP2} count -t 24 -o k17.yak -k 17 -b 37 ${raw_reads}
${YAK_NP2} count -t 24 -o k31.yak -k 31 -b 37 ${raw_reads}
${YAK_NP2} count -t 24 -o k43.yak -k 43 -b 37 ${raw_reads}

echo "Run Nextpolish2"
${NEXTPOLISH2} -t 100 hifi.map.sort.bam ${RAFT_HIFi_Mrg_purged_polished_HIC5C} k17.yak k31.yak k43.yak > RAFT_HIFi_Mrg_purged_polished_HIC5C.np2.fa


