#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRIMAL="${SCRIPT_DIR}/trimal/trimal"
 
INPUT="$1"
 
echo "Trimming $INPUT ..."
"$TRIMAL" \
  -in "$INPUT" \
  -out "${INPUT%.fasta}_trimmed.fasta" \
  -automated1
 
echo "Done.${INPUT%.fasta}_trimmed.fasta"
