#!/bin/bash

# How to use with fasta files:
# ./align_mafft.sh input.fasta
# ./align_mafft.sh *.fasta

for infile in "$@"; do
    base=$(basename "$infile" .fasta)

    cleanfile="${base}_clean.fasta"
    proteinfile="${base}_protein.fasta"
    alignedfile="${base}_protein_aligned.fasta"

    echo "Processing $infile ..."

    #Clean headers to remove weird JSON formatting if any
    awk '{if(/^>/){print $1}else{print $0}}' "$infile" > "$cleanfile"
    echo "Headers cleaned → $cleanfile"

    ️⃣#Translate CDS to protein sequence if needed
    seqkit translate --trim "$cleanfile" > "$proteinfile"
    echo "Translated → $proteinfile"

    #Align protein sequences with MAFFT
    mafft --auto "$proteinfile" > "$alignedfile"
    echo "Aligned protein file created → $alignedfile"

    echo "Done with $infile"

done
