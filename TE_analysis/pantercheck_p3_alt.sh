#!/bin/bash
#SBATCH -p compute
#SBATCH --output=panter-part3_alt.out
#SBATCH -t 1-0
#SBATCH --mem=32G
#SBATCH -c 64

# 3- Classify the library obtained
# 3.1 Use your classifier of choice to classify the sequences obtained.
# Threshold 0.9 conservative at the expense of coverage, 0.7 is the default

terrier \
    --input /flash/HusnikU/Javier/Ref_Genome/PanterComparison/ChromosomeLibs/pantera_lib_0.fa \
    --output-csv /flash/HusnikU/Javier/Ref_Genome/PanterComparison/ChromosomeLibs/Classified/pantera_lib_0_classified.csv \
    --output-fasta /flash/HusnikU/Javier/Ref_Genome/PanterComparison/ChromosomeLibs/Classified/pantera_lib_0.fa.classified\
    --threshold 0.9\


