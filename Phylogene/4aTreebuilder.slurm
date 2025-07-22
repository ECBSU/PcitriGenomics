#!/bin/bash
#SBATCH -p compute
#SBATCH --output=PhyloTreeR_%a.out
#SBATCH -t 4-0
#SBATCH --mem=64G
#SBATCH -c 32
#SBATCH --array=0-92   #CHANGE THIS TO MATCH THE NUMBER OF FASTA FILES 0-0=1 0-2=3 0-6=7 ETC.

#########################
# INPUT VARIABLES, CHANGE AS NEEDED!!!
#########################
input_dir="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/MetPathCheck/higlightedHGT_part2/Trimmed_aligns"
iqtree_dir="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/MetPathCheck/higlightedHGT_part2/Phylogenies"
extension=".phy"  # Extension of your input files

#########################
# PROGRAM PATHS
#########################
module load bioinfo-ugrp-modules DebianMed/12.0
ml iqtree/2.0.7+dfsg-1
iqtree_path="iqtree2"  # Assuming iqtree2 is in your PATH

#########################
# SETUP DIRECTORIES
#########################
mkdir -p "$iqtree_dir"

#########################
# GET FILE LIST AND PROCESS CURRENT FILE
#########################
cd "$input_dir"
files=($(ls *$extension))

# Check if there are files to process
if [ ${#files[@]} -eq 0 ]; then
    echo "Error: No files with extension $extension found in $input_dir"
    exit 1
fi

# Get the current file to process based on array job ID
current_file="${files[${SLURM_ARRAY_TASK_ID}]}"
base_name=$(basename "$current_file" "$extension")

echo "Processing file: $current_file (ID: ${SLURM_ARRAY_TASK_ID})"

#########################
# RUN IQ-TREE2
#########################
echo "Running IQ-TREE2..."
iqtree_prefix="$iqtree_dir/${base_name}"

"$iqtree_path" \
    -s "$input_dir/$current_file" \
    --mset LG+C20,Q.insect+C20 \
    -bnni \
    --safe \
    -T AUTO \
    -B 1000 \
    --alrt 1000 \
    -wbtl \
    -pre "$iqtree_prefix"

echo "IQ-TREE2 completed"
echo "All processing completed for $current_file"

