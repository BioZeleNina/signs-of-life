---
title: "Session 7: how many sexes"
nav_order: 10
---

# SESSION 7 -- How many sexes?
## *Three clusters. Three cassettes. One of them is a chimera.*

---

### MISSION BRIEFING

The population data contains 15 individuals: 9 haploid and 6 diploid.
In session 7 you will call variants across all of them, identify
population structure, and discover something about how this organism
mates.

You already know from the aurora signal that the resonance involves
two frequencies in a 3:2 ratio. Session 7 is where you find out why.

> ARIADNE-7: "I have examined the cassette sequences. I want you to
> find them yourself. I will tell you one thing: one of the three
> mating-type cassettes does not have a clean repeating structure.
> When you find it, run the resonance tool on it. The result will
> explain everything. I am confident in this statement. I am less
> confident that my explanation of why it explains everything is
> correct. But the result itself will be clear."

---

### PRE-MISSION LECTURE -- Variant calling and population structure

#### What a variant is

A variant is a position in the genome where the sequence differs
between individuals. Single nucleotide polymorphisms (SNPs) are the
most common: at a given position, some individuals have one base and
others have a different base.

Variants are stored in VCF (Variant Call Format) files. Each row
in a VCF describes one variant site: chromosome, position, reference
base, alternate base, and for each individual a genotype call.

Genotype notation:
- `0/0` -- homozygous reference (same as the reference at this site)
- `1/1` -- homozygous alternate
- `0/1` -- heterozygous (one of each)

Haploid individuals can only be `0/0` or `1/1`. Heterozygous calls
in a nominally haploid individual suggest a problem.

#### The variant calling pipeline

Three steps:

1. **Align reads** from each individual to the reference assembly
   (minimap2)
2. **Pile up reads** at each position and identify where they disagree
   with the reference (bcftools mpileup)
3. **Call variants** by flagging positions where the alternate base is
   supported by enough reads to be a real variant (bcftools call)

#### Population structure with PCA

If variants cluster by group -- individuals from the same group
consistently share the same alleles -- that clustering reveals
population structure.

Principal component analysis (PCA) on a genotype matrix reduces the
high-dimensional variant data to two dimensions that capture most of
the variance. KMeans clustering then assigns individuals to groups.

The `cluster_population` tool does both steps and produces an
interactive HTML plot where you can hover over each point to see the
individual name.

#### Ploidy and the mating-type locus

Haploid individuals (vegetative) carry one copy of each chromosome,
so at every site they have exactly one allele. Diploid individuals
(zygotes from two haploids mating) carry two copies and show
heterozygous calls wherever their two parental haplotypes differ.

Variant callers assume diploidy unless told otherwise. If a haploid
is called as diploid, sequencing errors and collapsed repeats can
produce heterozygous calls that cannot be real. In the main mission
you will tell bcftools which individuals are haploid.

In a PCA, a diploid hybrid should sit roughly halfway between the
clusters of its two parents, because it carries one haplotype from
each.

At the mating-type locus, the pattern of heterozygosity tells you
which two mating types were involved in the cross. Remember that
the Type II cassette is a chimera: Type I units in the first half,
Type III units in the second half.

| Cross | First 24 bp | Second 24 bp |
|---|---|---|
| I x II | homozygous (Type I units in both) | heterozygous |
| II x III | heterozygous | homozygous (Type III units in both) |
| I x III | heterozygous | heterozygous |

In this mission the cassette is not in the assembly, so you will
not see these patterns in your VCF. Instead, you will look for the
cassette directly in the reads in Step 6.

#### Cassette extraction and resonance

Once you have identified which contig contains the mating-type locus,
you can extract the 48 bp cassette sequence and feed it to the
resonance tools. The resonance tools compute the cassette period
(the smallest unit that tiles the full 48 bp exactly), convert it
to a frequency using `freq_Hz = 4800 / period_bp`, and produce
audio and visual output.

A cassette with no single whole-cassette period is a chimera. The
resonance tool will detect this, split the cassette in half, and
report the two sub-periods separately.

---

### TUTORIAL -- Variant calling and clustering with yeast chrI data

In this tutorial you call variants across 9 simulated yeast
individuals in 3 groups (A, B, C) and recover the group structure
using PCA clustering.

```bash
cd /work
mkdir -p tutorial_data/yeast/session_07/alignments
mkdir -p tutorial_data/yeast/session_07/vcf
mkdir -p tutorial_data/yeast/session_07/results
```

#### Step 1 -- Index the yeast reference

```bash
samtools faidx tutorial_data/yeast/scerevisiae_chrI.fasta
```

#### Step 2 -- Align all 9 yeast individuals

```bash
for FILE in tutorial_data/yeast/population/reads/yeast_*_R1.fq; do
  NAME=$(basename ${FILE} _R1.fq)
  minimap2 -ax sr -t 4 \
    tutorial_data/yeast/scerevisiae_chrI.fasta \
    tutorial_data/yeast/population/reads/${NAME}_R1.fq \
    tutorial_data/yeast/population/reads/${NAME}_R2.fq \
    | samtools sort \
    -o tutorial_data/yeast/session_07/alignments/${NAME}.bam
  samtools index \
    tutorial_data/yeast/session_07/alignments/${NAME}.bam
  echo "Aligned ${NAME}"
done
```

#### Step 3 -- Call variants

```bash
bcftools mpileup \
  -f tutorial_data/yeast/scerevisiae_chrI.fasta \
  tutorial_data/yeast/session_07/alignments/*.bam \
  | bcftools call -mv \
  -o tutorial_data/yeast/session_07/vcf/variants.vcf

bcftools stats tutorial_data/yeast/session_07/vcf/variants.vcf \
  | grep "^SN"
```

How many SNPs were called? You designed 80 background + 90 private
(30 per group) = 170 SNPs. Expect to recover most of them.

#### Step 4 -- Build the genotype matrix

```bash
python3 -c "
import csv

samples, sites = [], []
with open('tutorial_data/yeast/session_07/vcf/variants.vcf') as f:
    for line in f:
        if line.startswith('##'):
            continue
        cols = line.rstrip().split('\t')
        if line.startswith('#CHROM'):
            samples = cols[9:]
            continue
        gts = []
        for field in cols[9:]:
            gt = field.split(':')[0].replace('|','/')
            gts.append({'0/0':0,'0/1':1,'1/0':1,'1/1':2}.get(gt, 0))
        sites.append([cols[0]+':'+cols[1]] + gts)

with open('tutorial_data/yeast/session_07/results/genotype_matrix.csv',
          'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(['pos'] + samples)
    w.writerows(sites)
print(f'{len(sites)} variant sites x {len(samples)} individuals')
"
```

#### Step 5 -- Cluster individuals

```bash
cluster_population \
  --genotypes \
    tutorial_data/yeast/session_07/results/genotype_matrix.csv \
  --k 3 \
  --out-plot \
    tutorial_data/yeast/session_07/results/yeast_clusters.html \
  --out-table \
    tutorial_data/yeast/session_07/results/yeast_clusters.csv
```

Open `tutorial_data/yeast/session_07/results/yeast_clusters.html`
from your own machine. Hover over each point. The three groups
(A, B, C) should form distinct clusters. If they do not, check
whether the variant calling recovered enough private SNPs.

#### Tutorial checkpoint

```bash
echo "Session 07 tutorial: yeast variant calling and clustering complete." \
  >> mission_data/logs/mission_log.txt
```

---

### MAIN MISSION -- Population structure and the mating-type locus

```bash
cd /work/mission_data
mkdir -p session_07/alignments
mkdir -p session_07/vcf
mkdir -p session_07/results
```

#### Step 1 -- Index the alien reference assembly

```bash
samtools faidx session_03/assembly/contigs.fasta
```

#### Step 2 -- Align all 15 individuals to the assembly

```bash
for FILE in population/ind_*_R1.fq; do
  NAME=$(basename ${FILE} _R1.fq)
  minimap2 -ax sr -t 4 \
    session_03/assembly/contigs.fasta \
    population/${NAME}_R1.fq \
    population/${NAME}_R2.fq \
    | samtools sort -o session_07/alignments/${NAME}.bam
  samtools index session_07/alignments/${NAME}.bam
  echo "Aligned ${NAME}"
done
```

This takes 15--25 minutes for all 15 individuals.

#### Step 3 -- Call variants

First, tell bcftools the ploidy of each individual. The samples
file has two columns: the sample name and its ploidy. Without read
groups, bcftools names each sample after its BAM file, so the file
can be built from the list of BAM files. Diploid names contain
`_D0`; everyone else is haploid:

```bash
ls session_07/alignments/*.bam \
  | awk '{print $0 "\t" (($0 ~ /_D0/) ? 2 : 1)}' \
  > session_07/ploidy.txt

cat session_07/ploidy.txt
```

Check that the six `_D0` individuals have a 2 and the other nine a 1.
Now call variants:

```bash
bcftools mpileup \
  -f session_03/assembly/contigs.fasta \
  session_07/alignments/*.bam \
  | bcftools call -mv \
    -S session_07/ploidy.txt \
    -o session_07/vcf/variants.vcf

bcftools stats session_07/vcf/variants.vcf | grep "^SN"
```

How many SNPs and how many indels were called? Many of the indels
are not real differences between individuals. They are positions
where the assembly itself has an error, so every individual
disagrees with it. For population structure we keep only
**biallelic SNPs** (sites with exactly one alternative base):

```bash
bcftools view -v snps -m2 -M2 \
  session_07/vcf/variants.vcf \
  -o session_07/vcf/snps.vcf

bcftools stats session_07/vcf/snps.vcf | grep "^SN"
```

`-v snps` keeps SNPs only; `-m2 -M2` keeps sites with exactly two
alleles. Look at a few genotype calls:

```bash
grep -v "^#" session_07/vcf/snps.vcf | head -3 | cut -f 10-
```

Haploid genotypes are now written with a single allele (`0` or `1`)
and diploid genotypes with two (`0/0`, `0/1`, `1/1`).

#### Step 4 -- Build the genotype matrix

```bash
python3 -c "
import csv

code = {'0': 0, '1': 2,
        '0/0': 0, '0/1': 1, '1/0': 1, '1/1': 2}

samples, sites, skipped = [], [], 0
with open('session_07/vcf/snps.vcf') as f:
    for line in f:
        if line.startswith('##'):
            continue
        cols = line.rstrip().split('\t')
        if line.startswith('#CHROM'):
            samples = cols[9:]
            continue
        gts = [code.get(field.split(':')[0].replace('|', '/'))
               for field in cols[9:]]
        if None in gts:
            skipped += 1
            continue
        sites.append([cols[0] + ':' + cols[1]] + gts)

with open('session_07/results/genotype_matrix.csv', 'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(['pos'] + samples)
    w.writerows(sites)
print(f'{len(sites)} variant sites x {len(samples)} individuals')
print(f'{skipped} sites skipped because of a missing genotype')
"
```

Each genotype becomes a number: how many copies of the alternative
allele, scaled so that haploids and diploids are comparable. A
haploid carrying the alternative allele (`1`) counts as 2, the same
as a diploid homozygous for it (`1/1`); a diploid heterozygote
(`0/1`) counts as 1, halfway between its two parents. Sites where
any individual has a missing genotype (`.`) are skipped rather than
guessed.

#### Step 5 -- Cluster individuals by genotype

```bash
cluster_population \
  --genotypes session_07/results/genotype_matrix.csv \
  --k 3 \
  --out-plot session_07/results/population_clusters.html \
  --out-table session_07/results/population_clusters.csv
```

Open `session_07/results/population_clusters.html` from your own
machine. Hover over each point to see the individual name. How many
clusters? Which individuals are in each cluster? Where do the diploid
individuals (names containing `_D`) sit relative to the haploid
clusters? Does each diploid lie between the two mating types in its
name?

#### Step 6 -- Find the mating-type cassette

The mating-type cassette is a 48 bp tandem repeat. The Type I repeat
unit is 8 bp long: `ATCGGCTA`.

**6a -- Check whether the cassette is in your assembly.** Search for
two consecutive Type I units:

```bash
seqkit locate -i -p ATCGGCTAATCGGCTA \
  session_03/assembly/contigs.fasta | head -5
```

The `-i` flag makes the search case-insensitive, because repeats are
often written in lowercase (soft-masked) in assemblies.

If this prints only the header line (`seqID patternName pattern ...`)
and no results, the cassette is **not in your assembly**. This is
normal. Short tandem repeats are among the hardest regions to
assemble: assemblers often collapse identical repeat units, break
contigs at them, or drop them altogether when coverage is low.
When a region is missing from the assembly, go back to the raw reads,
which still contain it.

**6b -- Recover the cassette directly from the reads.** Pull out
every 48 bp stretch that begins with three Type I units, from all
individuals and on both strands, and count how often each distinct
sequence appears:

```bash
{ seqkit seq -s -w 0 population/ind_*_R?.fq
  seqkit seq -s -w 0 -r -p population/ind_*_R?.fq
} | grep -oE "(ATCGGCTA){3}.{24}" \
  | sort | uniq -c | sort -rn \
  > session_07/results/cassette_candidates.txt

head session_07/results/cassette_candidates.txt
```

The first `seqkit seq` prints the reads as plain sequences; the second
prints their reverse complements (`-r -p`), because about half of the
reads covering the cassette come from the opposite strand. Sequences
supported by many reads are real cassettes. Sequences seen only once
or twice are usually sequencing errors or reads that start partway
through the cassette.

You should see two abundant sequences. Compare them with the Type I
reference cassette. One of them is Type I. The other is the cassette
you are looking for. Save it:

```bash
TYPE_I=$(grep -A1 "typeI$" reference_cassettes_I_III.fasta | tail -1)

MY_CASSETTE=$(awk -v ref="${TYPE_I}" '$2 != ref {print $2; exit}' \
  session_07/results/cassette_candidates.txt)

echo "${MY_CASSETTE}"
echo -n "${MY_CASSETTE}" | wc -c    # must print 48
```

The `awk` command takes the most abundant candidate that is not the
Type I reference. Look at the sequence: does it repeat cleanly all
the way through?

*Optional:* which individuals carry this cassette? Its second half
alone is not unique: Type III cassettes contain the same units. What
is unique is the **junction**, where the first-half units meet the
second-half units. Count the reads containing the middle 24 bp in
each individual and compare with the names (`_typeI`, `_IxII`, ...)
and with your clusters from Step 5:

```bash
JUNCTION=${MY_CASSETTE:12:24}
for FILE in population/ind_*_R1.fq; do
  echo "$(basename ${FILE} _R1.fq): $(grep -c ${JUNCTION} ${FILE})"
done
```

Which individuals have reads spanning the junction? Which crosses
should, according to the table in the lecture?

(This counts forward-strand matches in R1 only, so treat the numbers
as a lower bound.)

#### Step 7 -- Compute resonance for all cassette combinations

The course provides Type I and Type III reference cassettes. Use
the batch tool to test all combinations including your extracted
cassette. `MY_CASSETTE` was set in Step 6b. If you have opened a new
terminal since then, rerun the Step 6b commands first.

```bash
TYPE_I=$(grep -A1 "typeI$" reference_cassettes_I_III.fasta | tail -1)
TYPE_III=$(grep -A1 "typeIII" reference_cassettes_I_III.fasta | tail -1)

if [ ${#MY_CASSETTE} -ne 48 ]; then
  echo "MY_CASSETTE is not 48 bp -- go back to Step 6b"
fi

cat > session_07/my_cassettes.csv << EOF
I,${TYPE_I}
III,${TYPE_III}
extracted,${MY_CASSETTE}
EOF

python3 scripts/resonance_batch.py \
  --cassettes session_07/my_cassettes.csv \
  --outdir session_07/results/resonance_batch/

cat session_07/results/resonance_batch/index.csv
```

Open the `.html` and `.png` files in `session_07/results/resonance_batch/`
to see the waveforms and frequency bar charts for each pair.

*Troubleshooting:* if every pair involving `extracted` shows no
frequency (`freqs_b=[]`) and `extracted_vs_extracted` is skipped,
the tool did not receive a DNA sequence. Check that
`cat session_07/my_cassettes.csv` shows a 48 bp sequence on the
`extracted` line.

> ARIADNE-7: "I will not tell you what the extracted cassette is.
> Look at the frequency analysis. If the batch tool reports 'no
> single whole-cassette period' for the extracted cassette, split it
> in half and check each half separately. Think about what it means
> for a cassette to carry two different period signals. Think about
> which mating types it could be compatible with. The data will
> answer the question. I am confident of this."

#### Step 8 -- Update your mission log

```bash
N_CLUSTER=$(awk -F',' 'NR>1 {print $4}' \
  session_07/results/population_clusters.csv \
  | sort | uniq -c | sort -rn | head -1 | awk '{print $1}')

echo "Session 07: variant calling and population clustering complete." \
  >> logs/mission_log.txt
echo "Largest cluster size: ${N_CLUSTER}" \
  >> logs/mission_log.txt
echo "Mating-type cassette extracted and resonance computed." \
  >> logs/mission_log.txt
```

---

### MISSION DEBRIEF

You have identified three population clusters corresponding to three
mating types. The mating-type locus contains a 48 bp tandem repeat
cassette whose period encodes a frequency. Two cassettes have clean
repeat structures (Types I and III, at 600 Hz and 400 Hz, a 3:2
consonant ratio). The third cassette carries no single whole period --
it is a chimera of the other two, with Type I's 8 bp unit in the
first half and Type III's 12 bp unit in the second half.

The resonance detected in session 1 was compatibility signalling.
The aurora creates the conditions under which mating occurs. The
organism does not mate at random -- it signals compatibility through
frequency-encoded sequences in its mating-type locus.

The previous surveys found nothing because the organism was silent
during auroral quiet. Its most characteristic behaviour only occurs
during surges. We catalogued it as dead twice. It was never dead.
We were not listening at the right time.

---

### GATE QUESTION -- Session 7

```bash
ariadne submit --session 7
```

> ARIADNE-7: "How many individuals are in the largest cluster?
> Check your population_clusters.csv file."

*Hint: `awk -F',' 'NR>1 {print $4}' session_07/results/population_clusters.csv | sort | uniq -c`*

---

### REFERENCE -- Session 7 commands

| Command | What it does |
|---|---|
| `samtools faidx ref.fasta` | Index a reference FASTA |
| `minimap2 -ax sr ref.fasta R1.fq R2.fq \| samtools sort -o out.bam` | Align paired reads |
| `samtools index file.bam` | Index a BAM file |
| `bcftools mpileup -f ref.fasta *.bam \| bcftools call -mv -o out.vcf` | Call variants |
| `bcftools call -mv -S ploidy.txt` | Call variants with per-sample ploidy |
| `bcftools view -v snps -m2 -M2 in.vcf -o out.vcf` | Keep biallelic SNPs only |
| `bcftools stats file.vcf \| grep "^SN"` | Summary statistics from VCF |
| `seqkit locate -i -p PATTERN assembly.fasta` | Find a sequence pattern (case-insensitive) |
| `seqkit seq -s -w 0 reads.fq` | Print reads as plain sequences |
| `seqkit seq -s -w 0 -r -p reads.fq` | Print reverse complements of reads |
| `grep -oE "REGEX"` | Print only the matching part of each line |
| `samtools faidx assembly.fasta CONTIG:START-END` | Extract a region |
| `cluster_population --genotypes in.csv --k 3 --out-plot out.html --out-table out.csv` | PCA + KMeans clustering |
| `python3 scripts/resonance_batch.py --cassettes in.csv --outdir dir` | All-pairs resonance |
| `ariadne submit --session 7` | Submit gate answer |
