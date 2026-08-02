---
title: "Session 5: signs of life"
nav_order: 8
---

# SESSION 5 -- Signs of life
## *The organism is not just present. It is doing something.*

---

### MISSION BRIEFING

You have a reference assembly and a set of predicted genes. Now you
will find out what the organism is actually expressing -- which genes
are active, and how much.

The ship sequenced six RNA samples: three taken during aurora activity
(aurora-on, samples 04--06) and three taken during auroral quiet
(aurora-off, samples 01--03). Sessions 5 and 6 use this data.

Session 5 focuses on the aurora-on samples only by mapping reads to the
assembly and quantifying expression at each contig. The question is: Which regions of the genome are actively transcribed?

> ARIADNE-7: "The aurora-off samples are almost silent. Very few
> reads. A handful of genes expressing at minimal levels. During the
> surge it is a completely different picture. This organism does not idle.
> When the aurora fires, something wakes up. I want you to quantify
> exactly how much it wakes up. Then I will tell you what I think
> it means. You can tell me if I am wrong."

---

### PRE-MISSION LECTURE -- RNA-seq and transcript quantification

#### What RNA-seq measures

RNA sequencing captures the transcriptome: the complete set of RNA
molecules present in a sample at a given moment. By sequencing these
RNAs and counting reads, you measure which genes are expressed and at
what level. More reads mapping to a gene indicates more of that
gene's transcript was present, which reflects higher expression.

#### Mapping reads to a reference

To quantify expression, you align RNA reads to a reference sequence
(here, your assembly) and count how many reads map to each contig.

This course uses **Salmon**, which uses quasi-mapping -- a very fast
approach that estimates where each read originated without performing
a full base-by-base alignment. Salmon produces a table of estimated
read counts per transcript.

Key Salmon output columns in `quant.sf`:

| Column | Meaning |
|---|---|
| Name | Transcript or contig identifier |
| Length | Transcript length in bp |
| EffectiveLength | Length corrected for sequencing biases |
| TPM | Transcripts per million (normalised expression) |
| NumReads | Estimated read count (your primary output) |

#### Library type

Salmon needs to know how the reads relate to transcripts. The `-l`
flag specifies the library type. For the RNA-seq data in this course,
use `-l IU` (inward-facing, unstranded paired-end reads).

#### Building a Salmon index

Before quantifying, you build an index from your reference assembly.
This is a one-time step per reference. The index allows rapid
quasi-mapping of reads.

#### From reads to counts matrix

After quantifying each sample separately, you merge the individual
`quant.sf` files into one counts matrix (transcripts x samples) using
`build_counts_matrix`. This matrix is the input for differential
expression analysis in session 6.

---

### TUTORIAL -- RNA-seq quantification with yeast chrI data

In this tutorial you will quantify RNA-seq reads from a simulated
*S. cerevisiae* chrI experiment: condition A (basal expression,
samples 01--03) vs condition B (induced expression, samples 04--06).
Twelve genes have been designed to be strongly upregulated in
condition B. You will verify you can recover them.

All commands run inside the Docker container from `/work`.

```bash
cd /work
mkdir -p tutorial_data/yeast/session_05/salmon_index
mkdir -p tutorial_data/yeast/session_05/quant
```

#### Step 1 -- Build a Salmon index from the yeast transcript FASTA

```bash
salmon index \
  -t tutorial_data/yeast/scerevisiae_chrI_transcripts.fasta \
  -i tutorial_data/yeast/session_05/salmon_index \
  --quiet

echo "Index built."
```

#### Step 2 -- Inspect one RNA-seq file before quantifying

```bash
head -8 tutorial_data/yeast/rnaseq_fastq/sample_04_1.fastq
seqkit stats tutorial_data/yeast/rnaseq_fastq/sample_04_1.fastq
```

Note the read length (100 bp), the number of reads, and that these
are already FASTQ format -- no conversion needed.

#### Step 3 -- Quantify condition B samples (04, 05, 06)

The `for` loop runs the same `salmon quant` command three times --
once for each aurora-on sample (04, 05, 06). Each time the loop
runs, the variable `${SAMPLE}` takes the next value in the list,
so the input files and output directory name change automatically.
This avoids writing the same command three times with small
differences:

```bash
for SAMPLE in 04 05 06; do
  salmon quant \
    -i tutorial_data/yeast/session_05/salmon_index \
    -l IU \
    -1 tutorial_data/yeast/rnaseq_fastq/sample_${SAMPLE}_1.fastq \
    -2 tutorial_data/yeast/rnaseq_fastq/sample_${SAMPLE}_2.fastq \
    --validateMappings \
    --quiet \
    -o tutorial_data/yeast/session_05/quant/B_${SAMPLE}
  echo "Quantified sample ${SAMPLE}"
done
```

#### Step 4 -- Check mapping rates

```bash
for SAMPLE in 04 05 06; do
  echo "Sample ${SAMPLE}:"
  grep "Mapping rate" \
    tutorial_data/yeast/session_05/quant/B_${SAMPLE}/logs/salmon_quant.log
done
```

Mapping rates above 50% are generally acceptable. For a simulated
dataset with a matching reference, expect 70--90%.

#### Step 5 -- Look at the most expressed transcripts

```bash
sort -t$'\t' -k5 -rn \
  tutorial_data/yeast/session_05/quant/B_04/quant.sf \
  | head -10
```

The fifth column is NumReads. Which transcripts have the most reads
in the induced condition?

#### Step 6 -- Quantify condition A samples (01, 02, 03)

```bash
for SAMPLE in 01 02 03; do
  salmon quant \
    -i tutorial_data/yeast/session_05/salmon_index \
    -l IU \
    -1 tutorial_data/yeast/rnaseq_fastq/sample_${SAMPLE}_1.fastq \
    -2 tutorial_data/yeast/rnaseq_fastq/sample_${SAMPLE}_2.fastq \
    --validateMappings \
    --quiet \
    -o tutorial_data/yeast/session_05/quant/A_${SAMPLE}
  echo "Quantified sample ${SAMPLE}"
done
```

#### Step 7 -- Build the counts matrix

```bash
build_counts_matrix \
  --quant \
    tutorial_data/yeast/session_05/quant/A_01/quant.sf \
    tutorial_data/yeast/session_05/quant/A_02/quant.sf \
    tutorial_data/yeast/session_05/quant/A_03/quant.sf \
    tutorial_data/yeast/session_05/quant/B_04/quant.sf \
    tutorial_data/yeast/session_05/quant/B_05/quant.sf \
    tutorial_data/yeast/session_05/quant/B_06/quant.sf \
  --names A_1 A_2 A_3 B_1 B_2 B_3 \
  --out tutorial_data/yeast/session_05/counts_matrix.csv

head -3 tutorial_data/yeast/session_05/counts_matrix.csv
wc -l tutorial_data/yeast/session_05/counts_matrix.csv
```

#### Tutorial checkpoint

Add to your mission log:

```bash
echo "Session 05 tutorial: yeast RNA-seq quantification complete." \
  >> mission_data/logs/mission_log.txt
```

---

### MAIN MISSION -- What is the alien organism expressing?

```bash
cd /work/mission_data
mkdir -p session_05/salmon_index
mkdir -p session_05/quant
```

#### Step 1 -- Build a Salmon index from your alien assembly

```bash
salmon index \
  -t session_03/assembly/contigs.fasta \
  -i session_05/salmon_index \
  --quiet

echo "Index built from alien assembly."
```

#### Step 2 -- Quantify the aurora-on samples

Samples 04, 05, and 06 are aurora-on:

```bash
for SAMPLE in 04 05 06; do
  salmon quant \
    -i session_05/salmon_index \
    -l IU \
    -1 rnaseq/sample_${SAMPLE}_1.fastq \
    -2 rnaseq/sample_${SAMPLE}_2.fastq \
    --validateMappings \
    --quiet \
    -o session_05/quant/on_${SAMPLE}
  echo "Quantified aurora-on sample ${SAMPLE}"
done
```

#### Step 3 -- Check mapping rates

```bash
for SAMPLE in 04 05 06; do
  echo "Sample ${SAMPLE}:"
  grep "Mapping rate" \
    session_05/quant/on_${SAMPLE}/logs/salmon_quant.log
done
```

A mapping rate above 50% is acceptable. If very low, check that you
used the correct assembly from session 3.

#### Step 4 -- Look at the most expressed contigs

```bash
sort -t$'\t' -k5 -rn \
  session_05/quant/on_04/quant.sf \
  | head -10
```

What are the most highly expressed contigs in aurora-on conditions?
Are these long or short contigs? What does that tell you?

> ARIADNE-7: "I want you to note which contigs are most expressed.
> In session 7 you will extract the mating-type cassette from the
> assembly. I have a hypothesis that the most highly expressed genes
> are related to the cassette-encoded mating signal. I may be wrong.
> I am interested in your opinion once you have seen the data."

#### Step 5 -- Update your mission log

```bash
TOP_CONTIG=$(sort -t$'\t' -k5 -rn session_05/quant/on_04/quant.sf \
  | awk 'NR==2 {print $1}')

echo "Session 05: aurora-on quantification complete." \
  >> mission_data/logs/mission_log.txt
echo "Most expressed contig in aurora-on: ${TOP_CONTIG}" \
  >> mission_data/logs/mission_log.txt
```

---

### MISSION DEBRIEF

You have quantified expression across all assembled contigs for the
three aurora-on samples. The most expressed contigs represent the
most transcriptionally active regions of the genome during aurora
activity. Session 6 will compare this to the aurora-off condition.

---

### GATE QUESTION -- Session 5

```bash
ariadne submit --session 5
```

> ARIADNE-7: "What is the name of the contig with the highest total
> mapped read count across the three aurora-on samples?
> Paste the full contig name starting with NODE_"

*Hint: sort the quant.sf file by NumReads (column 5) and read the top
entry, or check your mission log entry from this session.*

---

### REFERENCE -- Session 5 commands

| Command | What it does |
|---|---|
| `salmon index -t transcripts.fasta -i index_dir` | Build Salmon index |
| `salmon quant -i index -l IU -1 R1.fq -2 R2.fq --validateMappings --quiet -o outdir` | Quantify expression |
| `grep "Mapping rate" logfile` | Check what fraction of reads mapped |
| `sort -t$'\t' -k5 -rn quant.sf \| head -10` | Top 10 most expressed transcripts |
| `build_counts_matrix --quant FILE... --names NAME... --out out.csv` | Merge quant.sf files |
| `ariadne submit --session 5` | Submit gate answer |
| `ariadne hint --session 5` | Get a hint |
