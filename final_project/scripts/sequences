#!/bin/bash

# How to use with fasta files:
# ./align_mafft.sh input.fasta
# ./align_mafft.sh *.fasta

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <fasta_file1> [fasta_file2 ...]"
    exit 1
fi

for infile in "$@"; do
    base=$(basename "$infile" .fasta)

    cleanfile="${base}_clean.fasta"
    proteinfile="${base}_protein.fasta"
    alignedfile="${base}_protein_aligned.fasta"

    echo "Processing $infile ..."

    #Clean headers to remove weird JSON
    awk '{if(/^>/){print $1}else{print $0}}' "$infile" > "$cleanfile"
    echo "Headers cleaned → $cleanfile"

    ️⃣#ranslate CDS to protein sequence
    seqkit translate --trim "$cleanfile" > "$proteinfile"
    echo "Translated → $proteinfile"

    #Align protein sequences
    mafft --auto "$proteinfile" > "$alignedfile"
    echo "Aligned protein file created → $alignedfile"

    echo "Done with $infile"
    echo "----------------------------------"

done

