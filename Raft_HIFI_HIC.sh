#!/bin/bash
#SBATCH -p compute
#SBATCH -t 1-0
#SBATCH --mem=120G
#SBATCH -c 64
#SBATCH -n 1
#SBATCH --job-name=RAFT_HIFI_HIC
#SBATCH --output=RAFT_HIFI_HIC_Fasm.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier.tejeda@oist.jp

###Software
HIFIASM="/apps/unit/HusnikU/hifiasm/hifiasm"
RAFT="/apps/unit/HusnikU/RAFT/raft"
##Datasets
raw_reads="/bucket/HusnikU/Sequencing_data/38_PacBio_HF_ID567_Javier/m64150e_230224_073054.hifi_reads.fastq"
hic_r1="/bucket/HusnikU/Sequencing_data/46_HiC_231013_A00457_0379_AHW7CMDRX2_Duda_Javier/HusnikU_ID607/Planococcus_citri_S2_L001_R1_001.fastq.gz"
hic_r2="/bucket/HusnikU/Sequencing_data/46_HiC_231013_A00457_0379_AHW7CMDRX2_Duda_Javier/HusnikU_ID607/Planococcus_citri_S2_L001_R2_001.fastq.gz"
##Output will be pwd
output="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/HF_intHIC_v3/HICintv3.asm"


##Script from https://github.com/at-cg/RAFT -> RAFT-hifiasm workflow
# # First run of hifiasm with 4 threads to obtain error corrected reads and coverage estimate
${HIFIASM} -o errorcorrect -t64 --write-ec ${raw_reads} 2> errorcorrect.log
COVERAGE=$(grep "homozygous" errorcorrect.log | tail -1 | awk '{print $6}')

# # Second run of hifiasm to obtain all-vs-all read overlaps as a paf file
${HIFIASM} -o getOverlaps -t64 --dbg-ovec errorcorrect.ec.fa 2> getOverlaps.log
# Merge cis and trans overlaps
cat getOverlaps.0.ovlp.paf getOverlaps.1.ovlp.paf > overlaps.paf

# # RAFT fragments the error corrected reads
${RAFT} -e ${COVERAGE} -o fragmented errorcorrect.ec.fa overlaps.paf

# Final hifiasm run to obtain assembly of fragmented reads [WITH HIC data]
# A single round of error correction (-r1) is enough here
${HIFIASM} -o finalasm -t64 -r1 --hom-cov 61 -s 0.45 --h1 ${hic_r1} --h2 ${hic_r2} fragmented.reads.fasta 2> finalasm.log
ls finalasm*p_ctg.gfa

## ------------------------------------------Moding HIFIASM NOTES:----------------------
# -t especify number of cores to use
# -z20 trim 20bp from both ends of reads
# -l3 to purge duplications [DEFAULT]
# -l0 to avoid purge duplication step

## To increase contig size
## raise -D<5> -N<100> or -l3
## decrease -s<0.55>