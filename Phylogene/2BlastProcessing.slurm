#!/bin/bash
#SBATCH -p compute
#SBATCH -t 0-1
#SBATCH --mem=8G
#SBATCH -c 8
#SBATCH -n 1
#SBATCH --job-name=blastP_mod
#SBATCH --output=.blastP_mod.out

infile=/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/MetPathCheck/higlightedHGT_part2/Out_highlightedHGT_50.txt
base_dir=/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/MetPathCheck/higlightedHGT_part2/

# Create directories for individual fasta files and cd-hit results
fasta_dir="${base_dir}/SequencesByQuery_50"

mkdir -p "$fasta_dir" "$cdhit_dir"

echo "Creating fasta files grouped by qseqid..."

# Check if the input file exists
if [[ ! -f "$infile" ]]; then
    echo "Error: Input file $infile not found."
    exit 1
fi

# Create a temporary file to store unique qseqids
unique_qseqids=$(mktemp)
awk 'BEGIN {FS="\t"} {print $1}' "$infile" | sort | uniq > "$unique_qseqids"

# Create separate FASTA files for each qseqid
while read -r qseqid; do
    echo "Processing qseqid: $qseqid"
    outfile="${fasta_dir}/${qseqid}.fasta"
    
    awk -v qid="$qseqid" 'BEGIN {FS="\t"} 
    $1 == qid {
        if (NF >= 16) {
            header = ">" $3 "_" $16
            seq = $14
            print header
            print seq
        }
    }' "$infile" > "$outfile"
    
done < "$unique_qseqids"

# Clean up temporary file
rm "$unique_qseqids"

echo "All processing complete."
echo "Individual FASTA files are in: $fasta_dir"
