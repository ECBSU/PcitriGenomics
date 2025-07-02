#!/bin/bash
#SBATCH -p compute
#SBATCH -t 4-0
#SBATCH --mem=8G
#SBATCH -c 12
#SBATCH -n 1
#SBATCH --job-name=deeptmhmm_array
#SBATCH --output=/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/DeepTMHMM/logs/%A_%a.out
#SBATCH --array=0-43%1

# Define directory 
RUN_DIR='/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/DeepTMHMM/Pcitri_Unfpep_batch'
mkdir -p "$RUN_DIR"
cd "$RUN_DIR"

files=(/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/DeepTMHMM/split_pep/*)
echo "slurm: " ${files[${SLURM_ARRAY_TASK_ID}]}

source /home/j/javier-tejeda/.bashrc
conda activate /bucket/HusnikU/Conda-envs/DeepTMHMM
biolib run 'DTU/DeepTMHMM:1.0.24' --fasta ${files[${SLURM_ARRAY_TASK_ID}]}
conda deactivate
