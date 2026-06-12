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
run=8
mkdir /gpfs01/home/mbzlld/data/tradis/biotradis$run
cd /gpfs01/home/mbzlld/data/tradis/biotradis$run


# make the files.txt file
# for now just work on the first file for testing
#echo "/gpfs01/home/mbzlld/data/tradis/trimmed_fastqs/2_cutadapt/BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1.fq.gz" > files.txt
#ls /gpfs01/home/mbzlld/data/tradis/trimmed_fastqs/2_cutadapt/*.fq.gz > files.txt
echo "/gpfs01/home/mbzlld/data/tradis/trimmed_fastqs/3_cutadapt/BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1.fq.gz" > files.txt

# ok great, think the input files are as good as they can be. Now to finetune the tradis parameters
# try with more relaxed parameters
bacteria_tradis \
-v \
--smalt \
--smalt_r 0 \
--smalt_k 10 \
--smalt_s 1 \
--smalt_y .90 \
-m 0 \
-mm 15 \
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

