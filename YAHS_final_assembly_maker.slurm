#!/bin/bash
#SBATCH -p short
#SBATCH -t 0-2
#SBATCH --mem=16G
#SBATCH -c 12
#SBATCH -n 1
#SBATCH --job-name=YAHS_FA_asm
#SBATCH --output=YAHS_FA_asm.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=javier-tejeda@oist.jp

out="HiFipolished"
## Create the file directory before running
outdir="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_Mrg_polished_YAHS"
## Indexed contigs reference assembly from HIfiasm --->>> ...p_ctg.fa
contigs="/flash/HusnikU/Javier/Pcit_SQC/nextpolish2/MrgHIFI_polished/HIFIasm_Mrg.np2.fa" 
## could be .bed, .bam or .bin file --->>> NFcoreHIC/hicpro/mapping/...pairs.bam
hicaln="/flash/HusnikU/Javier/Pcit_SQC/Assemblies/RAFT_HIFintHIC/purged_Mrg_polished_mpd/hicpro/mapping/Javier_P_citri_hic_0_bwt2pairs.bam" 

## this is to generate final genome assembly file after manual curation with JuiceBox (JBAT)
# the output assembly file after curation is ${outdir}/${out}_JBAT.review.assembly
# the final output is ${outdir}/${out}_JBAT.FINAL.agp and ${outdir}/${out}_JBAT.FINAL.fa
/apps/unit/HusnikU/yahs/juicer post -o ${outdir}/${out}_JBAT ${outdir}/${out}_JBAT.review.assembly ${outdir}/${out}_JBAT.liftover.agp ${contigs}