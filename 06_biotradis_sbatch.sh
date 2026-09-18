#!/bin/bash
# 2/6/26

# script to run biotradis on various versions of the filtered fastq files

#SBATCH --job-name=biotradis
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=15g
#SBATCH --time=12:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
source $HOME/.bash_profile
conda activate biotradis
run=11
mkdir -p /gpfs01/home/mbzlld/data/tradis/biotradis$run
cd /gpfs01/home/mbzlld/data/tradis/biotradis$run


# make the files.txt file
# for now just work on the first file for testing
#echo "/gpfs01/home/mbzlld/data/tradis/trimmed_fastqs/2_cutadapt/BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1.fq.gz" > files.txt
#ls /gpfs01/home/mbzlld/data/tradis/trimmed_fastqs/2_cutadapt/*.fq.gz > files.txt
#echo "/gpfs01/home/mbzlld/data/tradis/trimmed_fastqs/3_cutadapt/BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1.fq.gz" > files.txt
#ls /gpfs01/home/mbzlld/data/tradis/trimmed_fastqs/3_cutadapt/*.fq.gz > files.txt
echo "/gpfs01/home/mbzlld/data/tradis/trimmed_fastqs/3_cutadapt/BWtacXpress_merge123_1.fq.gz" > files.txt

# ok great, think the input files are as good as they can be. Now to finetune the tradis parameters
# try with more relaxed parameters
# -mm specifies the number of mismatches allowed when matching the transposon tag. DEFAULT = 0. Higher than 2 is not recommended for transposon tags 10-12 bp in length but ours is 46bp long
# -m is the minimum mapping quality score to use a read in downstream analysis. Default 30. needs to be 0 to include multimapping reads
# smalt_y = minimum percentage of identical bases between read and reference DEFAULT .96
# smalt_r = what to do with multimapping reads. 0 = randomly assign a position -1 = leave unmapped. DEFAULT = -1 
bacteria_tradis \
-v \
--smalt \
--smalt_r 0 \
--smalt_k 10 \
--smalt_s 1 \
--smalt_y .90 \
-m 0 \
-mm 6 \
-f files.txt \
-t CGAGCTCGAATTCATCGATGATGGTTGAGATGTGTATAAGAGACAG \
-r /gpfs01/home/mbzlld/data/tradis/reference/GCF_000750555.1_ASM75055v1_genomic.fna


conda deactivate

# run 4:
#--smalt_r 0 \
#--smalt_k 10 \
#--smalt_s 1 \
#--smalt_y .95 \
#-m 0 \
#-mm 3 \

# run 5:
#--smalt_r 0 \
#--smalt_k 10 \
#--smalt_s 1 \
#--smalt_y .90 \
#-m 0 \
#-mm 6 \

# run 6:
#--smalt_r 0 \
#--smalt_k 10 \
#--smalt_s 1 \
#--smalt_y .90 \
#-m 0 \
#-mm 15 \

# run 7 same as run 6 but with all input files

# run 8 same parameters as 7 and 6 but with the input files with reads <50bp removed

# run 9 same params as 6,7 & 8 with each of the 3 input files that are repeats of the same

# run 10 same again but running on the merged 3 files

# run 11 repeat of the parameters of run 5 but with the merged fastq file
