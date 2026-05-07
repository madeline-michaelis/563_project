Please read README for instructions!

# File for documentation of project work
**Day 1 (2/10/26): Description of dataset**
#My dataset includes 115 species and 6 genes conserved across filamentous fungi in the genus Aspergillus. These genes are important in Aspergillus physiology, but it is unknown whether they are diverged in pathogenic vs non-pathogenic Aspergilli. By determining the relative relationships between Aspergilli using these genes and comparing the result to groups that are pathogens (and within that, what type of pathogen), I can infer whether they may be important to the pathogenic function and resistance of the fungus.

#I accessed my data from Orthodb.org, by searching genes I've identified in literature searches or from my research.
______________________________________________________
# Cleaning data:
#The data consists of assembled gene sequences, meaning it is pre-organized and does not require FastQC or phyluce. However, I am going to clean my sequence in the following ways:
1. Remove sequences with lots of Ns (ambiguous bases)
2. Remove duplications in one species
3. Confirm that all sequences have reasonable length

#To do this I will use seqkit, which is a tool that allows you to see the stats of your sequences (length), identify sequences with Ns and duplicates. This will help me clean my data.
______________________________________________________
**2/17/26 HW: MSA**
1. Downloaded from OrthoDB (find AA sequence in fungiDB, put into UNIPROT, put gene name into OrthoFinder. All had 100 -120 hits out of 115 spp.
2. Made sh script (msa_align.sh) that will take sequence, remove weird JSON formatting that came with it from OrthoDB, and convert it to protein sequence, then run mafft -auto on it.
   i. At first I wanted nucleotides, but this resulted in a lot of variance in the viewer. I found that codons can be better since they are more conserved.
   ii. I checked 2 results in the viewer and they looked much better after being translated to protein.
   iii. I reorganized the files and structure and uploaded aligned protein seqs and script to github.
4. I updated my notes.

______________________________________________________
**3/3/26 HW: Distance-based and parsimony-based tree methods**
- I made my reproducible script for these protein sequence sets. I had to alter the way I used phangorn, because mine are AA sequences instead of nucleotides.
- The plots seemed to work, they looked good.
- I decided to make first two functions, one that will compute each tree for me, then I decided to make a loop that you can essentially feed a list of filenames (fastas) and it will use both functions on the file and then save the file as a pdf in a folder of your choice. This should make everything faster for next time.
- I will now rearrange my directory because it doesn't make sense currently.

**3/19/26 HW: Phylogeneteic tree construction with IQ-Tree**
- I made a short reproducible script that takes an input file and runs iqtree on it. I am goign to use this on all of my protein aligned fasta sequences.
- I updated the script and pushed it to the github. I also listed assumptions/limitaitons with a descrpitoin of the script.

______________________________________________________
4/21/26 HW: Coalescent Method
- Wrote a script that takes my fastas as inputs, converts them into XML files using BEAUti, then runs BEAST2 on them to create final tree.
- Successfully downloaded BEAST2 and BEAUti
- BEAST2 uses MCMC method and Bayesian analysis which outputs parameter files and many phylogenetic trees
- These trees are compiled into a master tree, the maximum clade compatibility tree that represents the most probably tree topology.
______________________________________________________
5/4/26
- Updated all scripts
- Re-ran on files to check
- Cleaned repo
- Updated README instructions
