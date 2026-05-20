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
rev_reads=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $CONFIG)


# load software
module load fastp-uoneasy/0.23.4-GCC-12.3.0

# move to working directory
cd /gpfs01/home/mbzlld/data/tradis

# make a dir for the trimmed reads and one for the report files
mkdir -p fastp_trimmed_fastqs
mkdir -p fastp_reports


# run fastp on the reads for this sample
fastp \
-i $fwd_reads \
-I $rev_reads \
-o fastp_trimmed_fastqs/${fwd_reads##*/} \
-O fastp_trimmed_fastqs/${rev_reads##*/} \
--detect_adapter_for_pe \
--trim_poly_g \
--length_required 50 \
--thread 8 \
--html fastp_reports/${fwd_reads##*/}_fastp.html \
--json fastp_reports/${fwd_reads##*/}_fastp.json


# unload software
module unload fastp-uoneasy/0.23.4-GCC-12.3.0

