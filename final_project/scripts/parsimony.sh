#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RSCRIPT="${SCRIPT_DIR}/parsimony_tree.R"

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

echo "Building parsimony tree from $INPUT ..."
Rscript "$RSCRIPT" \
  --input "$INPUT" \
  --type "$TYPE" \
  --out "${INPUT%.fasta}_parsimony"

echo "Done"
