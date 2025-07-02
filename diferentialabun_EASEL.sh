#!/bin/bash
#SBATCH -p compute 
#SBATCH --mem=8G
#SBATCH -c 8 
#SBATCH -t 0-4
#SBATCH -n 1
#SBATCH --job-name=DifAbund_nfc
#SBATCH --output=o_DifAbund_nfc_mrg5cmask.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

ml purge
ml bioinfo-ugrp-modules
ml singularity
ml nf-core
##------------------------INPUT_FILES------------------------------------------------------------------------------------------------
## Files from nf-core rnaseq pipeline
# maskedGenome="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/Mrg5C_polished/asm_Mrg5C_np2Msk.fa"
maskedgtf=/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/Easel/Pcit_easel_dta_bam_vL/final_predictions/P_citri_unfiltered.gtf
maskedannotgtf="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/Easel/Pcit_easel_dta_bam_vL/final_predictions/P_citri_unfiltered_oT_anot.gtf"

##Gene-counts -> OBSERVATIONS
#GeneVals="/flash/HusnikU/Javier/pcit_RNA/nfc_rnaseq/Mrg5C_EASEL_RNAseq/star_rsem/rsem.merged.gene_counts.tsv"
##Transcript-counts -> OBSERVATIONS
TranscrVals="/flash/HusnikU/Javier/pcit_RNA/nfc_rnaseq/Mrg5C_EASEL_RNAseq/star_rsem/rsem.merged.transcript_counts.tsv"
##Sample-description CSV
desc="/flash/HusnikU/Javier/pcit_RNA/nfc_rnaseq/SmetaDiffAbun.csv"
##Comparations2make CSV based on -> OBSERVATIONS
comp="/flash/HusnikU/Javier/pcit_RNA/nfc_rnaseq/SmetaComps.csv"
##------------------------------------------------------------------------------------------------------------------------

##Parameters vff
outdir="/flash/HusnikU/Javier/pcit_RNA/nfc_rnaseq/Mrg5C_EASEL_DiffAbund_Transcript"
mkdir -p ${outdir}

 nextflow run nf-core/differentialabundance \
     --study_name Pcit_TranscExp_ANOT \
     --study_type rnaseq \
     --input ${desc} \
     --contrasts ${comp} \
     --matrix ${TranscrVals} \
     --gtf ${maskedannotgtf} \
     \
     --features_id_col transcript_id \
     --features_metadata_cols gene_id,transcript_id,ID,Parent,Support,Expression,CDS_Repeat,fLiso,GC_cont,Seed_Ortholog,E_value,Anotation,Species,COG,Description,Protein_Domains,Enzyme,HGT,HGTclass \
     --features_gtf_feature_type transcript \
     --features_gtf_table_first_field transcript_id \
     \
     --exploratory_n_features -1 \
     --filtering_min_samples 12 \
     --filtering_min_abundance 10  \
     --differential_min_fold_change 2 \
     --differential_max_qval 0.05 \
     --differential_max_pval 0.05 \
     --differential_feature_name_column transcript_id \
     \
     --deseq2_fit_type local \
     --deseq2_sf_type iterate \
     --deseq2_vs_method vst \
     --deseq2_use_t true \
     --deseq2_cores 12 \
     --deseq2_vst_nsub 4000 \
     \
     --outdir ${outdir}  \
     -profile oist
