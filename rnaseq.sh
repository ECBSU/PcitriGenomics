#!/bin/bash
#SBATCH -p compute 
#SBATCH --mem=10G
#SBATCH -c 2 
#SBATCH -t 0-8
#SBATCH -n 1
#SBATCH --job-name=rnaseq_nfc
#SBATCH --output=o_rnaseq_nfc_mrg5cmask.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

ml purge
ml bioinfo-ugrp-modules
ml nf-core

# refgenome="/flash/HusnikU/Javier/pcit_RNA/Pcit-GCA-softmasked.fa.gz"
# refgtf="/flash/HusnikU/Javier/pcit_RNA/Pcit-GCA_950023065-genes.gtf"

maskedGenome="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/Mrg5C_polished/asm_Mrg5C_np2Msk.fa" ##Renamed headers to match gtf
maskedgtf="/flash/HusnikU/Javier/pcit_RNA/MaskGenePred/braker/asm_Mrg5C_np2Msk_braker.gtf" ####Renamed headers to not have "":""
sindex="/flash/HusnikU/Javier/pcit_RNA/assemblies/STAR_Pcit"

outdir="/flash/HusnikU/Javier/pcit_RNA/nfc_rnaseq/Mrg5C_Msk_RNAseq"
mkdir -p ${outdir}

##This pipeline quantifies RNA-sequenced reads relative to genes/transcripts in the genome and normalizes the resulting data
nextflow run nf-core/rnaseq \
    --input /flash/HusnikU/Javier/pcit_RNA/nfc_rnaseq/samplesheet.csv \
    --outdir ${outdir} \
    --genome null \
    --fasta ${maskedGenome} \
    --gtf ${maskedgtf} \
    --aligner star_rsem \
    --star_index ${sindex} \
    --igenomes_ignore \
    -profile oist

####
# Requesting Services: Library Preparation + Sequencing
# Type of Sample: Total RNA
# Type of Sequencer: Illumina
# Type of Sequencing Application: RNA Sequencing with poly-A RNA Purification + Strand-specific
# Type of Flowcell: NovaSeq 6000 SP Run Sharing (1 lane), 300 cycles