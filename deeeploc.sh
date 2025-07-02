#!/bin/bash
#SBATCH -p compute
#SBATCH -t 4-0
#SBATCH --mem=64G
#SBATCH -c 64
#SBATCH -n 1
#SBATCH --job-name=deeploc_array
#SBATCH --output=/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/Deeploc/logs/%A_%a.out
#SBATCH --array=0-905%10

files=(/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/Deeploc/SplitedFasta/*)
echo "slurm: " ${files[${SLURM_ARRAY_TASK_ID}]}

source /home/y/yong-phua/conda_ini.sh 
conda activate deeploc
deeploc2 -f ${files[${SLURM_ARRAY_TASK_ID}]} -o /flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/Deeploc/DeeplockOut -m Accurate
conda deactivate

