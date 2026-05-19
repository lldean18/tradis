#!/bin/bash
# 19/5/26

# script to download data from sharepoint with rclone

#SBATCH --time=24:00:00
#SBATCH --job-name=rclone
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=16g


# setup env
module load rclone-uon/1.65.2

# copy the directory with rclone
rclone --transfers 4 --checkers 4 --bwlimit 100M --onedrive-chunk-size 5M \
--checksum copy Laura:X204SC25034200-Z01-F005/01.RawData ~/data/tradis/rawdata

# Check the directory has copied successfully
rclone check --one-way Laura:X204SC25034200-Z01-F005/01.RawData ~/data/tradis/rawdata

# unload module
module unload rclone-uon/1.65.2

