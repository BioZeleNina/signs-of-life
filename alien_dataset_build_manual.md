---
title: "Alien dataset build manual"
nav_exclude: true
---

# Alien dataset build manual

This document describes exactly how the alien genomic dataset for
*Signs of life* was generated. Every command, random seed, and
parameter is recorded so the dataset can be reproduced exactly.

All work was done on Apple Silicon Mac (M-series) under Rosetta 2
emulation (osx-64 conda environment). Commands run on other platforms
may differ slightly.

---

## Environment

### Conda environment

```bash
conda create -n aliengen python=3.11 -y
conda activate aliengen
conda config --add channels bioconda
conda config --add channels conda-forge
conda install -c bioconda badread seqkit art -y
conda install biopython scipy pandas -y
pip install --break-system-packages polyester  # R package, see below
```

R packages (run in R):

```r
install.packages("BiocManager")
BiocManager::install("polyester")
BiocManager::install("Biostrings")
```

### Working directory

All commands run from:

```bash
cd ~/aliengen
```

---

## Stage 0 -- Reference genome

**Organism:** *Dictyostelium discoideum* strain AX4
**Assembly:** GCF_000004695.1 (dicty_2.7)
**Target region:** Chromosome 6 (NC_007092.3), positions 1--1,500,000

### Download

```bash
datasets download genome accession GCF_000004695.1 \
  --include genome \
  --filename ref/dicty_genome.zip
unzip ref/dicty_genome.zip -d ref/dicty_ncbi/
```

### Extract chromosome 6 and subset to 1.5 Mb

```bash
# Extract NC_007092.3
grep -A1 "NC_007092.3" ref/dicty_ncbi/ncbi_dataset/data/GCF_000004695.1/GCF_000004695.1_dicty_2.7_genomic.fna \
  | head -2 > ref/chr6_full.fasta

# Subset to 1.5 Mb
seqkit subseq -r 1:1500000 ref/chr6_full.fasta \
  | seqkit replace -p ".*" -r "alien_chr" \
  > ref/alien_chr.fasta

seqkit stats ref/alien_chr.fasta
# Expected: 1 sequence, 1,500,000 bp
```

### Reannotate (remove identifying information)

```bash
python scripts/reannotate.py \
  --gff ref/dicty_ncbi/ncbi_dataset/data/GCF_000004695.1/genomic.gff \
  --chr NC_007092.3 \
  --start 1 \
  --end 1500000 \
  --out truth/alien_annotation.gff
```

`reannotate.py` replaces all gene IDs with `ORG-XXXX` designations
and strips all organism-identifying fields.

---

## Stage 1 -- Alien codon table

Generates a permuted genetic code: same 64-codon structure as the
standard code but with different codon-to-amino-acid assignments.

```bash
python scripts/make_codon_table.py --seed 42 \
  --out truth/alien_codon_table.txt
```

**Key outputs (seed 42):**
- Start codon: `GCG` (proline in standard code)
- Stop codons: `AGG`, `GAA`, `GAT` (all encode amino acids in standard code)
- Written to: `truth/alien_codon_table.txt`

---

## Stage 2 -- Population design

Three mating types (I, II, III). Type II is a recombinant chimera of
Types I and III -- its 48 bp mating-type cassette is a concatenation
of the first 24 bp of Type I's cassette and the last 24 bp of Type
III's cassette.

### Design mating types and variants

```bash
python scripts/design_mating_types.py --seed 7
python scripts/build_individuals.py --seed 7
```

**Population structure:**
- 15 individuals total: 9 haploid, 6 diploid
- Haploid: 3 Type I, 3 Type II, 3 Type III
- Diploid (zygotes): 2 × (I×II), 2 × (II×III), 2 × (I×III)
- Individual names follow: `ind_H0N_typeX` (haploid) and
  `ind_D0N_XxY` (diploid)

**Focal individual:** `ind_H01_typeI` (sequenced at 50×; all others 30×)

---

## Stage 3a -- Illumina DNA reads

Using ART (art_illumina), Illumina HiSeq 2500 model, 150 bp paired-end.

```bash
# Focal individual at 50x
art_illumina -ss HS25 \
  -i genomes/ind_H01_typeI.fasta \
  -p -l 150 -f 50 -m 300 -s 40 \
  -rs 7 \
  -o reads_dna/ind_H01_typeI_R

# All other individuals at 30x (loop)
for FASTA in genomes/ind_*.fasta; do
  NAME=$(basename ${FASTA} .fasta)
  if [ "$NAME" = "ind_H01_typeI" ]; then continue; fi
  art_illumina -ss HS25 \
    -i ${FASTA} \
    -p -l 150 -f 30 -m 300 -s 40 \
    -rs 7 \
    -o reads_dna/${NAME}_R
  echo "Done: ${NAME}"
done
```

### Spike in adapter contamination and QC-bad demo files

```bash
# Add adapters to one individual for session 2 QC teaching
python scripts/spike_adapters.py \
  --r1 reads_dna/ind_H02_typeI_R1.fq \
  --r2 reads_dna/ind_H02_typeI_R2.fq \
  --out-r1 reads_dna/qc_bad1_adapters_R1.fq \
  --out-r2 reads_dna/qc_bad1_adapters_R2.fq

# Add quality decay to another for session 2 QC teaching
python scripts/make_bad_fastq.py \
  --r1 reads_dna/ind_H02_typeI_R1.fq \
  --r2 reads_dna/ind_H02_typeI_R2.fq \
  --outdir reads_dna \
  --seed 99
```

---

## Stage 3b -- ONT reads (alien cipher applied)

### Apply cipher to reference before Badread

The cipher (A→X, C→Z, G→W, T→Y) is applied to the reference FASTA
before simulating reads, so the reads come out in the alien alphabet.
ACGT adapter sequences are added post-simulation.

```bash
python scripts/apply_cipher.py \
  --in ref/alien_chr.fasta \
  --out ref/alien_chr_ciphered.fasta
```

### Simulate ONT reads with Badread

**scan_01** (used by students, aurora-surge conditions = higher error):

```bash
badread simulate \
  --reference ref/alien_chr_ciphered.fasta \
  --quantity 75M \
  --length 2000,800 \
  --error-model nanopore2023 \
  --seed 7 \
  | python scripts/spike_ont_artifacts.py \
    --adapter-frac 0.12 \
    --quality-frac 0.20 \
    --seed 7 \
  > student_release/scan_01.alien.fq

seqkit stats student_release/scan_01.alien.fq
# Expected: ~36,728 reads, ~75 Mb total, avg ~2,046 bp
```

**scan_02** (bad quality demo, aurora still active):

```bash
badread simulate \
  --reference ref/alien_chr_ciphered.fasta \
  --quantity 30M \
  --length 2000,800 \
  --error-model nanopore2023 \
  --junk-reads 5 \
  --random-reads 3 \
  --chimeras 2 \
  --seed 99 \
  > student_release/scan_02.alien.fq
```

### Expected output after student decoding and trimming (scan_01)

After students decode (WXYZ → ACGT) and trim with fastp:
- `--disable_quality_filtering --length_required 200`
- Expected reads after trimming: **32,477** (±5% acceptable)
- This is the Session 2 gate answer

---

## Stage 4 -- RNA-seq simulation

Conditions: aurora_off (samples 01--03) vs aurora_on (samples 04--06).
15 genes seeded as strongly upregulated in aurora_on (fold change 6--30).

```bash
Rscript scripts/simulate_rnaseq.R
```

**`simulate_rnaseq.R` key parameters:**

```r
set.seed(7)
# 15 DE genes, fold change range 6-30 in aurora_on
# 3 replicates per condition
# paired-end, readlen=100
# outdir: reads_rna/
```

### Convert polyester FASTA output to FASTQ

Polyester outputs FASTA. Convert before including in student_release:

```bash
for BASE in sample_01 sample_02 sample_03 sample_04 sample_05 sample_06; do
  python scripts/fasta_to_fastq.py \
    --in reads_rna/${BASE}_1.fasta \
    --out reads_rna/${BASE}_1.fastq
  python scripts/fasta_to_fastq.py \
    --in reads_rna/${BASE}_2.fasta \
    --out reads_rna/${BASE}_2.fastq
done
```

### Move answer keys out of student_release

```bash
mv reads_rna/sim_tx_info.txt truth/
mv reads_rna/sim_rep_info.txt truth/
mv reads_rna/sim_counts_matrix.rda truth/
```

`truth/sim_tx_info.txt` contains the DE gene fold changes and is the
answer key for sessions 5--6. **Never share with students.**

The 15 DE gene IDs are also written to:
`truth/aurora_responsive_genes.txt`

---

## Stage 5 -- Lore files (session 1)

Three plain text files provide the narrative context for session 1:

```bash
ls mission_data/session_01/
# sensor_log_aurora.txt   <- aurora frequency readings (gate Q answer)
# mission_brief.txt       <- ARIADNE-7's initial log
# XB7734_survey_form_template.txt  <- blank survey form
```

These were written manually. `sensor_log_aurora.txt` contains the two
frequencies **400 Hz** and **600 Hz** (3:2 ratio) that form the
Session 1 gate question answer.

The Easter egg reward file is at `truth/mission_zero.txt`. It is
**never** included in student_release or the GitHub repository.

---

## Tutorial data -- S. cerevisiae chromosome I

All tutorial data is generated from *S. cerevisiae* S288C chromosome I
(GCF_000146045.2, NC_001133.9, 230,218 bp).

### Download reference

```bash
datasets download genome accession GCF_000146045.2 \
  --include genome \
  --chromosomes I \
  --filename tutorial_data/yeast/ncbi_download.zip
```

### Illumina reads (sessions 3, 7 tutorial)

```bash
# Clean reads (30x)
art_illumina -ss HS25 \
  -i tutorial_data/yeast/scerevisiae_chrI.fasta \
  -p -l 150 -f 30 -m 300 -s 40 \
  -rs 42 \
  -o tutorial_data/yeast/scerevisiae_chrI_R

# Dirty reads (adapter + quality problems, session 2 tutorial)
python scripts/spike_adapters.py \
  --r1 tutorial_data/yeast/scerevisiae_chrI_R1.fq \
  --r2 tutorial_data/yeast/scerevisiae_chrI_R2.fq \
  --out-r1 tutorial_data/yeast/scerevisiae_chrI_R1_dirty.fq \
  --out-r2 tutorial_data/yeast/scerevisiae_chrI_R2_dirty.fq

# Trimmed reads (pre-made answer for session 2 tutorial)
fastp \
  --in1 tutorial_data/yeast/scerevisiae_chrI_R1_dirty.fq \
  --in2 tutorial_data/yeast/scerevisiae_chrI_R2_dirty.fq \
  --out1 tutorial_data/yeast/scerevisiae_chrI_R1_trimmed.fq \
  --out2 tutorial_data/yeast/scerevisiae_chrI_R2_trimmed.fq \
  --thread 4
```

### ONT reads (session 2 tutorial)

```bash
# Clean ONT reads
badread simulate \
  --reference tutorial_data/yeast/scerevisiae_chrI.fasta \
  --quantity 20M \
  --length 2000,800 \
  --seed 42 \
  > tutorial_data/yeast/scerevisiae_chrI_ont.fastq

# Dirty ONT reads (adapter + quality problems)
python scripts/spike_ont_artifacts.py \
  --in tutorial_data/yeast/scerevisiae_chrI_ont.fastq \
  --adapter-frac 0.15 \
  --quality-frac 0.25 \
  --seed 42 \
  --out tutorial_data/yeast/scerevisiae_chrI_ont_dirty.fastq

# Trimmed ONT reads
fastp \
  --in1 tutorial_data/yeast/scerevisiae_chrI_ont_dirty.fastq \
  --out1 tutorial_data/yeast/scerevisiae_chrI_ont_trimmed.fastq \
  --adapter_sequence AATGTACTTCGTTCAGTTACGTATTGCT \
  --disable_quality_filtering \
  --length_required 100 \
  --thread 4
```

### Transcripts (session 5 tutorial)

```bash
# Download annotation
datasets download genome accession GCF_000146045.2 \
  --include gff3 --chromosomes I \
  --filename tutorial_data/yeast/ncbi_annotation.zip
unzip tutorial_data/yeast/ncbi_annotation.zip \
  -d tutorial_data/yeast/ncbi_annotation/

# Extract transcripts
gffread \
  tutorial_data/yeast/ncbi_annotation/ncbi_dataset/data/GCF_000146045.2/genomic.gff \
  -g tutorial_data/yeast/scerevisiae_chrI.fasta \
  -w tutorial_data/yeast/scerevisiae_chrI_transcripts.fasta

grep -c ">" tutorial_data/yeast/scerevisiae_chrI_transcripts.fasta
# Expected: 101 transcripts
```

### RNA-seq tutorial (sessions 5--6 tutorial)

```bash
Rscript scripts/simulate_yeast_rnaseq.R
# set.seed(42), 12 seeded DE genes, 3+3 replicates

# Convert FASTA to FASTQ
for BASE in sample_01 sample_02 sample_03 sample_04 sample_05 sample_06; do
  python scripts/fasta_to_fastq.py \
    --in tutorial_data/yeast/rnaseq/${BASE}_1.fasta \
    --out tutorial_data/yeast/rnaseq_fastq/${BASE}_1.fastq
  python scripts/fasta_to_fastq.py \
    --in tutorial_data/yeast/rnaseq/${BASE}_2.fasta \
    --out tutorial_data/yeast/rnaseq_fastq/${BASE}_2.fastq
done
```

Answer keys (keep on instructor Mac only -- never upload):
- `tutorial_data/yeast/sim_tx_info.txt`
- `tutorial_data/yeast/sim_rep_info.txt`
- `tutorial_data/yeast/sim_counts_matrix.rda`
- `tutorial_data/yeast/yeast_de_genes_truth.txt`

### Population tutorial (session 7 tutorial)

```bash
python scripts/design_yeast_population.py   # seed 42, 9 individuals, 3 groups
python scripts/build_yeast_individuals.py

# Simulate Illumina reads for each individual
for FASTA in tutorial_data/yeast/population/genomes/*.fasta; do
  NAME=$(basename ${FASTA} .fasta)
  art_illumina -ss HS25 \
    -i ${FASTA} \
    -p -l 150 -f 30 -m 300 -s 40 \
    -rs 42 \
    -o tutorial_data/yeast/population/reads/${NAME}_R
done
```

Answer keys (keep on instructor Mac only -- never upload):
- `tutorial_data/yeast/population/design.csv`
- `tutorial_data/yeast/population/individuals.csv`
- `tutorial_data/yeast/population/genomes/`

---

## Assembling student_release/

Run after all stages are complete:

```bash
bash scripts/populate_student_release.sh
```

This collects the correct files and runs a leak check to confirm no
answer keys are included. Review the output before uploading.

---

## Docker image

The Docker image packages all student-facing tools.

### Build

```bash
cd ~/aliengen/docker_build
docker build --platform linux/amd64 -t aliengen-toolkit:latest .
```

### Test

```bash
docker run --rm aliengen-toolkit:latest ariadne hello
```

### Push to Docker Hub

```bash
docker login -u biozelenina
docker tag aliengen-toolkit:latest biozelenina/signs-of-life:latest
docker push biozelenina/signs-of-life:latest
```

For detailed update instructions see `docker_update_manual.md`
(instructor-only, not in this repository).

---

## Random seeds summary

| Stage | Script | Seed |
|---|---|---|
| Stage 1: alien codon table | make_codon_table.py | 42 |
| Stage 2: population design | design_mating_types.py, build_individuals.py | 7 |
| Stage 3a: Illumina reads | art_illumina | 7 |
| Stage 3a: bad QC files | make_bad_fastq.py, spike_adapters.py | 99 |
| Stage 3b: ONT scan_01 | badread + spike_ont_artifacts.py | 7 |
| Stage 3b: ONT scan_02 | badread | 99 |
| Stage 4: alien RNA-seq | simulate_rnaseq.R (set.seed) | 7 |
| Tutorial: yeast all stages | art_illumina, badread, simulate_yeast_rnaseq.R | 42 |
| Tutorial: yeast bad QC | spike_ont_artifacts.py | 42 |

---

## Gate question answers

These are the expected answers for each session's gate question.
Do not include in any student-facing material.

| Session | Question | Expected answer |
|---|---|---|
| 1 | Aurora frequencies | `400 600` (400 Hz and 600 Hz) |
| 2 | Reads after trimming | 32,477 (±5%) |
| 3 | Assembly N50 | ~16,209 bp (±15%) |
| 4 | Stop codons | `AGG GAA GAT` (alphabetical) |
| 5 | Most expressed contig | Top NODE from quant.sf (flexible check) |
| 6 | Top DE gene | Top NODE from de_results.csv (flexible check) |
| 7 | Largest cluster size | 4--7 individuals (range check) |
| 8 | p < 0.05? | YES or NO (both accepted) |

---

## Key truth files (instructor Mac only)

Never upload to GitHub or share with students:

```
truth/alien_codon_table.txt          <- alien genetic code
truth/alien_annotation.gff           <- gene positions
truth/aurora_responsive_genes.txt    <- 15 seeded DE genes
truth/cipher_key.txt                 <- WXYZ→ACGT mapping
truth/reference_cassettes_all.fasta  <- all 3 cassettes (Type II = spoiler)
truth/mission_zero.txt               <- alien egg hunt reward file
truth/sim_tx_info.txt                <- alien RNA-seq answer key
tutorial_data/yeast/sim_tx_info.txt  <- yeast RNA-seq answer key
tutorial_data/yeast/yeast_de_genes_truth.txt
tutorial_data/yeast/population/design.csv
tutorial_data/yeast/population/individuals.csv
tutorial_data/yeast/population/genomes/
```
