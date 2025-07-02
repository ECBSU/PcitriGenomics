#!/bin/bash
#SBATCH -p compute 
#SBATCH --mem=10G
#SBATCH -c 6 
#SBATCH -t 2-12
#SBATCH -n 1
#SBATCH --job-name=easel_nfc
#SBATCH --output=o_easel_nfc_rhmpph5cp.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

ml purge
ml bioinfo-ugrp-modules
ml nf-core
ml DebianMed/12.0
ml singularity
source /home/j/javier-tejeda/.bashrc

##Star aligment doesnt work with the pipeline, use Hisat2

nextflow run -hub gitlab PlantGenomicsLab/easel -profile oist -params-file params.yaml --singularity_pull_docker_container -resume