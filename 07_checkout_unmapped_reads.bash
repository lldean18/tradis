#!/bin/bash
# 11/6/26

# script to pull out the remaining reads that are >50bp and are
# still not mapping and have a look at them

#SBATCH --job-name=extract_unmapped
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=20:00:00
#SBATCH --output=slurm-%x-%j.out



# setup env
source $HOME/.bash_profile
cd /gpfs01/home/mbzlld/data/tradis/biotradis8


# extract unmapped reads as fasta
conda activate samtools1.22
samtools fastq -f 4 BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1.fq.gz.mapped.bam > unmapped.fastq
conda deactivate
conda activate seqkit
seqkit fq2fa unmapped.fastq > unmapped.fasta
conda deactivate
rm unmapped.fastq


# extract unmapped reads >30bp
conda activate seqkit
seqkit seq -m 30 unmapped.fasta > unmapped_30bp_plus.fasta
conda deactivate


# blast those reads
conda activate blast
blastn \
  -query unmapped_30bp_plus.fasta \
  -db nt \
  -remote \
  -max_target_seqs 1 \
  -max_hsps 1 \
  -outfmt "6 qseqid sseqid stitle pident length evalue bitscore" \
  -out top_hits.tsv
conda deactivate



