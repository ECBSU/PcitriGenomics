#!/bin/bash
#SBATCH -p compute
#SBATCH -t 1-0
#SBATCH --mem=150G
#SBATCH -c 36
#SBATCH -n 1
#SBATCH --job-name=prg_hap
#SBATCH --output=prg_merged_s2-3.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

######More info on the script -> https://bitbucket.org/mroachawri/purge_haplotigs/src/master/

miniMP2="/apps/unit/HusnikU/minimap2-2.24_x64-linux"
samt="/apps/unit/HusnikU/samtools-1.2/samtools"

## ----------------------------------------------------------------------------------------------------
outp="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_Mrg"
hap="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/finalasm.hic" #.p_ctg.gfa

RAFT_frag="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/fragmented.reads.fasta"
naming="RHwH_Merged"

#Prep data and Step1 ---------------------------------------------------------------------------------
#Step0 - Prep data

mkdir -p "$outp"
cd ${outp}
#awk '/^S/{print ">"$2;print $3}' ${hap}.p_ctg.gfa > ${hap}.p_ctg.fa
${miniMP2}/minimap2 -ax map-hifi -t 34 ${hap}.p_ctg.fa ${RAFT_frag} > ${outp}/${naming}.sam
${samt} view -Sb ${outp}/${naming}.sam -o ${outp}/${naming}.bam
${samt} sort ${outp}/${naming}.bam ${outp}/${naming}.sorted
rm -f ${outp}/${naming}.bam
rm -f ${outp}/${naming}.sam
echo "prep_done"

##Step1 - generate histogram and get cutoffvalues
source /home/j/javier-tejeda/.bashrc
conda activate purge_haplotigs
cd ${outp}
purge_haplotigs hist -b ${outp}/${naming}.sorted.bam -g ${hap}.p_ctg.fa -t 32

## ----------------------------------------------------------------------------------------------------
## Run step 2 and 3 

##Step2 - using the cutoffs from the previous step to analyse the coverage on a contig by contig basis
source /home/j/javier-tejeda/.bashrc
conda activate purge_haplotigs
cd ${outp}
purge_haplotigs cov -i ${outp}/${naming}.sorted.bam.gencov -l 0 -m 26 -h 130

##Step3 - create the filtered assembly
purge_haplotigs purge -g ${hap}.p_ctg.fa -c ${outp}/coverage_stats.csv -t 32 \
    -d -b ${outp}/${naming}.sorted.bam