#!/bin/bash
#SBATCH -p compute
#SBATCH --output=SeqProcess_%a.out
#SBATCH -t 0-8
#SBATCH --mem=16G
#SBATCH -c 32
#SBATCH --array=0-92   #CHANGE THIS TO MATCH THE NUMBER OF FASTA FILES 0-0=1 0-2=3 0-6=7 ETC.

#########################
# INPUT VARIABLES, CHANGE AS NEEDED!!!
#########################
input_dir="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/MetPathCheck/higlightedHGT_part2/SequencesByQuery_50"
base_dir=/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/MetPathCheck/higlightedHGT_part2/
cdhit_dir="$base_dir/ClusteredSequences_85"
output_dir="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/MetPathCheck/higlightedHGT_part2/Aligned_MAFT"
trimal_dir="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/MetPathCheck/higlightedHGT_part2/Trimmed_aligns"
extension=".fasta"  # Extension of your input files

#########################
# PROGRAM PATHS AND MODULES
#########################
module load bioinfo-ugrp-modules DebianMed/12.0
ml cd-hit/4.8.1-4
mafft_path="/apps/unit/HusnikU/mafft/bin/mafft"
trimal_path="/apps/unit/HusnikU/trimal-trimAl/source/trimal"

#########################
# SETUP DIRECTORIES
#########################
mkdir -p "$cdhit_dir" "$output_dir" "$trimal_dir"

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
# RUN CD-HIT
#########################
echo "Running cd-hit clustering..."
clustered_file="$cdhit_dir/${base_name}_clustered.fasta"

cd-hit \
    -i "$input_dir/$current_file" \
    -o "$clustered_file" \
    -c 0.8 \
    -d 0 \
    -T 32  # Use all allocated CPUs

echo "cd-hit clustering completed"

#########################
# RUN MAFFT
#########################
echo "Running MAFFT alignment..."
aligned_file="$output_dir/${base_name}_aligned.fasta"

"$mafft_path" \
    --localpair \
    --maxiterate 2000 \
    --thread 32 \
    --reorder \
    "$clustered_file" > "$aligned_file"

echo "MAFFT alignment completed"

#########################
# RUN TRIMAL
#########################
echo "Running trimAl..."
trimal_out="$trimal_dir/${base_name}_trimmed.phy"

"$trimal_path" \
    -in "$aligned_file" \
    -out "$trimal_out" \
    -gappyout \
    -phylip_paml

echo "trimAl completed"

echo "All processing completed for $current_file"
echo "Clustered sequence saved to: $clustered_file"
echo "Aligned sequence saved to: $aligned_file"
echo "Trimmed aligment sequence saved to: $trimal_out"
