#!/bin/bash
#SBATCH -p compute
#SBATCH -t 0-8
#SBATCH --mem=64G
#SBATCH -c 36
#SBATCH -n 1
#SBATCH --job-name=HISAT
#SBATCH --output=o_hisat2_dta.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

# maskedGenome="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/Mrg5C_polished/asm_Mrg5C_np2Msk.fa"
# maskedgtf="/flash/HusnikU/Javier/pcit_RNA/MaskGenePred/braker/braker.gtf"

rna1="/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome1_S2_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome2_S5_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome3_S8_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome4_S11_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome5_S14_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body1_S4_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body2_S7_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body3_S10_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body4_S13_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body5_S16_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut1_S3_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut2_S6_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut3_S9_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut4_S12_L001_R1_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut5_S15_L001_R1_001.fastq.gz"
rna2="/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome1_S2_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome2_S5_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome3_S8_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome4_S11_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_bacteriome5_S14_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body1_S4_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body2_S7_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body3_S10_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body4_S13_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_body5_S16_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut1_S3_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut2_S6_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut3_S9_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut4_S12_L001_R2_001.fastq.gz,/bucket/HusnikU/Sequencing_data/49_NovaSeq_231217_A00457_0408_BHTLKWDRX3_Javier_Duda_Olha_Gustavo_Petra/Data/Intensities/BaseCalls/ID715_HusnikU/P_cit_gut5_S15_L001_R2_001.fastq.gz"

rhmpph5cp="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/MrgHIFI_polished/RAFT_HIFi_Mrg_purged_polished_HIC5C.np2.fa.masked"

outdir="/flash/HusnikU/Javier/pcit_RNA/assemblies/rhmpph5cp_hisat2Aligment"
mkdir -p ${outdir}
cd ${outdir}

ml purge
ml bioinfo-ugrp-modules
ml DebianMed/12.0
ml hisat2/2.2.1-4+b2
source /home/j/javier-tejeda/.bashrc

####This mode aims to find as many alignments as possible, including non-canonical alignments (e.g., alignments with gaps or mismatches)
# hisat2-build -p 32 ${maskedGenome} genome_index
# hisat2 -x genome_index -1 ${rna1} -2 ${rna2} -k 3 -p 36 --max-intronlen 20000 \
# |samtools sort -@ 6 -O BAM - > sorted.bam && \
# samtools index -@ 6 sorted.bam

### --dta Instead of exploring all possible alignments, it deterministically extends the seeds to find a single best alignment
hisat2-build -p 32 ${rhmpph5cp} genome_index
hisat2 --dta -q -x genome_index -1 ${rna1} -2 ${rna2} -p 36 --max-intronlen 20000 -S dta.sam
samtools sort -@ 36 -o sorted_dta.bam dta.sam


###----------------------------------------------------------------------------------------------------------------------------------------------------------
### NOTE: Max intron length 20 to 10.5 Kb 
#  --genome_guided_max_intron 20000 -> --alignIntronMax
# 99.5% of introns are >20 Kb in ladybugs https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-022-08299-w
# Figure4 E) 3 shows a max HGT intron length ~10.5kb for different insect species https://www.sciencedirect.com/science/article/pii/S009286742200719X#app2
###----------------------------------------------------------------------------------------------------------------------------------------------------------

