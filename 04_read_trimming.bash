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

# extract the fwd files from the config file
fwd_reads=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)

# load software
module load fastp-uoneasy/0.23.4-GCC-12.3.0
source $HOME/.bash_profile
conda activate cutadapt

# move to working directory
cd /gpfs01/home/mbzlld/data/tradis

# make a dir for the trimmed reads and one for the report files
mkdir -p trimmed_fastqs
mkdir -p trimmed_fastqs/1_fastp
mkdir -p trimmed_fastqs/1_fastp/reports
mkdir -p trimmed_fastqs/2_cutadapt
mkdir -p trimmed_fastqs/2_cutadapt/reports
mkdir -p trimmed_fastqs/3_cutadapt
mkdir -p trimmed_fastqs/3_cutadapt/reports

##  # run fastp on the reads for this sample
##  fastp \
##  -i $fwd_reads \
##  -o trimmed_fastqs/1_fastp/${fwd_reads##*/} \
##  --disable_quality_filtering \
##  --disable_adapter_trimming \
##  --disable_length_filtering \
##  --trim_poly_g \
##  --poly_g_min_len 5 \
##  --trim_poly_x \
##  --poly_x_min_len 4 \
##  --thread 8 \
##  --html trimmed_fastqs/1_fastp/reports/${fwd_reads##*/}_fastp.html

# run cutadapt on the fastp trimmed reads 
cutadapt \
--cores 8 \
-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
--revcomp \
--poly-a \
--minimum-length 50 \
--info-file trimmed_fastqs/3_cutadapt/reports/${fwd_reads##*/}_info.tsv \
-o trimmed_fastqs/3_cutadapt/${fwd_reads##*/} \
trimmed_fastqs/1_fastp/${fwd_reads##*/}


# unload software
module unload fastp-uoneasy/0.23.4-GCC-12.3.0
conda deactivate

