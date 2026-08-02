---
title: "References and tool credits"
nav_order: 15
---

# References and tool credits

## Tools used to generate course data (instructor side)

These tools were used by the course designer to create the alien
genomic dataset, tutorial data, and Docker image. Students do not
interact with these tools directly.

---

### Genome simulation

**Badread** (v0.2.0 or later)
Wick RR. (2019). Badread: simulation of error-prone long reads.
*Journal of Open Source Software*, 4(36), 1316.
https://doi.org/10.21105/joss.01316
https://github.com/rrwick/Badread

Used to simulate ONT-like long reads from the alien reference genome
(`scan_01.alien.fq`, `scan_02.alien.fq`) and the S. cerevisiae
chromosome I tutorial ONT reads.

---

**ART** (art_illumina, v2.5.8 or later)
Huang W, Li L, Myers JR, Marth GT. (2012). ART: a next-generation
sequencing read simulator. *Bioinformatics*, 28(4), 593--594.
https://doi.org/10.1093/bioinformatics/bts543
https://www.niehs.nih.gov/research/resources/software/biostatistics/art

Used to simulate paired-end Illumina reads for all 15 alien
population individuals and 9 yeast tutorial individuals.

---

**Polyester** (Bioconductor, v1.38 or later)
Frazee AC, Jaffe AE, Langmead B, Leek JT. (2015). Polyester:
simulating RNA-seq datasets with differential transcript expression.
*Bioinformatics*, 31(17), 2778--2784.
https://doi.org/10.1093/bioinformatics/btv272
https://bioconductor.org/packages/polyester

Used to simulate aurora-on/off RNA-seq reads for the alien
transcriptomics data and condition A/B reads for the yeast
RNA-seq tutorial.

---

### Reference genomes

**D. discoideum** (dicty_2.7, GCF_000004695.1)
Eichinger L et al. (2005). The genome of the social amoeba
*Dictyostelium discoideum*. *Nature*, 435, 43--57.
https://doi.org/10.1038/nature03481

Chromosome 6 (NC_007092.3, positions 1--1,500,000) was used as the
chassis for the alien genome. All gene identifiers were replaced with
opaque ORG-XXXX designations to prevent identification.

---

**S. cerevisiae** (S288C, GCF_000146045.2)
Goffeau A et al. (1996). Life with 6000 genes. *Science*, 274,
546--567. https://doi.org/10.1126/science.274.5287.546

Chromosome I (NC_001133.9, 230,218 bp) was used for all yeast
tutorial datasets.

---

### Data processing

**seqkit** (v2.x)
Shen W, Le S, Li Y, Hu F. (2016). SeqKit: A cross-platform and
ultrafast toolkit for FASTA/Q file manipulation. *PLoS ONE*, 11(10),
e0163962. https://doi.org/10.1371/journal.pone.0163962
https://bioinf.shenwei.me/seqkit/

Used for reference subsetting, sequence statistics, and verification.

---

**gffread** (v0.12 or later)
Pertea G, Pertea M. (2020). GFF utilities: GffRead and GffCompare.
*F1000Research*, 9, 304.
https://doi.org/10.12688/f1000research.23297.2
https://github.com/gpertea/gffread

Used to extract transcript sequences from the D. discoideum annotation.

---

**NCBI Datasets CLI** (v14 or later)
NCBI Resource Coordinators. (2018). Database resources of the
National Center for Biotechnology Information.
*Nucleic Acids Research*, 46(D1), D8--D13.
https://doi.org/10.1093/nar/gkx1095
https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/

Used to download reference genomes and annotations from NCBI.

---

### Python and R

**Python** (v3.11)
Python Software Foundation. https://www.python.org

Custom scripts (data generation pipeline, cipher, resonance tools,
custom analysis tools) written in Python 3.11.

**R** (v4.x)
R Core Team. (2023). R: A language and environment for statistical
computing. R Foundation for Statistical Computing, Vienna, Austria.
https://www.r-project.org

Used with polyester for RNA-seq simulation.

**Biopython** (v1.8 or later)
Cock PJ et al. (2009). Biopython: freely available Python tools for
computational molecular biology and bioinformatics. *Bioinformatics*,
25(11), 1422--1423. https://doi.org/10.1093/bioinformatics/btp163

Used in data generation pipeline scripts.

---

## Tools used by students (in the Docker image)

These tools are pre-installed in the Docker image and used by
students during the course sessions.

---

**FastQC** (v0.12 or later)
Andrews S. (2010). FastQC: A quality control tool for high
throughput sequence data.
https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

Used in session 2 to assess sequencing data quality.

---

**fastp** (v0.23 or later)
Chen S, Zhou Y, Chen Y, Gu J. (2018). fastp: an ultra-fast
all-in-one FASTQ preprocessor. *Bioinformatics*, 34(17), i884--i890.
https://doi.org/10.1093/bioinformatics/bty560
https://github.com/OpenGene/fastp

Used in session 2 to trim adapters from ONT reads
(`--disable_quality_filtering` required for ONT data).

---

**SPAdes** (v3.15 or later)
Bankevich A et al. (2012). SPAdes: A new genome assembly algorithm
and its applications to single-cell sequencing. *Journal of
Computational Biology*, 19(5), 455--477.
https://doi.org/10.1089/cmb.2012.0021
https://cab.spbu.ru/software/spades/

Used in session 3 to assemble the alien genome from ONT reads.

---

**minimap2** (v2.24 or later)
Li H. (2018). Minimap2: pairwise alignment for nucleotide sequences.
*Bioinformatics*, 34(18), 3094--3100.
https://doi.org/10.1093/bioinformatics/bty191
https://github.com/lh3/minimap2

Used in session 7 to align population reads to the assembled genome.

---

**SAMtools** (v1.17 or later)
Li H et al. (2009). The Sequence Alignment/Map format and SAMtools.
*Bioinformatics*, 25(16), 2078--2079.
https://doi.org/10.1093/bioinformatics/btp352
https://www.htslib.org

Used in sessions 5 and 7 for BAM file manipulation, indexing, and
region extraction.

---

**BCFtools** (v1.17 or later)
Danecek P et al. (2021). Twelve years of SAMtools and BCFtools.
*GigaScience*, 10(2), giab008.
https://doi.org/10.1093/gigascience/giab008
https://www.htslib.org/doc/bcftools.html

Used in session 7 for variant calling and VCF manipulation.

---

**Salmon** (v1.10 or later)
Patro R, Duggal G, Love MI, Irizarry RA, Kingsford C. (2017).
Salmon provides fast and bias-aware quantification of transcript
expression. *Nature Methods*, 14, 417--419.
https://doi.org/10.1038/nmeth.4197
https://combine-lab.github.io/salmon/

Used in sessions 5 and 6 for quasi-mapping-based RNA-seq
quantification.

---

**seqkit** (v2.x)
Shen W, Le S, Li Y, Hu F. (2016). SeqKit: A cross-platform and
ultrafast toolkit for FASTA/Q file manipulation. *PLoS ONE*, 11(10),
e0163962. https://doi.org/10.1371/journal.pone.0163962
https://bioinf.shenwei.me/seqkit/

Used throughout for file inspection, statistics, and pattern
searching.

---

### Custom course tools (included in Docker image)

The following tools were written specifically for this course and are
available in the Docker image under `/opt/aliengen/scripts/`:

| Tool | Command | Session | Function |
|---|---|---|---|
| Cipher decoder | `transcode` | 2 | Gated WXYZ-to-ACGT decoder |
| FASTQ converter | `fasta_to_fastq` | 5 | Convert polyester FASTA output |
| ORF finder | `find_orfs` | 4 | ORF search with custom codon table |
| Counts matrix builder | `build_counts_matrix` | 5--6 | Merge Salmon quant.sf files |
| DE analysis | `de_analysis` | 6 | Welch's t-test differential expression |
| Population clustering | `cluster_population` | 7 | PCA + KMeans with interactive HTML |
| Resonance calculator | `resonance` | 7 | Cassette-to-frequency tone generator |
| Resonance batch | `resonance_batch` | 7 | All-pairs resonance with index |

---

### Python libraries (student tools)

**scikit-learn** (v1.x)
Pedregosa F et al. (2011). Scikit-learn: Machine learning in Python.
*Journal of Machine Learning Research*, 12, 2825--2830.
https://scikit-learn.org

Used by `cluster_population` for PCA and KMeans clustering.

**plotly** (v5.x)
Plotly Technologies Inc. (2015). Collaborative data science.
https://plotly.com

Used by `cluster_population` for interactive HTML visualisation.

**scipy** (v1.x)
Virtanen P et al. (2020). SciPy 1.0: fundamental algorithms for
scientific computing in Python. *Nature Methods*, 17, 261--272.
https://doi.org/10.1038/s41592-019-0686-2

Used by `de_analysis` for Welch's t-test.

**pandas** (v2.x)
The Pandas Development Team. (2020). pandas-dev/pandas: Pandas.
https://doi.org/10.5281/zenodo.3509134

Used by multiple custom scripts for tabular data manipulation.
