# 563_project: Phylogenetic Inference Pipeline Instructions
Purpose: Share a reproducible pipeline for multi-gene phylogenetic analysis of protein sequences, implementing both Maximum Parsimony (MP) and Maximum Likelihood (ML) approaches with downstream tree comparison.

# Workflow:
<img width="180" height="376" alt="image" src="https://github.com/user-attachments/assets/8a94a8af-c83b-4ecc-9771-bf7d86c658fc" />

## Overview

This pipeline takes raw nucleotide FASTA sequences as input and produces:
- Multiple sequence alignments (protein-level)
- Maximum Parsimony trees (Phangorn/R) with bootstrap support
- Maximum Likelihood trees (IQ-TREE) with bootstrap support
- Quantitative and visual comparisons between MP and ML topologies

## Dependencies

### Command-line tools
| Tool | Version | Purpose |
|------|---------|---------|
| [seqkit] | v2.12.0 | Sequence cleaning and translation |
| [MAFFT] | v7.526 | Multiple sequence alignment |
| [TrimAL] | v3.0 | Alignment trimming |
| [IQ-TREE] | v3.0.1 | Maximum likelihood inference |

### R packages
| Package | Purpose |
|---------|---------|
| `phangorn` | Maximum parsimony tree inference |
| `ape` | Tree storage |
| `treeio` | Tree file parsing |
| `phytools` | Cophyloplot visualization |
| `TreeDist` | Tree distance metrics |

Install R packages with:
```r
install.packages(c("phangorn", "ape", "phytools", "TreeDist"))
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install("treeio")
```

## Data Acquisition

Orthologous protein sequences were sourced as follows:

1. Query genes of interest were identified.
2. Amino acid sequences were retrieved and submitted to [UniProt](https://www.uniprot.org/) to obtain protein IDs
3. Protein IDs were searched in [OrthoFinder](https://www.orthofinder.org/).
4. Top orthologous hits were downloaded as concatenated `.fasta` files.

Input sequences should be placed in the `data/original_seqs/` directory, one file per gene, named `<gene_name>.fasta`.

---

## Pipeline

### Step 1: Sequence Cleaning and Alignment

```bash
bash scripts/msa_align.sh <gene>.fasta
```
- Removes odd formatting from the input FASTA
- Translates nucleotide sequences to protein using `seqkit translate`
- Saves translated sequences to the working folder
- Runs MAFFT alignment and saves output to `<gene>_aligned.fasta`

### Step 2: Alignment Trimming

```bash
bash scripts/trimAL.sh <gene>_aligned.fasta
```

This trims the aligned sequences to a consistent length using TrimAL. Output saved to `<gene>_trimmed.fasta`. Trimming is required prior to parsimony inference, as Phangorn requires equal-length input sequences.

### Step 3: Maximum Parsimony Tree

```bash
bash scripts/parsimony.sh <gene>_trimmed.fasta
```

- Reads the trimmed alignment into a `phyDat` object using `phangorn`
- Builds an initial neighbor-joining tree using `ape`.
- Runs NNI optimization followed by parsimony ratchet search to find the most parsimonious topology.
- Outputs the tree as `<gene>.tre`

### Step 4: Maximum Likelihood Tree

```bash
bash scripts/iqtree.sh <gene>_aligned.fasta
```

- ModelFinder Plus (`-m MFP`) for automatic substitution model selection
- Ultrafast bootstrapping with 1000 replicates (`-B 1000`), which is adjustable
- Outputs a `.treefile`

### Step 5: Tree Visualization

Trees were visualized and re-rooted using [iTOL v7.5.1](https://itol.embl.de/). Species names were annotated using the automatic NCBI taxonomy assignment. Trees were rooted on the same outgroup. Annotated trees were exported as `phylo.xml`.

### Step 6: Tree Comparison

```bash
bash scripts/tree_comparisons.sh <gene>_ml.xml <gene>_mp.xml
```

- Reads, trims, and unroots both trees using `treeio` and `ape`
- Calculates pairwise distances using `TreeDist`:
  - Clustering Information Distance (normalized)
  - Matching Split Distance
  - Tree Distance
- Generates a cophyloplot using `phytools::cophylo()` with `rotate = TRUE`

## Important Notes

- Keep copies of data from each step.
- In this repository, the fks1 and ags1 sequences and data from each step are preserved so you can check your work as you go along.
- In this repository, there is a folder with all 'scripts' but they are also inside their respective folders. It is recommended you clone the entire repo, then run the scripts that are within the folders so your data gets input and ouput within that given folder.
- All scripts assume input sequences are AA (protein) FASTA format after translation
- MAFFT assumes all input sequences are homologous and does not account for genomic rearrangements or domain shuffling
- MP assumes sites evolve independently and that convergent evolution, reversals, and parallel mutations are rare; it performs best when evolutionary rates are similar across branches
- ML inference via IQ-TREE is computationally intensive; runtime scales with sequence length and number of taxa

Thank you!
