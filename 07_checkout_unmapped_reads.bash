#!/bin/bash
# 11/6/26

# script to pull out the remaining reads that are >50bp and are
# still not mapping and have a look at them

#SBATCH --job-name=extract_unmapped
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5g
#SBATCH --time=2:00:00
#SBATCH --output=slurm-%x-%j.out



# setup env
source $HOME/.bash_profile
cd /gpfs01/home/mbzlld/data/tradis/biotradis8


# extract the unmapped read ids
#samtools view -f 4 BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1.fq.gz.mapped.bam |
#cut -f1 | sort -u > unmapped_ids.txt


conda activate samtools1.22
samtools fastq -f 4 BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1.fq.gz.mapped.bam > unmapped.fastq
conda deactivate

conda activate seqkit
seqkit fq2fa unmapped.fastq > unmapped.fasta
conda deactivate

rm unmapped.fastq




