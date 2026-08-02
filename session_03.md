---
title: "Session 3: building a map"
nav_order: 6
---

# SESSION 3 -- Building a map
## *32,000 reads. Each one a fragment. Put them together.*

---

### MISSION BRIEFING

You have 32,477 trimmed reads from scan_01. Each read is a fragment of
the alien genome -- a random piece, sequenced from a random location.
To do anything useful with this data, you need to assemble those
fragments into something coherent: a reference sequence you can map
against, annotate, and search.

This is genome assembly. You will not get a perfect reconstruction.
No assembly ever is perfect, especially from a single sequencing run
of an unknown organism. What you will get is a set of contiguous
sequences (contigs) that cover most of the genome and are good enough
for everything that follows.

ARIADNE-7 has already looked at the data.

> ARIADNE-7: "459 contigs. 1.49 megabases. N50 of approximately
> 16 kilobases. For a first-pass assembly from reads taken during
> an aurora surge, this is acceptable. I would have preferred more
> coverage. I would have preferred not to crash. We work with what
> we have."

---

### PRE-MISSION LECTURE -- How genome assembly works

#### The overlap-layout-consensus approach

Genome assembly takes millions of short or long overlapping reads and
reconstructs the original sequence by finding overlaps between them.
The basic idea: if read A ends with the same sequence that read B
begins with, they probably came from overlapping locations in the
genome. Follow these overlaps and you build longer sequences.

In practice, the algorithm builds a graph where each read is a node
and overlaps are edges. Paths through this graph become contigs.
Ambiguities -- places where multiple paths are possible, due to
repeats or low coverage -- result in the graph breaking into separate
contigs rather than resolving to one.

**SPAdes** (St. Petersburg genome assembler) is the assembler used
in this session. It was originally designed for short reads but
handles long reads well when used with the `--careful` flag.

#### Assembly statistics and what they mean

After assembly, you assess quality with statistics:

- **Number of contigs:** Fewer is generally better (fewer breaks in
  the assembly), though very long genomes with many repeats may
  necessarily produce many contigs.
- **Total length:** Should be close to the expected genome size.
- **N50:** The length such that contigs of that length or longer
  account for half the total assembly length. Higher is better.
  Think of it as a weighted median contig length.
- **Largest contig:** The longest single assembled sequence.
- **GC content:** Should match the expected value for the organism
  (if known). Large deviations suggest contamination.

#### Coverage and why it matters

Coverage is the average number of reads that cover each base of the
genome. More coverage generally produces better assemblies, up to a
point. Too little coverage leaves gaps; too much can cause assembler
confusion from redundancy.

For a 1.5 Mb genome with 32,477 reads averaging 2,081 bp, the
coverage is approximately: (32,477 * 2,081) / 1,500,000 = ~45x.
This is a reasonable coverage for assembly.

---

### TUTORIAL -- Assembling yeast chromosome I

In this tutorial you assemble the *S. cerevisiae* chromosome I Illumina
reads. This gives you practice with SPAdes and assembly assessment
before working with the alien data.

```bash
cd /work
mkdir -p tutorial_data/yeast/assembly
```

#### Step 1 -- Inspect the tutorial reads

```bash
seqkit stats tutorial_data/yeast/scerevisiae_chrI_R1.fq
```

Note the read count, read length, and total bases. Calculate the
expected coverage: (reads * read_length) / genome_size.

For S. cerevisiae chromosome I (~230 kb at 30x coverage):
expected reads = (230,000 * 30) / 150 = approximately 46,000 reads.

#### Step 2 -- Run SPAdes

```bash
spades.py \
  -1 tutorial_data/yeast/scerevisiae_chrI_R1.fq \
  -2 tutorial_data/yeast/scerevisiae_chrI_R2.fq \
  -o tutorial_data/yeast/assembly \
  --careful \
  -t 4
```

SPAdes will print progress as it runs. This may take 5--10 minutes.
The key output file is `tutorial_data/yeast/assembly/contigs.fasta`.

#### Step 3 -- Assess the assembly

```bash
seqkit stats -a tutorial_data/yeast/assembly/contigs.fasta
```

Look at N50, total length, and number of contigs. For a 230 kb
chromosome at 30x coverage, a good assembly will have few contigs and
an N50 close to 230 kb (ideally one or two contigs total).

#### Step 4 -- Look at contig names

```bash
grep ">" tutorial_data/yeast/assembly/contigs.fasta | head -10
```

SPAdes names contigs `NODE_N_length_X_cov_Y` where N is the contig
number, X is the length in bp, and Y is the mean coverage depth.

```bash
echo "Session 03 tutorial: yeast assembly complete." \
  >> mission_data/logs/mission_log.txt
```

---

### MAIN MISSION -- Assembling the alien genome

```bash
cd /work/mission_data
mkdir -p session_03
```

#### Step 1 -- Check your input reads

```bash
seqkit stats session_02/scan_01_trimmed.fq
```

Confirm you have approximately 32,477 reads averaging ~2,081 bp.
If this file does not exist, return to session 2.

#### Step 2 -- Run SPAdes on the alien reads

SPAdes requires at least 2 GB of RAM. The container has sufficient
memory allocated by Docker Desktop.

```bash
spades.py \
  -s session_02/scan_01_trimmed.fq \
  -o session_03/assembly \
  --careful \
  -t 4
```

The `-s` flag (single-end) is used here because ONT reads are
single-end. This will take 10--20 minutes.

> ARIADNE-7: "SPAdes was not designed for ONT reads specifically.
> It will work. The assembly will not be perfect -- ONT error rates
> mean some edges in the assembly graph are ambiguous. 459 contigs
> from a 1.5 Mb genome is the expected result. Do not be alarmed."

#### Step 3 -- Assess the alien assembly

```bash
seqkit stats -a session_03/assembly/contigs.fasta
```

Record: number of contigs, total length, N50, largest contig, GC%.

```bash
grep ">" session_03/assembly/contigs.fasta | wc -l
```

```bash
grep ">" session_03/assembly/contigs.fasta | head -5
```

Is the GC content consistent with the scan_01 data? What is the
largest contig?

#### Step 4 -- Quick sanity check

The assembly should cover approximately 1.5 Mb (the size of the
region you are working with). Check that total length is in the right
range:

```bash
seqkit stats session_03/assembly/contigs.fasta \
  | awk '{print $5}'
```

If total length is far below 1.5 Mb, coverage may have been too low
for complete assembly. If far above, there may be contamination.

#### Step 5 -- Update your mission log

```bash
N50=$(seqkit stats -a session_03/assembly/contigs.fasta \
  | awk 'NR==2 {print $13}')
echo "Session 03: assembly complete. N50: ${N50} bp" \
  >> mission_data/logs/mission_log.txt
```

---

### MISSION DEBRIEF

You have a reference assembly. It is not perfect, but it is
sufficient for expression quantification, variant calling, and ORF
finding, all of which follow in later sessions.

The assembly statistics (N50 ~16 kb, total ~1.49 Mb, GC ~22.6%)
describe the quality and characteristics of your reference. Record
them. They will appear in your mission report.

---

### GATE QUESTION -- Session 3

```bash
ariadne submit --session 3
```

> ARIADNE-7: "What is the N50 of your assembly in base pairs?
> Round to the nearest hundred."

---

### REFERENCE -- Session 3 commands

| Command | What it does |
|---|---|
| `spades.py -s reads.fq -o outdir --careful -t 4` | Assemble single-end reads |
| `spades.py -1 R1.fq -2 R2.fq -o outdir --careful -t 4` | Assemble paired-end reads |
| `seqkit stats -a contigs.fasta` | Assembly statistics including N50 |
| `grep ">" contigs.fasta \| wc -l` | Count contigs |
| `grep ">" contigs.fasta \| head -N` | View first N contig headers |
