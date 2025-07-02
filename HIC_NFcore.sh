#!/bin/bash
#SBATCH -p compute
#SBATCH -t 2-0
#SBATCH --mem=100G
#SBATCH -c 96
#SBATCH -n 1
#SBATCH --job-name=HIC_NFC
#SBATCH --output=HIC_NFCore_RAFT_mrgpolish.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

## Make sure you create and move to the new working directory before sending the work to Slurm!!
## This script will generate log file even when you specify the --output
## Load the latest Nextflow and Singularity environment modules
## from https://nf-co.re/configs/oist

ml purge
ml bioinfo-ugrp-modules
ml nf-core

## Run nf-core pipeline
## --input: make <input_data>.csv before you run the job. Check https://nf-co.re/hic/2.1.0/docs/usage
## --fasta: reference genome
## --outdir: directory for outputs

mrg_hifi="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/MrgHIFI_polished/HIFIasm_Mrg.np2.fa"
outhifi="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_Mrg_polished_mpd"

mkdir -p ${outhifi}
nextflow run nf-core/hic -profile oist \
    --input ./HIC_NFcore_input_data.csv \
    --dnase \
    --fasta ${mrg_hifi} \
    --outdir ${outhifi}