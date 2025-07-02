#!/bin/bash
#SBATCH -p compute
#SBATCH -t 4-0
#SBATCH --mem=36G
#SBATCH -c 98
#SBATCH -n 1
#SBATCH --job-name=AvP
#SBATCH --output=o_AvP_hgt.log
#SBATCH --mail-user=javier-tejeda@oist.jp

#------------------------------------#
# Define directory 
out_path='/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/AVP_HGT/HGT'
mkdir -p ${out_path}
cd ${out_path}
#------------------------------------#
proteins="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/Easel/Pcit_easel_dta_bam_vL/final_predictions/P_citri_unfiltered.pep"
conf="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/AVP_HGT/config.yaml"
groups="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/AVP_HGT/groups.yaml"
classificationFile="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/AVP_HGT/Clasification_ingroupMetazoa.txt"
##gff file with only transcript information, transcript -> mRNA name change
gff="/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/Easel/Pcit_easel_dta_bam_vL/final_predictions/P_citri_unfiltered_oT.gff" 

#activating conda environment
source /home/y/yong-phua/conda_ini.sh 
conda activate avp
#------------------------------------#

#Diamond blastp hits file, output format should remain as written here
## Default --evalue 1e-5 --max-target-seqs 500
echo "Getting blast hits"
diamond blastp \
    -q $proteins \
    -d /bucket/HusnikU/Databases/AvP_swissprot/uniprot_sprot.fasta.dmnd \
    --evalue 1e-10 --max-target-seqs 5000 \
    --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids \
    --out similarity.out
echo "Blast hits obtained"
#------------------------------------------------------#
echo "Calculating alien indexes"
/home/y/yong-phua/AvP/aux_scripts/calculate_ai.py \
    -i ${out_path}/similarity.out -x $groups
echo "Calculate_ai.py done"
#------------------------------------------------------#
echo "Starting AVP prepare"
/home/y/yong-phua/AvP/avp prepare \
    -a ${out_path}/similarity.out_ai.out \
    -o ${out_path} \
    -f $proteins \
    -b similarity.out \
    -x $groups \
    -c $conf
echo "AVP prepare done"
#------------------------------------------------------#
echo "Starting AVP detect"
/home/y/yong-phua/AvP/avp detect \
    -i ${out_path}/mafftgroups/ \
    -o ${out_path} \
    -g ${out_path}/groups.tsv \
    -t ${out_path}/tmp/taxonomy_nexus.txt \
    -c $conf
echo "AVP detect done"
#------------------------------------------------------#
echo "Starting AVP classiffy"
/home/y/yong-phua/AvP/avp classify \
    -i ${out_path}/fasttree_nexus/ \
    -o ${out_path} \
    -t ${out_path}/fasttree_tree_results.txt \
    -f ${classificationFile} \
    -c $conf
echo "AVP classiffy done"

#------------------------------------------------------#
echo "Starting AVP evaluate"
# This step can inform whether the topology supporting HGT is more likely than the alternative constrained topology that does not support HGT.
# 1 -> The alternate topology is significantly worse hence stonger evidence to whatever the original topology supports
# deltaL  : logL difference from the maximal logl in the set.
# p-AU    : p-value of approximately unbiased (AU) test (Shimodaira, 2002).
/home/y/yong-phua/AvP/avp evaluate \
    -i ${out_path}/mafftgroups/ \
    -t ${out_path}/fasttree_tree_results.txt \
    -o ${out_path} \
    -c $conf
echo "AVP evaluate done"
#------------------------------------------------------#
echo "AVP hgt local score starting"
/home/y/yong-phua/AvP/aux_scripts/hgt_local_score.py \
    -f $gff \
    -a similarity.out_ai.out \
    -t ${out_path}/fasttree_tree_results.txt \
    -m 0
echo "AVP local ght score done"
#------------------------------------------------------#
