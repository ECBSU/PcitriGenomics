#!/bin/bash
#SBATCH -p compute
#SBATCH -t 0-2
#SBATCH --mem=120G
#SBATCH -c 128
#SBATCH -n 1
#SBATCH --job-name=blastP_4TaxtTree
#SBATCH --output=.blastP_4TaxtTree.out

module load bioinfo-ugrp-modules DebianMed/12.0
ml cd-hit/4.8.1-4

name=Out_highlightedHGT_50
input=/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/MetPathCheck/higlightedHGT_part2/HGTchecks.faa
output=/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/MetPathCheck/higlightedHGT_part2/

# Run diamond BLAST
/apps/unit/HusnikU/diamond blastp \
    --query $input \
    --db /bucket/HusnikU/Databases/nr_2024_diamond.dmnd \
    --evalue 0.0000000001 \
    --query-cover 50 \
    --max-target-seqs 1000 \
    -p 128 \
    --outfmt 6 qseqid sseqid stitle pident length mismatch gapopen qstart qend sstart send evalue bitscore sseq qseq staxids \
    --out ${output}${name}.txt
echo "BlastP done"
echo "Appending self-matches for each input sequence..."

# Create a temporary file to store the self-matches
tmpfile=$(mktemp)

# Process the input FASTA file
current_seq_id=""
current_seq=""

# Read the input file line by line
while IFS= read -r line; do
  if [[ $line == ">"* ]]; then
    # If we have a previous sequence, write its self-match
    if [[ -n "$current_seq_id" && -n "$current_seq" ]]; then
      seq_length=${#current_seq}
      # Format: qseqid sseqid stitle pident length mismatch gapopen qstart qend sstart send evalue bitscore sseq qseq staxids
      echo -e "$current_seq_id\t$current_seq_id\t$current_seq_id\t100.0\t$seq_length\t0\t0\t1\t$seq_length\t1\t$seq_length\t0.0\t$seq_length\t$current_seq\t$current_seq\t0" >> "$tmpfile"
    fi
    # Get the new sequence ID (removing the '>' character)
    current_seq_id=${line:1}
    # Remove any whitespace from the ID
    current_seq_id=${current_seq_id%%[[:space:]]*}
    current_seq=""
  else
    # Append sequence data, removing any whitespace
    current_seq+=$(echo "$line" | tr -d '[:space:]')
  fi
done < "$input"

# Handle the last sequence
if [[ -n "$current_seq_id" && -n "$current_seq" ]]; then
  seq_length=${#current_seq}
  echo -e "$current_seq_id\t$current_seq_id\t$current_seq_id\t100.0\t$seq_length\t0\t0\t1\t$seq_length\t1\t$seq_length\t0.0\t$seq_length\t$current_seq\t$current_seq\t0" >> "$tmpfile"
fi

# Append the self-matches to the BLAST output
cat "$tmpfile" >> "${output}${name}.txt"

# Clean up
rm "$tmpfile"

echo "BlastP done with self-matches added"