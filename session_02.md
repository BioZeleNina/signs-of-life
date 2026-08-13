---
title: "Session 2: first light"
nav_order: 5
---

# SESSION 2 -- First light
## *Something came through the sequencer. It is not ACGT.*

---

### MISSION BRIEFING

The aurora has quieted. Magnetospheric flux is at 4.1 nT, down from
7.3 at peak. ARIADNE-7 estimates a stable window of approximately six
hours before the next surge.

You sequenced during the storm. You had no choice -- the polymer
degrades in sunlight and you needed to capture it. The sequencer did
its best. The results are in `scan_01.alien.fq`.

You also attempted a second scan thirty minutes later. The aurora
was still active. The results are in `scan_02.alien.fq`. ARIADNE-7
has opinions about this second file. She is probably right.

Before you can do anything with these files, you need to understand
what a sequencing file actually is, what quality means, and why the
sequence is not in the alphabet you expected.

> ARIADNE-7: "I want to be clear that I recommended waiting for the
> aurora to subside before sequencing. I also want to be clear that
> the data from scan_01 is usable. Barely. But usable. I have already
> run preliminary statistics. I will share them when you ask."

---

### PRE-MISSION LECTURE -- Sequencing technologies and data quality

#### How sequencing works

DNA sequencing has gone through three generations of technology, each
with different strengths and limitations. Understanding which
technology produced your data tells you what kind of errors to expect
and how to handle them.

**First generation: Sanger sequencing (1970s--present)**
The gold standard for accuracy. A single reaction reads one fragment
of up to approximately 1,000 base pairs with very low error rates.
Still used today for verifying specific sequences. Too slow and
expensive for whole-genome analysis.

**Second generation: short-read sequencing (2000s--present)**
The most widely used technology today. Illumina's sequencing-by-
synthesis produces millions of short reads (typically 150--300 bp)
in parallel, with very high accuracy (error rate under 0.1%). The
short read length is the main limitation: repetitive regions and
structural variants are difficult to resolve.

**Third generation: long-read sequencing (2010s--present)**
Oxford Nanopore Technologies (ONT) and Pacific Biosciences (PacBio)
produce reads of tens of thousands of base pairs. Read length
resolves many problems short reads cannot. The trade-off is higher
error rates (ONT: typically 5--15% per base) and lower throughput
per instrument.

The ship's sequencer is an advanced ONT-type instrument. It reads
electrical current disruption as a polymer strand threads through a
protein pore. Crucially, it does not need to recognise specific base
chemistry -- it only needs the subunits to be regular and
distinguishable. This is why it can sequence an alien polymer: the
machinery is agnostic to what the bases are, as long as they produce
different current signatures.

Useful background videos (watch before or after the session):

- "How Oxford Nanopore sequencing works" (Oxford Nanopore
  Technologies, official, approximately 4 minutes)
- "Illumina Sequencing by Synthesis" (Illumina official,
  approximately 5 minutes)

#### The FASTQ format

Every sequencing read is stored as four lines in a FASTQ file:

```
@read_name additional_information
SEQUENCE
+
QUALITY_SCORES
```

Line 1 starts with `@` and contains the read identifier and metadata.
Line 2 contains the sequence itself.
Line 3 is always `+` (a separator).
Line 4 contains quality scores, one character per base.

Quality scores use Phred+33 encoding: the ASCII value of each
character minus 33 gives the Phred quality score Q. Q20 means a 1%
error probability; Q30 means 0.1%.

For Illumina data, Q30 across most bases is a reasonable threshold.
For ONT data, Q12--Q20 is normal and expected. Do not apply Illumina
quality expectations to ONT data.

#### Adapters

Library preparation attaches short synthetic sequences ("adapters")
to both ends of each DNA fragment. The sequencer uses these to
identify and orient reads. After sequencing, adapters must be trimmed
because they are not biological sequence.

The ship's library prep kit uses Earth-chemistry adapters. They work
on the alien polymer because ligation requires only a 3'-OH group and
a 5'-phosphate end -- a structural requirement, not a sequence-
specific one. The alien polymer has both.

This means adapter sequences appear in reads as ACGT characters even
though the biological sequence is in the alien alphabet. In a file encoded in the alien alphabet,
any ACGT you see is almost certainly adapter sequence.

#### FastQC and what it tells you

FastQC is the standard tool for assessing sequencing data quality. It
produces an HTML report with multiple modules. The most important for
this session:

- **Per base sequence quality**: Phred score at each position along
  the read. Should be consistently high. A drop toward the 3' end is
  normal for both Illumina and ONT; a catastrophic drop suggests a
  problem with the sequencing run.
- **Per sequence quality scores**: Distribution of mean quality per
  read. Should be a tight peak at the high end.
- **Per base sequence content**: Base composition at each position.
  Should be roughly even for a genomic library. Systematic bias early
  in reads is normal for some library prep protocols.
- **Adapter content**: Presence of known adapter sequences. FastQC
  knows about Illumina adapters by default; ONT adapters may appear
  in "Overrepresented sequences" instead.
- **Overrepresented sequences**: Any sequence making up more than 0.1%
  of reads. Adapters, primers, and contamination show up here.

---

### TUTORIAL -- Quality control of ONT yeast reads

In this tutorial you will assess and trim ONT reads from *Saccharomyces
cerevisiae* (baker's yeast). The commands and concepts are identical
to what you will use on the alien data.

All commands run inside the Docker container. Start it if you have not
already done so (see [session 0: setup](https://biozelenina.github.io/signs-of-life/session_00_setup)).

```bash
cd /work
```

#### Step 1 -- Navigate to the tutorial directory

```bash
cd tutorial_data/yeast
ls -lh
```

You should see files including `scerevisiae_chrI_ont.fastq` (clean
reads) and `scerevisiae_chrI_ont_dirty.fastq` (reads with adapter
contamination and quality degradation added deliberately for this
exercise).

#### Step 2 -- Inspect the raw files

```bash
head -8 scerevisiae_chrI_ont.fastq
```

Read the output carefully. Identify:
- The header line (starts with `@`)
- The sequence line
- The separator (`+`)
- The quality string (same length as the sequence)

```bash
seqkit stats scerevisiae_chrI_ont.fastq
```

Note the number of reads, total length, and average read length.
ONT reads vary considerably in length -- the min and max lengths
tell you the range of your library.

#### Step 3 -- Run FastQC on the clean reads

```bash
mkdir -p fastqc_results

fastqc scerevisiae_chrI_ont.fastq \
  --outdir fastqc_results \
  --threads 4
```

Open the HTML report from your own machine (it is in
`tutorial_data/yeast/fastqc_results/`). Look at:
- Per base sequence quality: ONT reads have lower Q scores than
  Illumina -- Q10--Q20 is normal here, not a problem
- Per sequence quality scores: the distribution of mean quality
- Adapter content: probably clean in this file
- Overrepresented sequences: probably none

Note your observations in your mission log. To add a quick note:

```bash
echo "Session 02 tutorial: FastQC on clean ONT reads -- [your observations here]" \
  >> /work/mission_data/logs/mission_log.txt
```

To write a longer entry, open the log in nano:

```bash
nano /work/mission_data/logs/mission_log.txt
```

In nano: arrow keys to move to the end, type your notes, then
`Ctrl+O` to save and `Ctrl+X` to exit.

#### Step 4 -- Run FastQC on the contaminated reads

```bash
fastqc scerevisiae_chrI_ont_dirty.fastq \
  --outdir fastqc_results \
  --threads 4
```

Open this report and compare it to the clean one. What is different?
Look specifically at:
- Per base sequence quality at the 3' end
- Overrepresented sequences
- The total number of reads vs the clean file

Note: FastQC does not know about ONT adapter sequences by default.
ONT adapters will appear in "Overrepresented sequences" if they are
present, rather than in "Adapter content."

#### Step 5 -- Trim adapters from the contaminated reads

For ONT reads, use fastp with adapter sequences specified explicitly.
Quality filtering is disabled because ONT quality scores are
inherently lower than Illumina -- applying an Illumina quality filter
to ONT data removes almost all reads.

```bash
fastp \
  --in1 scerevisiae_chrI_ont_dirty.fastq \
  --out1 scerevisiae_chrI_ont_trimmed.fastq \
  --adapter_sequence AATGTACTTCGTTCAGTTACGTATTGCT \
  --disable_quality_filtering \
  --length_required 100 \
  --thread 4 \
  --json fastp_ont.json \
  --html fastp_ont.html
```

Open `fastp_ont.html` from your own machine. How many reads were
removed? What were they removed for?

#### Step 6 -- Run FastQC on the trimmed reads

```bash
fastqc scerevisiae_chrI_ont_trimmed.fastq \
  --outdir fastqc_results \
  --threads 4
```

Compare the three reports: clean, dirty, trimmed. The trimmed report
should be cleaner than dirty but may not be identical to clean.

#### Step 7 -- Add to your mission log

```bash
cd /work
echo "Session 02 tutorial: yeast ONT QC complete." \
  >> mission_data/logs/mission_log.txt
```

Record the read counts before and after trimming, and any observations
from the FastQC reports.

> ARIADNE-7: "Good. You have seen what a quality problem looks like
> and what trimming does. The alien data will be more interesting.
> Less straightforward. I recommend keeping your mission log detailed
> from this point onward."

---

### MAIN MISSION -- What came through the sequencer?

Now apply what you have learned to the alien data.

```bash
cd /work/mission_data
mkdir -p session_02
```

#### Step 1 -- Examine the alien scan files

```bash
ls -lh scan_01.alien.fq scan_02.alien.fq
```

```bash
head -8 scan_01.alien.fq
```

Note the sequence characters. They are not ACGT. Note the quality
string. It is normal Phred+33 encoding.

```bash
seqkit stats scan_01.alien.fq scan_02.alien.fq
```

Note the difference in read counts and total bases between the two
files.

#### Step 2 -- Run FastQC on the alien files

```bash
mkdir -p session_02/fastqc
fastqc scan_01.alien.fq --outdir session_02/fastqc --threads 4
fastqc scan_02.alien.fq --outdir session_02/fastqc --threads 4
```

Open both HTML reports. Pay attention to:
- Per base sequence quality: is scan_01 acceptable for ONT data?
- Per base sequence content: what do you notice about the base
  composition?
- Overrepresented sequences: are there any ACGT sequences present?

> ARIADNE-7: "I should note that FastQC will report this as a
> protein sequence because WXYZ are all valid IUPAC amino acid codes.
> This is incorrect. FastQC is guessing based on what it knows, and
> what it knows does not include alien nucleic acids. Your scan_01
> data contains ACGT adapter sequences mixed into an otherwise XZWY
> file. Those are the only ACGT you see. Note that."

Compare the scan_01 and scan_02 reports. Which file would you
proceed with? Why? Write your reasoning in your mission log.

#### Step 3 -- Decode the alien alphabet

The ship's sequencer maps each alien current signature to the nearest
Earth base as a default output format. The actual polymer uses a
different four-letter alphabet. To work with standard tools, you
need to transcode it back to ACGT.

The `transcode` command will ask you to enter the base-pairing you
derived from the data (base composition + complementarity in the scan
file). If your answer is correct, it decodes the file. If not, it
gives you a hint and asks you to try again.

To decode the cipher systematically, count the frequency of each
alien character across the reads:

```bash
grep -v "^[@+]" scan_01.alien.fq \
  | grep -o "[WXYZ]" \
  | sort \
  | uniq -c \
  | sort -rn
```

This prints how many times each alien letter appears, sorted from
most to least frequent.

Now reason from what you know about nucleic acid chemistry:

- In any double-stranded nucleic acid, A pairs with T and C pairs
  with G. This means A and T occur at similar frequencies, and C
  and G occur at similar frequencies.
- The genome of this organism has a very low G and C analogue content (you will
  measure this precisely in session 3). This means A and T analogues together
  make up the vast majority of bases.

From this: the two most abundant alien letters correspond to A and T.
The two least abundant correspond to C and G. Within each pair,
base-pairing rules and strand composition can help you narrow down
which letter is which.

When you are ready, enter your best mapping:

```bash
transcode --in scan_01.alien.fq --out session_02/scan_01_decoded.fq
```

ARIADNE-7 will prompt for the W, X, Y, Z mapping.

After decoding, verify no alien characters remain:

```bash
grep -v "^[@+]" session_02/scan_01_decoded.fq | grep -c "[WXYZ]"
```

This should return 0.

#### Step 4 -- Run FastQC on the decoded file

```bash
fastqc session_02/scan_01_decoded.fq \
  --outdir session_02/fastqc --threads 4
```

Open this report. Now that the sequences are in ACGT, FastQC can
interpret them correctly. Look at the adapter content and
overrepresented sequences. As noted earlier in this session, FastQC
does not know about ONT adapter sequences, so the adapters will not
appear in the Adapter Content module. Instead, look for them in the
Overrepresented Sequences module -- the ACGT adapter sequences should
now appear clearly there, since they are the only ACGT content in
what was otherwise an alien-alphabet file.

> ARIADNE-7: "The adapters are from the ship's library prep kit.
> Earth-chemistry adapters. They ligate to any polymer with a 3'-OH
> and 5'-phosphate terminus -- a structural requirement, not a
> sequence-specific one. The alien polymer has both. This should
> have surprised me more than it did."

#### Step 5 -- Trim the decoded file

```bash
fastp \
  --in1 session_02/scan_01_decoded.fq \
  --out1 session_02/scan_01_trimmed.fq \
  --adapter_sequence AATGTACTTCGTTCAGTTACGTATTGCT \
  --disable_quality_filtering \
  --length_required 200 \
  --thread 4 \
  --json session_02/fastp_scan01.json \
  --html session_02/fastp_scan01.html
```

```bash
seqkit stats \
  scan_01.alien.fq \
  session_02/scan_01_decoded.fq \
  session_02/scan_01_trimmed.fq
```

Note the three read counts. The trimmed file will be your input for
session 3 assembly.

#### Step 6 -- Update your mission log

```bash
echo "Session 02 mission: scan_01 decoded and trimmed." \
  >> mission_data/logs/mission_log.txt

echo "Reads after trimming: [paste the number from seqkit stats]" \
  >> mission_data/logs/mission_log.txt

echo "scan_02 rejected: [give your reason]" \
  >> mission_data/logs/mission_log.txt
```

---

### MISSION DEBRIEF

**What you found:** The scan files use a four-letter non-ACGT
alphabet. Base composition analysis and complementarity allowed
derivation of the cipher. scan_02 shows substantially degraded quality
consistent with sequencing during residual aurora activity. scan_01 is
usable after adapter trimming.

**What The adapter sequences tell you:** the library prep kit worked
on the alien polymer without modification. Ligation chemistry is
substrate-agnostic; only the terminal groups matter. This implies
the alien polymer shares at least the backbone chemistry necessary
for enzymatic extension.

**The key decision:** you have chosen to proceed with scan_01 and
rejected scan_02. That decision and its justification should be in
your mission log.

**Reproducibility check:** Are your trim parameters in your mission
log? Could someone reproduce your trimmed file from your notes alone?

---

### GATE QUESTION -- Session 2

```bash
ariadne submit --session 2
```

> ARIADNE-7: "How many reads remain in scan_01 after trimming?
> I will accept the number from seqkit stats. Just the number,
> no units."

*Hint if needed: run `seqkit stats session_02/scan_01_trimmed.fq`
and read the num_seqs column.*

---

### REFERENCE -- Commands used in this session

| Command | What it does |
|---|---|
| `head -N file` | Print the first N lines |
| `seqkit stats file` | Read count, length statistics |
| `fastqc file --outdir dir` | Run quality assessment, produce HTML report |
| `fastp --in1 IN --out1 OUT --adapter_sequence SEQ --disable_quality_filtering --length_required N` | Trim adapters from ONT reads |
| `transcode --in IN --out OUT` | Decode alien alphabet to ACGT (gated) |
| `grep -v "^[@+]" file \| grep -c "[XZWY]"` | Count alien characters remaining after decode |
| `ariadne submit --session 2` | Submit gate answer |
| `ariadne hint --session 2` | Get a hint |
