#!/bin/bash
#script to run iqtree on an input sample; type input as "bash iqtree.sh filename
iqtree -s "$1" -pre "$(dirname "$1")/$(basename "$1" | cut -d. -f1)"
echo "iq tree completed"

#Description of algorithm:
#IQ-tree is a phylogenetic inference software that reconstructs evolutionary trees based on input aligned DNA/protein sequences.
#It compares how sequence alignments differ, tests evolutionary models to find which one best explains the mutations, finds tree topology that best fits the model, and creeates a phylogenetic tree.

#Assumptions of IQ-Tree
- Homogenous evolution, that all sequences evolve at similar rates; independent sites, that each nt or AA evolves independently
- Appropriate substition: your model accurately represents how evolution works in the dataset
- No recombination among sequences
- One tree can explain all data
- Forward and backward mutations appear at predictable rates
#Limitations of IQ-Tree
- Can be slow with larger datasets
- Requires a high memory usage
- Cannot account for recombination, gene flow, varying evolutionary rates
- Does not handle ambiguous sequences nicely

#Since my datasets are comparatively not too large, I selected this model for its efficiency and ease of use.

