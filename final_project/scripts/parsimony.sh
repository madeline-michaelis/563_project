#!/usr/bin/env bash
#run to call parsimony_tree.R
#Usage: bash parsimony.sh filename
#Filename should be fasta of multiple sequence alignment of interest, that has been trimmed with TrimAL.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RSCRIPT="${SCRIPT_DIR}/parsimony_tree.R" #reference script

INPUT="$1"
TYPE="${2:-AA}"

echo "Checking R packages..."
Rscript -e '
  pkgs <- c("phangorn", "ape")
  missing <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]
  if (length(missing) > 0) {
    message("Installing missing packages: ", paste(missing, collapse = ", "))
    install.packages(missing, repos = "https://cloud.r-project.org", quiet = TRUE)
  }
'
#installs packages if missing

#calls R script
echo "Building parsimony tree from $INPUT ..."
Rscript "$RSCRIPT" \
  --input "$INPUT" \
  --type "$TYPE" \
  --out "${INPUT%.fasta}_parsimony"

echo "Done"
