#File for documentation of project work
# Day 1 (2/10/26): Description of dataset
#My dataset includes 115 species and 6 genes conserved across filamentous fungi in the genus Aspergillus. These genes are important in Aspergillus physiology, but it is unknown whether they are diverged in pathogenic vs non-pathogenic Aspergilli. By determining the relative relationships between Aspergilli using these genes and comparing the result to groups that are pathogens (and within that, what type of pathogen), I can infer whether they may be important to the pathogenic function and resistance of the fungus.
#I accessed my data from Orthodb.org, by searching genes I've identified in literature searches or from my research that are important in physiology and/or antifungal defense.
#Specifically, the genes are hexA (WB coding protein), Fks-1 (beta-glucan synthase), agsA (alpha glucan synthase), ERG11 (ergosterol making gene, target of antifungal azoles), chitin synthase 2/B, and sidB (septation protein).

# Cleaning data:
#The data consists of assembled gene sequences, meaning it is pre-organized and does not require FastQC or phyluce. However, I am going to clean my sequence in the following ways:
1. Remove sequences with lots of Ns (ambiguous bases)
2. Remove duplications in one species
3. Confirm that all sequences have reasonable length

#To do this I will use seqkit, which is a tool that allows you to see the stats of your sequences (length), identify sequences with Ns and duplicates. This will help me clean my data.

# 2/17/26 HW: MSA
1. Selected final gene set: WB, LAH, sppA, chsB, ags1, fks1.
2. Downloaded from OrthoDB (find AA sequence in fungiDB, put into UNIPROT, put gene name into OrthoFinder. All had 100 -120 hits out of 115 spp.
3. Made sh script (msa_align.sh) that will take sequence, remove weird JSON formatting that came with it from OrthoDB, and convert it to protein sequence, then run mafft -auto on it.
   i. At first I wanted nucleotides, but this resulted in a lot of variance in the viewer. I found that codons can be better since they are more conserved.
   ii. I checked 2 results in the viewer and they looked much better after being translated to protein.
   iii. I reorganized the files and structure and uploaded aligned protein seqs and script to github.
4. I updated my notes.

Notes from talking with Ben:
- After mafft use trimaligned to trim alignments
______________________________________________________
**3/3/26 HW: Distance-based and parsimony-based tree methods**
- First: too many genes, decided I am dropping LAH, ChsB, and keeping fks1, ags1, sppA, and WB.
- I made my reproducible script for these four gene sequence sets. I had to alter the way I used phangorn, because mine are AA sequences instead of nucleotides. I hope this is ok.
- The plots seemed to work, they looked good. one had a strange box shape, but I think that is because it didn't have room. One issue with these plots in R is that its hard to fit everything into one image, which is something I should read more about how to optimize. They still seemed to work, though.
- I decided to make first two functions, one that will compute each tree for me, then I decided to make a loop that you can essentially feed a list of filenames (fastas) and it will use both functions on the file and then save the file as a pdf in a folder of your choice. This should make everything faster for next time.
- I will now rearrange my directory because it doesn't make sense currently. It is main/sequences/scripts/etc, when scripts should be on the same level as sequences I think.
