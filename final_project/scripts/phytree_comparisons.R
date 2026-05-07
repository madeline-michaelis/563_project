#R script called by tree_comparisons.sh to compare two phylogenetic trees
options(repos = c(CRAN = "https://cran.r-project.org"))

#install needed packages for you
install.packages("phytools")
library(phytools)
install.packages("XML")
library(XML)
BiocManager::install("treeio")
library(treeio)
library(ape)

#reads the xml files as phylo tree files
tree_iq <- as.phylo(read.phyloxml("chsB_iqtree.xml"))
tree_pars <- as.phylo(read.phyloxml("chsB_phangorn.xml"))

# Only keeps species shared between both trees first
shared <- intersect(tree_iq$tip.label, tree_pars$tip.label)
tree_iq_trimmed <- keep.tip(tree1, shared)
tree_pars_trimmed <- keep.tip(tree2, shared)

# Unroot both trees
tree_iq_un <- unroot(tree_iq_trimmed)
tree_pars_un <- unroot(tree_pars_trimmed)

multiRF(c(tree1_un, tree2_un))

#calculate normalized RF value
n <- length(tree1_un$tip.label)
max_rf <- 2 * (n - 3)
rf_normalized <- 110 / max_rf
rf_normalized

#Get plot with phytree's cophylo
phy_object <- cophylo(as.phylo(chsB_iqtree), as.phylo(chsB_phangorn), rotate=TRUE) #rotate helps compare the two trees

plot(phy_object,
     link.type = "curved",
     link.col = make.transparent("blue", 0.3), #change colors
     link.lwd = 1,
     fsize = 0.4)   # change font size

#install treedist
install.packages("TreeDist")
library(TreeDist)

# Get Clustering information distance
ClusteringInfoDistance(tree_iq_un, tree_pars_un, normalize = TRUE)

# Get Matching split distance
MatchingSplitDistance(tree_iq_un, tree_pars_un)

# Get all metrics at once
TreeDistance(tree_iq_un, tree_pars_un)
