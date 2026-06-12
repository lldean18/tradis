#!/bin/bash
# 22/5/26

# script to run biotradis on various versions of the filtered fastq files

srun --partition defq --cpus-per-task 4 --mem 15g --time 06:00:00 --pty bash


# setup env
source $HOME/.bash_profile
conda activate biotradis


# run bacteria tradis on the test dataset
srun --partition defq --cpus-per-task 4 --mem 15g --time 06:00:00 --pty bash
cd /gpfs01/home/mbzlld/data/tradis/reference
bacteria_tradis \
-v \
--smalt \
--smalt_r 0 \
-m 0 \
-f files.txt \
-t TAAGAGACAG \
-r S_typhimurium_ref.fasta


### run on Jack's data ###
# setup env
srun --partition defq --cpus-per-task 4 --mem 15g --time 12:00:00 --pty bash
source $HOME/.bash_profile
conda activate biotradis
cd /gpfs01/home/mbzlld/data/tradis
# make the files.txt file
\ls trimmed_fastqs/2_cutadapt/*.fq.gz > files.txt

bacteria_tradis \
-v \
--smalt \
--smalt_r 0 \
-m 0 \
-f files.txt \
-t CGAGCTCGAATTCATCGATGATGGTTGAGATGTGTATAAGAGACAG \
-r reference/GCF_000750555.1_ASM75055v1_genomic.fna

# ok great, think the input files are as good as they can be. Now to finetune the tradis parameters

# try with more relaxed parameters
# (not run yet)
bacteria_tradis \
-v \
--smalt \
--smalt_r 0 \
--smalt_k 10 \
--smalt_s 1 \
--smalt_y .95 \
-m 0 \
-mm 3 \
-f files.txt \
-t CGAGCTCGAATTCATCGATGATGGTTGAGATGTGTATAAGAGACAG \
-r reference/GCF_000750555.1_ASM75055v1_genomic.fna



