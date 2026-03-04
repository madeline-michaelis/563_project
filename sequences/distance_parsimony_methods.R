#Install required packages
install.packages("ape")
install.packages("phangorn")

#load in packages
library(ape)
library(phangorn)

#Make functions that will make distance, parsimony tree for any given input filename:

##Function to compute distance-based tree:
distance_tree <- function(filename) {
  # Extract gene name from filename
  gene_name <- sub("_.*", "", filename)
  aa <- read.phyDat(filename, format="fasta", type="AA") # Read amino acid sequences
  dist_matrix <- dist.ml(aa)
  tree_nj <- NJ(dist_matrix)
  plot(tree_nj, main=paste(gene_name, "Distance Tree (NJ)"), cex = 0.3)}

##example implementation
distance_tree("fks1_cds_protein_aligned.fasta")

##Function to compute parsimony tree:
parsimony_tree <- function(filename) {
  # Extract gene name from filename
  gene_name <- sub("_.*", "", filename) #extracts first part of filename before first _
  aa <- read.phyDat(filename, format="fasta", type="AA") # Read amino acid sequences
  dist_matrix <- dist.ml(aa) #make distance matrix
  tree_nj <- NJ(dist_matrix) #make tree
  tree_mp <- optim.parsimony(tree_nj, aa) #make optimal parsimony
  plot(tree_mp, main=paste(gene_name, "Parsimony tree"), cex = 0.3) } #plot
  
##example implementation
parsimony_tree("fks1_cds_protein_aligned.fasta")

# Code to loop over files, generate trees, and save plots in new directory
files <- c("fks1_cds_protein_aligned.fasta", "ags1_cds_protein_aligned.fasta", "wb_cds_protein_aligned.fasta", "sppa_cds_protein_aligned.fasta")

#create folder to store your images
dir.create("tree_images")

# Loop over files, generate trees, and save plots in new directory
for (filename in files) {
  gene_name <- sub("_.*", "", filename) #for naming
  #distance
  pdf(file.path("tree_images", paste0(gene_name, "_dist_tree.pdf")), width=7, height=7)  # start saving plot
  distance_tree(filename)  # distance_tree function plots
  dev.off()  # finish saving
  #parsimony
  pdf(file.path("tree_images", paste0(gene_name, "_parsi_tree.pdf")), width=7, height=7) #start saving
  parsimony_tree(filename)  # parsimony_tree function plots
  dev.off() #finish saving
  }