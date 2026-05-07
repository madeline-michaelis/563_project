#!/bin/bash
#Assign arguments
IQTREE_XML="$1"
PARS_XML="$2"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S") #add timestamp to differentiate files

echo "  Phylogenetic Tree Comparison"
echo "  IQ-TREE:    $IQTREE_XML"
echo "  Parsimony:  $PARS_XML"

#Call upon R script with arguments as input
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

#only include shared tips
shared    <- intersect(tree_iq$tip.label, tree_pars$tip.label)
only_iq   <- setdiff(tree_iq$tip.label, tree_pars$tip.label)
only_pars <- setdiff(tree_pars$tip.label, tree_iq$tip.label)

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

if (cid < 0.2) {
  interp <- "Good agreement between methods"
} else if (cid < 0.4) {
  interp <- "Moderate disagreement between methods"
} else {
  interp <- "Substantial disagreement between methods"
}

#save results
results_out <- paste0("tree_distance_results_", timestamp, ".txt")
sink(results_out)
cat("Phylogenetic Tree Comparison Results\n")

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

echo "Data saved! Output files:"
echo "  tree_distance_results.txt  - Distance metrics summary"
echo "  tree_comparison.pdf        - Cophylo plot"
