#!/bin/bash
# 19/5/26

# script to perform read trimming and filtering

#SBATCH --job-name=ReadTrim
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=15g
#SBATCH --time=2:00:00
#SBATCH --array=1-5

# set the config file (only small, just made manually)
CONFIG=~/code_and_scripts/config_files/tradis_config.txt

# extract the fwd and rev files from the config file
fwd_reads=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)


# load software
module load fastp-uoneasy/0.23.4-GCC-12.3.0
source $HOME/.bash_profile
conda activate cutadapt


# move to working directory
cd /gpfs01/home/mbzlld/data/tradis

# make a dir for the trimmed reads and one for the report files
mkdir -p fastp_trimmed_fastqs
mkdir -p fastp_trimmed_fastqs/fastp_reports
mkdir -p cutadapt_trimmed_fastqs

##  # run fastp on the reads for this sample
##  fastp \
##  -i $fwd_reads \
##  -o fastp_trimmed_fastqs/${fwd_reads##*/} \
##  --detect_adapter_for_pe \
##  --trim_poly_g \
##  --length_required 50 \
##  --thread 8 \
##  --html fastp_trimmed_fastqs/fastp_reports/${fwd_reads##*/}_fastp.html \
##  --json fastp_trimmed_fastqs/fastp_reports/${fwd_reads##*/}_fastp.json

# run cutadapt on the fastp trimmed reads 
cutadapt \
--cores 8 \
-g AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
-a GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG \
--poly-a \
--info-file cutadapt_trimmed_fastqs/${fwd_reads##*/}_info.tsv \
-o cutadapt_trimmed_fastqs/${fwd_reads##*/} \
$fwd_reads


# unload software
module unload fastp-uoneasy/0.23.4-GCC-12.3.0
conda deactivate

