#phylo comparision
options(repos = c(CRAN = "https://cran.r-project.org"))

install.packages("phytools")
library(phytools)
install.packages("XML")
library(XML)
BiocManager::install("treeio")
library(treeio)
library(ape)

tree_iq <- as.phylo(read.phyloxml("chsB_iqtree.xml"))
tree_pars <- as.phylo(read.phyloxml("chsB_phangorn.xml"))

# Only keep species shared between both trees first
shared <- intersect(tree_iq$tip.label, tree_pars$tip.label)
tree_iq_trimmed <- keep.tip(tree1, shared)
tree_pars_trimmed <- keep.tip(tree2, shared)

# Unroot both trees first
tree_iq_un <- unroot(tree_iq_trimmed)
tree_pars_un <- unroot(tree_pars_trimmed)

multiRF(c(tree1_un, tree2_un))

#calculate normalized RF value
n <- length(tree1_un$tip.label)
max_rf <- 2 * (n - 3)
rf_normalized <- 110 / max_rf
rf_normalized

#Get plot
phy_object <- cophylo(as.phylo(chsB_iqtree), as.phylo(chsB_phangorn), rotate=TRUE)

plot(phy_object,
     link.type = "curved",
     link.col = make.transparent("blue", 0.3),  # transparent lines help a lot
     link.lwd = 1,
     fsize = 0.4)   # smaller font for big trees

#save plot
install.packages("TreeDist")
library(TreeDist)

# Clustering information distance
ClusteringInfoDistance(tree_iq_un, tree_pars_un, normalize = TRUE)

# Matching split distance
MatchingSplitDistance(tree_iq_un, tree_pars_un)

# Get all metrics at once
TreeDistance(tree_iq_un, tree_pars_un)
