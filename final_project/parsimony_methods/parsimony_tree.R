#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(phangorn)
  library(ape)
})

# Parse arguments
args <- commandArgs(trailingOnly = TRUE)
opts <- list(
  input     = NULL,
  format    = "fasta",
  type      = "AA",
  out       = "parsimony_output",
  bootstrap = TRUE
)

i <- 1
while (i <= length(args)) {
  switch(args[i],
    "--input"        = { i <- i + 1; opts$input  <- args[i] },
    "--format"       = { i <- i + 1; opts$format <- args[i] },
    "--type"         = { i <- i + 1; opts$type   <- args[i] },
    "--out"          = { i <- i + 1; opts$out    <- args[i] },
    "--no-bootstrap" = { opts$bootstrap <- FALSE },
    "--help"         = {
      cat("Usage: Rscript parsimony_tree.R --input <alignment> [options]\n")
      quit(status = 0)
    }
  )
  i <- i + 1
}

cat("Maximum Parsimony Tree Builder\n")

cat("Reading alignment...\n")
# ambiguity="-" tells phangorn to treat gap characters as ambiguous (valid for trimmed alignments)
aln <- read.phyDat(file = opts$input, format = opts$format, type = opts$type)
ntax  <- length(aln)
nsites <- ncol(as.character(aln))  # fix: as.character returns a matrix; use ncol()
cat(sprintf("  %d taxa, %d sites\n", ntax, nsites))

cat("Computing NJ starting tree...\n")
dm      <- if (opts$type == "DNA") dist.ml(aln, model = "JC") else dist.ml(aln)
nj_tree <- NJ(dm)

cat("Running parsimony search (pratchet)...\n")
mp_tree <- pratchet(
  data  = aln,
  start = nj_tree,
  maxit = 1000,
  minit = 100,
  k     = 10,
  trace = 0
)

# If pratchet returns multiple equally-parsimonious trees, pick the best
if (inherits(mp_tree, "multiPhylo")) {
  scores   <- sapply(mp_tree, function(t) parsimony(t, aln))
  best_idx <- which.min(scores)
  mp_tree  <- mp_tree[[best_idx]]
}

# Bootstrap (only when --no-bootstrap was NOT passed)
if (opts$bootstrap) {
  cat("Running bootstrap (bs=1000)...\n")
  bs_trees <- bootstrap.phyDat(
    aln,
    FUN = function(x) {
      pratchet(x, start = nj_tree, maxit = 100, minit = 10, k = 5, trace = 0)
    },
    bs = 1000
  )
  mp_tree <- transferBootstrap(mp_tree, bs_trees)
  cat("Bootstrap analysis complete\n")
}

mp_tree <- unroot(mp_tree)
mp_tree <- acctran(mp_tree, aln)
mp_tree$edge.length[mp_tree$edge.length < 0] <- 0

cat("Writing outputs...\n")

newick_file  <- paste0(opts$out, ".tre")
write.tree(mp_tree, file = newick_file)

nexus_file <- paste0(opts$out, ".nex")
write.nexus(mp_tree, file = nexus_file)

summary_file <- paste0(opts$out, "_summary.txt")
sink(summary_file)
cat(sprintf("Taxa:  %d\nSites: %d\nParsimony score: %d\n",
            ntax, nsites, parsimony(mp_tree, aln)))
sink()

cat("Done\n")
