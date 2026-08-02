---
title: "Session 6: aurora"
nav_order: 9
---

# SESSION 6 -- Aurora
## *Compare dormant to awake. Some genes only exist during the surge.*

---

### MISSION BRIEFING

Session 5 showed you what the organism expresses during aurora activity.
Session 6 asks the comparison question: which genes change between
aurora-on and aurora-off?

The previous survey missions found nothing because they arrived during
auroral quiet. No signal. No expression. A world that appeared
completely inert. The aurora comes, the organism wakes, and the signal
you detected on day one is the sound of that waking.

> ARIADNE-7: "I have pre-run the analysis. I am sharing this
> not because I am impatient but because I want you to verify my
> result independently. I identified 15 genes with very large fold
> changes between aurora-on and aurora-off. I am confident in the
> fold changes. I am less confident in my interpretation of what
> those genes are doing. That interpretation is your job."

---

### PRE-MISSION LECTURE -- Differential expression analysis

#### What differential expression means

A gene is differentially expressed between two conditions if its
expression level is significantly different in one condition versus
the other. "Significant" has two requirements that must both be met:

**1: A biologically meaningful fold change.** A two-fold change
(gene expressed twice as much in one condition) is often used as a
minimum threshold, but the appropriate threshold depends on the
system.

**2: Statistical significance.** The change must be unlikely to
arise by chance given the variability between replicates. With
three replicates per condition, this course uses a Welch's t-test.

A large fold change that is not statistically significant (because
expression is highly variable between replicates) is unreliable. A
tiny but very consistent fold change may be statistically significant
but biologically unimportant. Both effect size and p-value matter.

#### Fold change and log2 fold change

Fold change = expression in condition B / expression in condition A.

Log2 fold change (log2FC) is often more convenient: log2(8) = 3,
so a log2FC of 3 means 8-fold upregulation. Log2FC is symmetric:
+3 and -3 represent the same magnitude of change in opposite
directions. This course reports raw fold change for simplicity.

#### The counts matrix

The `build_counts_matrix` tool merges all six `quant.sf` files into
one CSV: rows are transcripts, columns are samples. This is the
input format `de_analysis` expects.

#### Interpreting de_analysis output

`de_analysis` outputs a CSV sorted by p-value (most significant
first) with columns:

| Column | Meaning |
|---|---|
| transcript_id | Contig or transcript name |
| mean_a | Mean expression in group A |
| mean_b | Mean expression in group B |
| fold_change_b_over_a | mean_b / mean_a |
| p_value | Welch's t-test p-value |

A transcript at the top of the sorted list (very small p-value,
large fold change) is your most confidently identified DE gene.

---

### TUTORIAL -- Differential expression with yeast chrI data

In this tutorial you run a complete DE analysis comparing condition A
(basal) to condition B (induced) in the yeast chrI dataset. Twelve
genes were seeded as strongly upregulated in condition B. You will
verify your analysis recovers them.

```bash
cd /work
mkdir -p tutorial_data/yeast/session_06
```

#### Step 1 -- Confirm you have the counts matrix from session 5

```bash
ls -lh tutorial_data/yeast/session_05/counts_matrix.csv
head -3 tutorial_data/yeast/session_05/counts_matrix.csv
```

If this file does not exist, return to session 5 tutorial Step 7
and build it first.

#### Step 2 -- Run differential expression analysis

```bash
de_analysis \
  --counts tutorial_data/yeast/session_05/counts_matrix.csv \
  --group-a A_1,A_2,A_3 \
  --group-b B_1,B_2,B_3 \
  --out tutorial_data/yeast/session_06/de_results.csv
```

#### Step 3 -- Examine the top results

```bash
head -6 tutorial_data/yeast/session_06/de_results.csv
```

Look at the top few rows. What fold changes do you see? Are the
p-values very small?

#### Step 4 -- Count significantly DE genes

```bash
awk -F',' 'NR>1 && $4>3 && $5<0.05 {count++} END {print count}' \
  tutorial_data/yeast/session_06/de_results.csv
```

This counts genes with fold change over 3 and p-value below 0.05.
How many do you find? You expect approximately 12.

#### Step 5 -- Compare to the truth list

```bash
cat tutorial_data/yeast/yeast_de_genes_truth.txt
```

Compare these gene names to the top entries in your de_results.csv.
Do the seeded DE genes appear near the top?

```bash
head -15 tutorial_data/yeast/session_06/de_results.csv \
  | cut -d',' -f1
```

A good DE analysis should recover most or all of the seeded genes
in the top results.

#### Tutorial checkpoint

```bash
echo "Session 06 tutorial: yeast DE analysis complete." \
  >> mission_data/logs/mission_log.txt
```

---

### MAIN MISSION -- Which alien genes wake up with the aurora?

```bash
cd /work/mission_data
mkdir -p session_06/quant
mkdir -p session_06/results
```

#### Step 1 -- Quantify the aurora-off samples

Samples 01, 02, and 03 are aurora-off:

```bash
for SAMPLE in 01 02 03; do
  salmon quant \
    -i session_05/salmon_index \
    -l IU \
    -1 rnaseq/sample_${SAMPLE}_1.fastq \
    -2 rnaseq/sample_${SAMPLE}_2.fastq \
    --validateMappings \
    --quiet \
    -o session_06/quant/off_${SAMPLE}
  echo "Quantified aurora-off sample ${SAMPLE}"
done
```

#### Step 2 -- Build the full counts matrix (all six samples)

```bash
build_counts_matrix \
  --quant \
    session_06/quant/off_01/quant.sf \
    session_06/quant/off_02/quant.sf \
    session_06/quant/off_03/quant.sf \
    session_05/quant/on_04/quant.sf \
    session_05/quant/on_05/quant.sf \
    session_05/quant/on_06/quant.sf \
  --names off_1 off_2 off_3 on_1 on_2 on_3 \
  --out session_06/results/counts_matrix.csv

wc -l session_06/results/counts_matrix.csv
```

#### Step 3 -- Run differential expression analysis

```bash
de_analysis \
  --counts session_06/results/counts_matrix.csv \
  --group-a off_1,off_2,off_3 \
  --group-b on_1,on_2,on_3 \
  --out session_06/results/de_results.csv
```

#### Step 4 -- Examine the results

```bash
head -6 session_06/results/de_results.csv
```

The results are sorted by p-value. Look at the top entries: what
fold changes do you see between aurora-off and aurora-on?

> ARIADNE-7: "I want to draw your attention to the fold changes at
> the top of the list. Values between 5 and 30 are typical for a
> strongly regulated gene. These genes are not merely responding to
> the aurora -- they appear to be completely silent in its absence.
> That is unusual. It suggests a dedicated regulatory mechanism
> rather than a general stress response."

#### Step 5 -- Count significantly DE genes

```bash
awk -F',' 'NR>1 && $4>4 && $5<0.05 {count++} END {print count}' \
  session_06/results/de_results.csv
```

#### Step 6 -- Update your mission log

```bash
TOP=$(awk -F',' 'NR==2 {print $1}' session_06/results/de_results.csv)
FC=$(awk -F',' 'NR==2 {print $4}' session_06/results/de_results.csv)

echo "Session 06: DE analysis complete." \
  >> mission_data/logs/mission_log.txt
echo "Top DE gene: ${TOP}, fold change: ${FC}" \
  >> mission_data/logs/mission_log.txt
```

---

### MISSION DEBRIEF

You have identified genes that are dramatically upregulated during
aurora activity. In aurora-off conditions, these genes are nearly
silent. In aurora-on, they are among the most expressed genes in the
transcriptome.

This explains why the previous survey missions found nothing: they
arrived during auroral quiet. The organism's most characteristic
activity -- the activity that generates the detectable signal -- only
occurs during aurora surges. A world catalogued twice as dead is not
necessarily dead. It may simply have been quiet when we looked.

Session 7 will ask who in the population is doing this, and whether
all individuals respond the same way.

---

### GATE QUESTION -- Session 6

```bash
ariadne submit --session 6
```

> ARIADNE-7: "What is the transcript_id of the most significantly
> upregulated gene in aurora-on conditions? Paste the full contig
> name from the first data row of your de_results.csv."

*Hint: run `head -2 session_06/results/de_results.csv | tail -1 | cut -d',' -f1`*

---

### REFERENCE -- Session 6 commands

| Command | What it does |
|---|---|
| `build_counts_matrix --quant FILES --names NAMES --out out.csv` | Merge Salmon outputs into one matrix |
| `de_analysis --counts in.csv --group-a G1 --group-b G2 --out out.csv` | Run DE analysis |
| `head -N file.csv` | Show first N rows |
| `awk -F',' 'NR>1 && $4>4 && $5<0.05 {count++} END {print count}'` | Count DE genes by threshold |
| `ariadne submit --session 6` | Submit gate answer |
| `ariadne hint --session 6` | Get a hint |
