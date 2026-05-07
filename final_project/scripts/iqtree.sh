#!/bin/bash
#script to run iqtree on an input sample; 
#Usage: bash iqtree.sh filename

iqtree -s "$1" -pre "$(dirname "$1")/$(basename "$1" | cut -d. -f1)" -B 1000 #adjust bootstrap value as needed -B ___
echo "iq tree completed"
