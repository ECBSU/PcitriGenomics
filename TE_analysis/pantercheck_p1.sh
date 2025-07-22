#!/bin/bash
#SBATCH -p compute
#SBATCH --output=panter-part1.out
#SBATCH -t 0-4
#SBATCH --mem=8G
#SBATCH -c 32

ml purge
ml bioinfo-ugrp-modules
ml DebianMed/12.0
ml nf-core

# Appendend chromosomes 
bgzip -@ 4 Chromosomes/chr1-chromosome1.fa
samtools faidx Chromosomes/chr1-chromosome1.fa.gz
bgzip -@ 4 Chromosomes/chr2-chromosome3.fa
samtools faidx Chromosomes/chr2-chromosome3.fa.gz
bgzip -@ 4 Chromosomes/chr3-chromosome5.fa
samtools faidx Chromosomes/chr3-chromosome5.fa.gz
bgzip -@ 4 Chromosomes/chr4-chromosome4.fa
samtools faidx Chromosomes/chr4-chromosome4.fa.gz
bgzip -@ 4 Chromosomes/chr5-chromosome2.fa
samtools faidx Chromosomes/chr5-chromosome2.fa.gz

echo "Files compressed"

# 1.3- Create a pangenome for each chromosome. -n is the number of haplotypes/genomes included. -t is the number of threads.

nextflow run nf-core/pangenome -r dev --input Chromosomes/chr1-chromosome1.fa.gz --n_haplotypes 2 --outdir chromosome1/ -profile oist
nextflow run nf-core/pangenome -r dev --input Chromosomes/chr2-chromosome3.fa.gz --n_haplotypes 2 --outdir chromosome2/ -profile oist
nextflow run nf-core/pangenome -r dev --input Chromosomes/chr3-chromosome5.fa.gz --n_haplotypes 2 --outdir chromosome3/ -profile oist
nextflow run nf-core/pangenome -r dev --input Chromosomes/chr4-chromosome4.fa.gz --n_haplotypes 2 --outdir chromosome4/ -profile oist
nextflow run nf-core/pangenome -r dev --input Chromosomes/chr5-chromosome2.fa.gz --n_haplotypes 2 --outdir chromosome5/ -profile oist
