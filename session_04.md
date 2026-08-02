---
title: "Session 4: the code"
nav_order: 7
---

# SESSION 4 -- The code
## *Standard translation gives nonsense. The code is different.*

---

### MISSION BRIEFING

You have an assembled genome. The next step is finding the genes.

Gene finding requires translation -- converting DNA sequence to amino
acid sequence using the genetic code. The standard genetic code, used
by every organism on Earth, maps each three-nucleotide codon to a
specific amino acid (or a stop signal).

You try standard translation on the alien assembly. You get nonsense:
stop codons appearing every few codons in every reading frame. No
clean open reading frames. No recognisable proteins.

ARIADNE-7 finds this unsurprising.

> ARIADNE-7: "The genetic code is a biological convention. It is
> realised in the ribosome and tRNA machinery, not in the laws of
> physics. There are 64 codons and 20 amino acids plus stop signals.
> The assignment of codons to amino acids is, in principle, arbitrary.
> Earth life happened to settle on a particular assignment. This
> organism appears to have settled on a different one. This is
> scientifically interesting, not a problem."

Your task: work out the alien code.

---

### PRE-MISSION LECTURE -- The genetic code and ORF finding

#### What an open reading frame is

An open reading frame (ORF) is a stretch of DNA that begins with a
start codon and ends with a stop codon, with no stop codons
interrupting the reading in between. An ORF is a candidate gene.

In the standard genetic code, working with DNA sequences: ATG = start
(methionine), and TAA, TAG, TGA = stop. In mRNA the same codons are
written with U instead of T (AUG, UAA, UAG, UGA). ORF finders work
on DNA, so this course uses the DNA notation throughout.

For any DNA sequence, there are six possible reading frames: three on
the forward strand (starting at positions 1, 2, or 3) and three on
the reverse complement strand. A real gene occupies one of these
frames.

In a random sequence, a stop codon occurs on average every 21 codons
(3 stop codons out of 64). A real gene will have no internal stops
for hundreds of codons. Comparing ORF lengths between standard and
alien translation is how you know when you have the right code.

#### Codon usage bias

Different codons can encode the same amino acid (synonymous codons).
Organisms tend to use some synonymous codons more than others -- this
is codon usage bias. It arises from the relative abundance of
different tRNAs and affects translation efficiency.

Comparing codon frequencies between the known alien codon table and
the actual usage in your assembly is a way to verify the table is
correct.

#### GC content and the genetic code

GC content affects which codons are used. A low-GC genome like this
one (approximately 22%) will tend to use codons with A and T in the
third position. This is a useful sanity check.

---

### TUTORIAL -- ORF finding on yeast assembly

In this tutorial you find ORFs in the *S. cerevisiae* chromosome I
assembly using the standard genetic code.

```bash
cd /work
```

#### Step 1 -- Find ORFs with the standard code

```bash
find_orfs tutorial_data/yeast/assembly/contigs.fasta \
  --min-len 150 \
  > tutorial_data/yeast/orfs_standard.faa

grep "^>" tutorial_data/yeast/orfs_standard.faa | wc -l
```

The standard code should find many clean ORFs in yeast because yeast
uses the standard code. Note the count.

#### Step 2 -- Examine an ORF

```bash
head -4 tutorial_data/yeast/orfs_standard.faa
```

The FASTA header shows: contig name, strand (+/-), frame (0/1/2),
and start-end coordinates. The sequence is the translated amino acid
sequence.

```bash
echo "Session 04 tutorial: yeast ORF finding complete." \
  >> mission_data/logs/mission_log.txt
```

---

### MAIN MISSION -- Cracking the alien code

```bash
mkdir -p mission_data/session_04
```

#### Step 1 -- Try the standard code (expect garbage)

```bash
find_orfs mission_data/session_03/assembly/contigs.fasta \
  --min-len 150 \
  > mission_data/session_04/orfs_standard.faa

grep "^>" mission_data/session_04/orfs_standard.faa | wc -l
```

Compare this count to the yeast result. If the alien organism uses
a different genetic code, there should be far fewer long ORFs -- the
standard code will hit stop codons frequently, fragmenting what should
be long genes into short nonsense peptides.

#### Step 2 -- Examine the alien codon table

The instructor will provide the alien codon table as a "decoded tRNA
chart the ship reconstructed." This is the file `alien_codon_table.txt`.

```bash
head -5 mission_data/alien_codon_table.txt
```

Note the start codon (the entry marked with M that is different from
the standard ATG start) and the three stop codons (entries marked *).

What is the start codon? What are the stop codons?

> ARIADNE-7: "I find it notable that the stop codons in this code
> are codons that encode amino acids in the standard code. The start
> codon is a codon that encodes proline in the standard code. This
> organism evolved its ribosomal machinery independently. The
> arrangement is different but the logic is identical: define which
> codon initiates, which terminate, and everything else encodes.
> The genetic code is a solved problem, apparently solved twice."

#### Step 3 -- Find ORFs with the alien code

```bash
find_orfs mission_data/session_03/assembly/contigs.fasta \
  --table mission_data/alien_codon_table.txt \
  --min-len 150 \
  > mission_data/session_04/orfs_alien.faa

grep "^>" mission_data/session_04/orfs_alien.faa | wc -l
```

Compare the ORF count between standard and alien code. Which is higher?
Look at the longest ORFs:

```bash
grep "^>" mission_data/session_04/orfs_alien.faa \
  | sort -t- -k3 -n | tail -10
```

#### Step 4 -- Update your mission log

```bash
STD=$(grep "^>" mission_data/session_04/orfs_standard.faa | wc -l)
ALN=$(grep "^>" mission_data/session_04/orfs_alien.faa | wc -l)
echo "Session 04: ORFs with standard code: ${STD}" \
  >> mission_data/logs/mission_log.txt
echo "Session 04: ORFs with alien code: ${ALN}" \
  >> mission_data/logs/mission_log.txt
```

---

### MISSION DEBRIEF

The alien organism uses a permuted genetic code: the same 64-codon
structure as Earth life, but with different codon-to-amino-acid
assignments. Translating with the standard code produces frequent
spurious stops; translating with the alien code produces clean,
long ORFs consistent with functional genes.

This is both one of the strongest pieces of evidence that this is
genuine biology (random chemistry does not produce organised reading
frames), and a demonstration that the genetic code is contingent,
not inevitable.

---

### GATE QUESTION -- Session 4

```bash
ariadne submit --session 4
```

> ARIADNE-7: "List the three stop codons of the alien genetic code.
> Alphabetical order, separated by spaces."

---

### REFERENCE -- Session 4 commands

| Command | What it does |
|---|---|
| `find_orfs contigs.fasta --min-len N` | Find ORFs using standard genetic code |
| `find_orfs contigs.fasta --table table.txt --min-len N` | Find ORFs using custom code |
| `grep "^>" file.faa \| wc -l` | Count sequences in a FASTA |
