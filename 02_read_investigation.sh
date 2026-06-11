#!/bin/bash
# 22/5/26

# script to have an investigate of the raw data

# list the fwd read files
files=( /gpfs01/home/mbzlld/data/tradis/rawdata/BWtacXpress1/BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1.fq.gz
        /gpfs01/home/mbzlld/data/tradis/rawdata/BWtacXpress2/BWtacXpress2_EKDL260002325-1A_23GK55LT4_L5_1.fq.gz
        /gpfs01/home/mbzlld/data/tradis/rawdata/BWtacXpress3/BWtacXpress3_EKDL260002326-1A_23GK55LT4_L5_1.fq.gz
        /gpfs01/home/mbzlld/data/tradis/rawdata/BWtacXpressJB2/BWtacXpressJB2_EKDL260002328-1A_23GK55LT4_L5_1.fq.gz
        /gpfs01/home/mbzlld/data/tradis/rawdata/BWtacXpressJBc/BWtacXpressJBc_EKDL260002327-1A_23GK55LT4_L5_1.fq.gz )

# extract the first 100 reads and convert to fasta format
conda activate seqkit
cd /gpfs01/home/mbzlld/data/tradis/investigating

for f in "${files[@]}"; do
    base=$(basename "$f")
    base=${base%.fq.gz}
    out=${base}_first100.fasta
    seqkit head -n 100 "$f" | seqkit fq2fa > $out
done
conda deactivate


# extract more reads just from the first file to look at
conda activate seqkit
seqkit head -n 1000 /gpfs01/home/mbzlld/data/tradis/rawdata/BWtacXpress1/BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1.fq.gz |
seqkit fq2fa > /gpfs01/home/mbzlld/data/tradis/investigating/BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1_first1000.fasta
conda deactivate


# extract reads from the trimmed fastq to look at
conda activate seqkit
seqkit head -n 100 /gpfs01/home/mbzlld/data/tradis/trimmed_fastqs/2_cutadapt/BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1.fq.gz |
seqkit fq2fa > /gpfs01/home/mbzlld/data/tradis/investigating/BWtacXpress1_EKDL260002324-1A_23GK55LT4_L5_1_first100_trimmed.fasta
conda deactivate



