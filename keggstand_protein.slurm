#!/bin/bash

#SBATCH -p compute
#SBATCH --output=KEGG_stand_%a.out
#SBATCH -t 0-6
#SBATCH --mem=128G
#SBATCH -c 32
#SBATCH --array=0-0   #CHANGE THIS TO MATCH THE NUMBER OF FASTA FILES 0-0=1 0-2=3 0-6=7 ETC.

#This script runs eggnog on the fasta files in the provided directory, and uses the output to calculate the completion of each KEGG module.
##########################################################################################################################################

#########################
#INPUT VARIABLES, CHANGE AS NEEDED!!!
#########################
Bacteria=/bucket/HusnikU/Databases/EggNOG_mmseqs2_databases/Bacteria.mmseqs/Bacteria.mmseqs
Insects=/bucket/HusnikU/Databases/EggNOG_mmseqs2_databases/Insecta.mmseqs/Insecta.mmseqs

input_dir=/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/KeggStand/source  #Directory containing your fasta files
output_dir=/flash/HusnikU/Javier/pcit_RNA/FunctionalGeneAnnotation/KeggStand/Output_Bacteria #Directory to which to write the output
extension=.fasta #Extension used in your fasta files
EggNOG_mmseq_database=${Bacteria} #Eggnog database to search


#########################
#Variables to required scripts, programs and environments. Generally won't have to be changed
#########################
KEGGstand_module_checker_path=/bucket/HusnikU/Unit_Members/Arno/Scripts/KEGGstand_module_checker.py
KEGGstand_pathway_checker_path=/bucket/HusnikU/Unit_Members/Arno/Scripts/KEGGstand_pathway_checker.py
KEGG_module_database_path=/bucket/HusnikU/Unit_Members/Arno/Scripts/KEGG_module_db
KEGG_pathway_database_path=/bucket/HusnikU/Unit_Members/Arno/Scripts/KEGG_k_entries_db
conda_source_path=/home/a/arno-hagenbeek/miniforge3/etc/profile.d/conda.sh
eggnog_path=/bucket/HusnikU/Conda-envs/eggnog

#########################
#Reading input
#########################
cd $input_dir
sf=(*$extension)
mkdir $output_dir
cd $output_dir

#########################
#Run Eggnog
#########################
source $conda_source_path #This and the following line initiate the conda env
conda activate $eggnog_path
emapper.py -m mmseqs --mmseqs_db $EggNOG_mmseq_database --data_dir /bucket/HusnikU/Databases/Eggnog_db/Eggnog_Diamond_db/ -i ${input_dir}/${sf[${SLURM_ARRAY_TASK_ID}]} --itype proteins -o ${output_dir}/${sf[${SLURM_ARRAY_TASK_ID}]} --cpu 32

#########################
#Invoke black coding magic to run Arno's script of horrible spaghetti code
#########################
python $KEGGstand_module_checker_path ${output_dir}/${sf[${SLURM_ARRAY_TASK_ID}]}.emapper.annotations ${output_dir}/${sf[${SLURM_ARRAY_TASK_ID}]}.emapper.annotations $KEGG_module_database_path

#########################
#Invoke regular coding magic to run Arno's script of slighlty less horrible spaghetti code
#########################
python $KEGGstand_pathway_checker_path ${output_dir}/${sf[${SLURM_ARRAY_TASK_ID}]}.emapper.annotations ${output_dir}/${sf[${SLURM_ARRAY_TASK_ID}]}.emapper.annotations_pathway_and_BRITE $KEGG_pathway_database_path