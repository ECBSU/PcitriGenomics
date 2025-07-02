#!/bin/bash
#SBATCH -p compute
#SBATCH -t 0-5
#SBATCH --mem=128G
#SBATCH -c 64
#SBATCH -n 1
#SBATCH --job-name=YAHS
#SBATCH --output=YAHS.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

## Run YAHS scaffolding tool using HIC data, there are 2 files that are required
##   A FASTA format file with contig sequences which need to be indexed (ie Samtools faidx)
##   A BAM/BED/BIN/PA5 file with the alignment results of Hi-C reads to the contigs.
##       --->>>   For this one run first the HIC_NFcore.sh script first    <<<-------

out="HiFipolished"
## Create the file directory before running
outdir="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_Mrg_polished_YAHS"
## Indexed contigs reference assembly from HIfiasm --->>> ...p_ctg.fa
contigs="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/MrgHIFI_polished/HIFIasm_Mrg.np2.fa" 
## could be .bed, .bam or .bin file --->>> NFcoreHIC/hicpro/mapping/...pairs.bam
hicaln="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_Mrg_polished_mpd/hicpro/mapping/Javier_P_citri_hic_0_bwt2pairs.bam" 

mkdir -p ${outdir}

###_______________________________________________________________________________________________________________________________
##  Generate the FASTA format file with contig sequences which need to be indexed (ie Samtools faidx)
#/apps/unit/HusnikU/samtools-1.2/samtools faidx ${contigs}

/apps/unit/HusnikU/yahs/yahs \
    -r 1000,2000,5000,10000,20000,50000,100000,200000,500000 \
    -o ${outdir}/${out} \
    ${contigs} ${hicaln} \
## set the path of juicer_tools
juicer_tools="java -Xmx32G -jar /apps/unit/HusnikU/juicer_tools_1.22.01.jar pre"

## Generate .hic files for juicer tools
#### this is to generate input file for juicer_tools - assembly (JBAT) mode (-a)
/apps/unit/HusnikU/yahs/juicer pre -a -o ${outdir}/${out}_JBAT ${outdir}/${out}.bin ${outdir}/${out}_scaffolds_final.agp ${contigs}.fai 2>${outdir}/tmp_juicer_pre_JBAT.log
cat ${outdir}/tmp_juicer_pre_JBAT.log | grep "PRE_C_SIZE" | cut -d' ' -f2- >${outdir}/${out}_JBAT.chrom.sizes
(${juicer_tools} ${outdir}/${out}_JBAT.txt ${outdir}/${out}_JBAT.hic.part ${outdir}/${out}_JBAT.chrom.sizes) && (mv ${outdir}/${out}_JBAT.hic.part ${outdir}/${out}_JBAT.hic)
