#!/bin/bash
# Laura Dean
# 23/9/26

# trying to convert the gff provided by microbesNG to fit the .fasta version of the assembly
cd /gpfs01/home/mbzlld/data/bryant/11d3a3246d_20251024_Bryant1L/my_assembly_edits

##################################
# check contig names in assemblies
grep ">" 323630L_Photorhabduskhanii.fna
#>contig_1 [gcode=11] [topology=linear]
#>contig_2 [gcode=11] [topology=linear]

grep ">" 323630L_Photorhabduskhanii.fasta
#>contig_2_circular_Y_length_114751_cov_19
#>contig_1_circular_Y_length_5217644_cov_48

##################################
# check contig lengths in assemblies
conda activate samtools1.24
samtools faidx 323630L_Photorhabduskhanii.fna
cut -f1,2 323630L_Photorhabduskhanii.fna.fai
#contig_1	114751
#contig_2	5217644

samtools faidx 323630L_Photorhabduskhanii.fasta
cut -f1,2 323630L_Photorhabduskhanii.fasta.fai
#contig_2_circular_Y_length_114751_cov_19	114751
#contig_1_circular_Y_length_5217644_cov_48	5217644
conda deactivate

##################################
# first remove the fasta section from the gff
sed '/^##FASTA$/,$d' 323630L_Photorhabduskhanii.gff > 323630L_Photorhabduskhanii_noFA.gff

##################################
# then check the contig names
grep -v "^#" 323630L_Photorhabduskhanii_noFA.gff | awk '{print $1}' | sort -u
#contig_1
#contig_2

# and contig lengths
grep "##sequence-region" 323630L_Photorhabduskhanii_noFA.gff
##sequence-region contig_1 1 114751
##sequence-region contig_2 1 5217644

# so the gff is defo for the .fna assembly version
# in the two fasta files the short plasmid is always first 
# but in .fna its called contig_1 and in .fasta its called contig_2_circular_Y_length_114751_cov_19

sed 's/contig_2/battybattybear/g' 323630L_Photorhabduskhanii_noFA.gff > tmp.gff
sed -i 's/contig_1/contig_2_circular_Y_length_114751_cov_19/g' tmp.gff
sed -i 's/battybattybear/contig_1_circular_Y_length_5217644_cov_48/g' tmp.gff && mv tmp.gff 323630L_Photorhabduskhanii_for_fasta.gff

# Great I think the GFF matches the .fasta assembly perfectly now
# now just convert to embl format
conda activate embl
EMBLmyGFF3 323630L_Photorhabduskhanii_for_fasta.gff 323630L_Photorhabduskhanii.fasta \
        --data_class STD \
        --topology linear \
        --molecule_type "genomic DNA" \
        --transl_table 1 \
        --species 'Photorhabdus khanii' \
        --locus_tag PKHAN \
        --project_id Bryant \
        --rg XXX \
        --strain ? \
        -o 323630L_Photorhabduskhanii.fasta.embl

# the embl conversion tool is an idiot and swaps the contig order so contig_1 is first so reverse them
awk '
BEGIN { RS="//\n"; ORS="//\n" }
NR==2 { first=$0 }
NR==1 { second=$0 }
END { print first; print second }
' 323630L_Photorhabduskhanii.fasta.embl > 323630L_Photorhabduskhanii.fasta.contig2_first.embl

# check the order of the ID and AC lines in the new file
grep '^ID ' 323630L_Photorhabduskhanii.fasta.contig2_first.embl
#ID   XXX; XXX; linear; genomic DNA; STD; XXX; 114751 BP.
#ID   XXX; XXX; linear; genomic DNA; STD; XXX; 5217644 BP.

grep '^AC \*' 323630L_Photorhabduskhanii.fasta.contig2_first.embl
#AC * _contig_2_circular_Y_length_114751_cov_19
#AC * _contig_1_circular_Y_length_5217644_cov_48

# ok i think all good now :)

# adding a part to swap the order of contigs in the fixed gfa to match the fata where swapped them for Vicky
awk '
/^##/ {
    file = sprintf("part_%03d.txt", ++n)
}
file {
    print > file
}
' 323630L_Photorhabduskhanii_for_fasta.gff

cat part_001.txt part_002.txt part_004.txt part_003.txt > 323630L_Photorhabduskhanii_for_fasta_rev_order.gff

rm part_0*



