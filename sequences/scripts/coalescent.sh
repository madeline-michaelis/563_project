#!/usr/bin/env bash
# Purpose: ./run_beast.sh on fastas ex: input1.fasta [input2.fasta ...]
# Requires BEAST2 installed: https://www.beast2.org

set -euo pipefail

for FASTA in "$@"; do
    PREFIX="${FASTA%.*}"
    XML="${PREFIX}.xml"

    echo "Converting $FASTA to XML..."
    beast -beauti -template Standard "$FASTA" -o "$XML"

    echo "Running BEAST..."
    beast "$XML"

    echo "Building summary tree..."
    treeannotator -burnin 10 "${PREFIX}.trees" "${PREFIX}_MCC.tree"
  
    echo "BEAST finished, output: ${PREFIX}_MCC.tree"
done
