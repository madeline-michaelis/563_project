#!/bin/bash
#script to run iqtree on an input sample; input should be iqtree.sh "filename"
iqtree -s "$1" -pre "$(dirname "$1")/$(basename "$1" | cut -d. -f1)"
echo "iq tree completed"
