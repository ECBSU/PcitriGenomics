#!/bin/bash
#SBATCH -p compute
#SBATCH -t 0-2
#SBATCH --mem=32G
#SBATCH -c 32
#SBATCH -n 1
#SBATCH --job-name=StarIndex
#SBATCH --output=o_starindex.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

maskedGenome="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/Mrg5C_polished/asm_Mrg5C_np2Msk.fa" ##Renamed headers to match gtf
maskedgtf="/flash/HusnikU/Javier/pcit_RNA/MaskGenePred/braker/asm_Mrg5C_np2Msk_braker.gtf" ####Renamed headers to not have "":""

rna1="/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome1_S2_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome2_S5_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome3_S8_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome4_S11_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome5_S14_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body1_S4_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body2_S7_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body3_S10_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body4_S13_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body5_S16_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut1_S3_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut2_S6_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut3_S9_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut4_S12_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut5_S15_L001_R1_001.fastq.gz"
rna2="/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome1_S2_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome2_S5_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome3_S8_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome4_S11_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome5_S14_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body1_S4_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body2_S7_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body3_S10_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body4_S13_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body5_S16_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut1_S3_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut2_S6_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut3_S9_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut4_S12_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut5_S15_L001_R2_001.fastq.gz"


ml purge
ml bioinfo-ugrp-modules
ml DebianMed/12.0
ml rna-star/2.7.10b+dfsg-2+b2
#Aligment---------------------------------------------------------------------------------------------------------------------------------------------
##Create indeces
STAR \
--runThreadN 32 \
--runMode genomeGenerate \
--genomeDir /flash/HusnikU/Javier/pcit_RNA/assemblies/STAR_Pcit \
--genomeFastaFiles ${maskedGenome} \
--sjdbGTFfile ${maskedgtf} \
--sjdbOverhang 100

# ##Maping
# STAR \
# --runThreadN 32 \
# --genomeDir /flash/HusnikU/Javier/pcit_RNA/assemblies/STAR_Pcit \
# --readFilesIn ${rna1} ${rna2} \
# --alignIntronMax 20000 \
# --limitBAMsortRAM 7942319631 \
# --outSAMtype BAM SortedByCoordinate \

###----------------------------------------------------------------------------------------------------------------------------------------------------------
### NOTE: Max intron length 20 to 10.5 Kb 
#  --genome_guided_max_intron 20000 -> --alignIntronMax
# 99.5% of introns are >20 Kb in ladybugs https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-022-08299-w
# Figure4 E) 3 shows a max HGT intron length ~10.5kb for different insect species https://www.sciencedirect.com/science/article/pii/S009286742200719X#app2
###----------------------------------------------------------------------------------------------------------------------------------------------------------

