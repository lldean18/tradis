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


# run on Jack's data
srun --partition defq --cpus-per-task 4 --mem 15g --time 12:00:00 --pty bash
source $HOME/.bash_profile
conda activate biotradis
cd /gpfs01/home/mbzlld/data/tradis

bacteria_tradis \
-v \
--smalt \
--smalt_r 0 \
-m 0 \
-f files.txt \
-t CGAGCTCGAATTCATCGATGATGGTTGAGATGTGTATAAGAGACAG \
-r reference/GCF_000750555.1_ASM75055v1_genomic.fna


