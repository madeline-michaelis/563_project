#!/bin/bash

IQTREE_XML="$1"
PARS_XML="$2"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "  Phylogenetic Tree Comparison"
echo "  IQ-TREE:    $IQTREE_XML"
echo "  Parsimony:  $PARS_XML"
echo "============================================"

#R script
Rscript - "$IQTREE_XML" "$PARS_XML" "$TIMESTAMP" <<'EOF'

#Use args
args <- commandArgs(trailingOnly = TRUE)
iqtree_file <- args[1]
pars_file   <- args[2]
timestamp   <- args[3]

library(ape)
library(phytools)
library(treeio)
library(TreeDist)

#get trees
cat("\nLoading trees...\n")
tree_iq   <- as.phylo(read.phyloxml(iqtree_file))
tree_pars <- as.phylo(read.phyloxml(pars_file))

cat(sprintf("  IQ-TREE tips:    %d\n", length(tree_iq$tip.label)))
cat(sprintf("  Parsimony tips:  %d\n", length(tree_pars$tip.label)))

#only include shared tips
shared    <- intersect(tree_iq$tip.label, tree_pars$tip.label)
only_iq   <- setdiff(tree_iq$tip.label, tree_pars$tip.label)
only_pars <- setdiff(tree_pars$tip.label, tree_iq$tip.label)

#report shared tips amounts
cat(sprintf("\nShared taxa:          %d\n", length(shared)))
if (length(only_iq) > 0)
  cat(sprintf("Only in IQ-TREE:      %d  (%s ...)\n", length(only_iq), paste(head(only_iq, 3), collapse=", ")))
if (length(only_pars) > 0)
  cat(sprintf("Only in Parsimony:    %d  (%s ...)\n", length(only_pars), paste(head(only_pars, 3), collapse=", ")))

#trim trees to shared tips
tree_iq_trim   <- keep.tip(tree_iq,   shared)
tree_pars_trim <- keep.tip(tree_pars, shared)

#unroot trees
tree_iq_un   <- unroot(tree_iq_trim)
tree_pars_un <- unroot(tree_pars_trim)

#calculate TreeDist metrics and save to variables
cat("\n--- Tree Distance Metrics ---\n")
cid  <- ClusteringInfoDistance(tree_iq_un, tree_pars_un, normalize = TRUE)
msd  <- MatchingSplitDistance(tree_iq_un, tree_pars_un)
td   <- TreeDistance(tree_iq_un, tree_pars_un)

cat(sprintf("  Clustering Info Distance (normalized): %.3f\n", cid))
cat(sprintf("  Matching Split Distance:               %.3f\n", msd))
cat(sprintf("  Tree Distance:                         %.3f\n", td))

if (cid < 0.2) {
  interp <- "Good agreement between methods"
} else if (cid < 0.4) {
  interp <- "Moderate disagreement between methods"
} else {
  interp <- "Substantial disagreement between methods"
}
cat(sprintf("  Interpretation: %s\n", interp))

#save results
results_out <- paste0("tree_distance_results_", timestamp, ".txt")
sink(results_out)
cat("Phylogenetic Tree Comparison Results\n")
cat("=====================================\n")
cat(sprintf("IQ-TREE file:                          %s\n", iqtree_file))
cat(sprintf("Parsimony file:                        %s\n", pars_file))
cat(sprintf("Shared taxa:                           %d\n", length(shared)))
cat(sprintf("Clustering Info Distance (normalized): %.3f\n", cid))
cat(sprintf("Matching Split Distance:               %.3f\n", msd))
cat(sprintf("Tree Distance:                         %.3f\n", td))
cat(sprintf("Interpretation:                        %s\n", interp))
sink()
cat(sprintf("\nResults saved to: %s\n", results_out))

#Phylogenies plot with Cophylo
cat("\nGenerating cophylo comparison plot...\n")
obj <- cophylo(tree_iq_trim, tree_pars_trim, rotate = TRUE)

plot_file <- paste0("tree_comparison_", timestamp, ".pdf")
pdf(plot_file, width = 14, height = 20)

plot(obj,
     link.type  = "curved",
     link.col   = make.transparent("blue", 0.3),
     link.lwd   = 1.5,
     fsize      = 0.4,
     pts        = FALSE)

title(main = "IQ-TREE vs Parsimony Comparison",
      cex.main = 1.2)
mtext("IQ-TREE",   side = 3, adj = 0.15, cex = 1, font = 2)
mtext("Parsimony", side = 3, adj = 0.85, cex = 1, font = 2)
mtext(sprintf("Clustering Info Distance (normalized) = %.3f", cid),
      side = 1, cex = 0.9, col = "grey40")

dev.off()
cat(sprintf("Comparison plot saved to: %s\n", plot_file))
cat("\nDone!\n")

EOF

echo "============================================"
echo "Data saved! Output files:"
echo "  tree_distance_results.txt  - Distance metrics summary"
echo "  tree_comparison.pdf        - Cophylo plot"
echo "============================================"
