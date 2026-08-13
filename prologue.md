---
title: "Prologue"
nav_order: 1
permalink: /
---

![Signs of life course header -- a spaceship cockpit with an alien landscape and aurora visible through the viewport]({{ "/assets/header.png" | relative_url }})

# Signs of life
## A practical course in genomics and transcriptomics

---

> *"Space: the final frontier."*
>
> -- James T. Kirk

---

## TRANSMISSION LOG -- PERSONAL

From: Survey Scientist, Junior Grade II (that is you)  
To: FSA Rescue Coordination, Relay Station Theta-9  
Subject: Situation update, request for ETA, and an explanation

---

Greetings,

I will keep this brief because I am conserving power and also because
some of this is embarrassing.

You are aware that I filed a solo continuation request for Survey Mission XB-7734-DELTA approximately sixteen days ago. To recap for whoever is reading this without the file in front of them: the mission was a routine biosignature sweep cataloguing already-visited "dead" worlds to confirm they're lifeless before they're cleared for an intergalactic highway. The kind of mission that exists primarily to confirm paperwork. I was nearly finished.

My Senior Science Officer, Dr. Lennart Okafor, is not with me. This is
because Dr. Okafor received a routine inoculation booster at our last
supply stop and developed a reaction that caused him to turn a very
specific shade of chartreuse. Not metaphorically. His skin turned chartreuse.
The medical AI at the station described it as "extremely rare, entirely
non-dangerous, and visually spectacular." The Federation uniform code,
however, describes chartreuse as "non-regulation" and "a potential
source of command confusion in emergency situations," so Dr. Okafor was
technically required to remain at Relay Station Theta-9 until the
colour resolved, which the medical AI estimated would take "somewhere
between four and eleven days." He seemed fine about it. I left him in
good hands and with excellent snacks, and continued the mission alone.

This was, in retrospect, the first of several decisions I would
reconsider.

The second was not turning back when the aurora started.

The planet -- and I want to be clear that I had no reason to expect
this because the planet is on record as DEAD, confirmed DEAD, surveyed
TWICE and DEAD -- has an aurora. A significant one. The kind that
generates a magnetospheric flux reading of 7.3, which the ship's manual
describes as "avoid if possible" and which ARIADNE-7 describes, in her
usual understated fashion, as "inadvisable." I was nearly done. I kept
going. The aurora surged. The navigation array went offline. The ship
performed what I am officially logging as "an uncontrolled but
structurally intact landing" and what ARIADNE-7 is logging as "a
crash."

We are on the surface. The ship is fine. I am fine. ARIADNE-7 is fine
and has many thoughts about all of this.

The good news: the beacon fired automatically. You received it. Rescue
ETA is approximately fourteen days. I have sufficient food, water, and
power for twice that.

The less good news: during the aurora event, the ship's sensors logged
something that does not fit any abiotic model in the database. I have
been calling it "a signal" because I do not yet have a better word for
it. It is structured. It is periodic. It correlates with the aurora.
And when I sampled the surface material near the strongest readings, the
spectrophotometer returned a 260nm UV absorption profile that looks,
and I am aware of how this sounds, like a nucleic acid.

This planet is on record as dead.

I am not saying it is not dead. I am saying I would like to check.

I have a sequencer, a polymer sample, a ship's computer with strong
opinions, fourteen days, and nothing more pressing to do. I am going to
investigate.

Updates to follow.

-- Survey Scientist, Junior Grade II
(Name on file at Relay Station Theta-9, along with Dr. Okafor,
currently chartreuse)

---

> ARIADNE-7 ANNOTATION: I would like to add that I recommended turning
> back at the aurora. I also recommended not filing the solo
> continuation request. I have been correct about most things in this
> mission so far. I intend to continue being correct.
>
> Welcome aboard.

---

## ABOUT THIS COURSE

What you have just read is a fictional framing device for a real
bioinformatics course. The science is genuine. The methods are the ones
used in actual research. The data you will analyse was generated using
the same pipeline a researcher would use -- it just happens to describe
a fictional alien organism on a fictional planet that a fictional junior
scientist is now stuck on for two fictional weeks.

The framing exists because bioinformatics has a steep learning curve
and a motivational problem: it is difficult to care about a `for` loop
before you know what a `for` loop is for. The story gives you a reason
to care before you know enough to care for scientific reasons. By the
end of the course, you will have both.

---

## WHAT YOU WILL LEARN

This course covers eight active sessions (sessions 1--8), with sessions
9 and 10 reserved for Q&A, catch-up, mission log and report drafting, and reflection.

**Session 0 -- Equipment setup (home, before the course begins)**  
Install Docker and verify the ship's computer ARIADNE-7 responds.

**Session 1 -- The terminal and the file system**  
Why scientists use the command line. How files and directories are
organised. The habits of reproducible computational science.

Topics: bash, directories, navigation, file operations, text editing,
downloading from GitHub, mission logging.

**Session 2 -- Sequencing and quality control**  
How sequencing works, from Sanger to long-read nanopore technology.
What a FASTQ file is and what every part of its header means. How to
assess data quality and trim adapters. You will discover, in this
session, what the ship's sequencer captured -- and it will not be ACGT.

Topics: sequencing technologies, FASTQ format, quality scores, FastQC,
adapter trimming, base composition, complementarity.

**Session 3 -- Genome assembly**  
How overlapping reads become contiguous sequences. What assembly
statistics mean. How to assess completeness.

Topics: assembly algorithms, contigs, N50, coverage, SPAdes,
seqkit stats.

**Session 4 -- The genetic code**  
What an open reading frame is. How to find genes in an assembled
sequence. Why translating this genome with the standard genetic code
produces complete nonsense, and how to work out what the actual code
is.

Topics: ORFs, translation, genetic code, codon tables, GC content,
codon usage bias.

**Session 5 -- RNA-seq: mapping and expression**  
What RNA sequencing measures. How to align RNA reads to a reference
assembly. What read depth tells you about gene expression. First
encounter with the transcriptome.

Topics: RNA-seq, transcript quantification, minimap2, samtools,
coverage, salmon.

**Session 6 -- Differential expression**  
How to compare expression between conditions. Why most genes do not
change, and why the ones that do are the interesting ones. What the
aurora is actually doing to this organism.

Topics: differential expression, fold change, statistical testing,
aurora-on vs aurora-off, biological interpretation.

**Session 7 -- Population structure and variant calling**  
What genetic variants are. How to call them across many individuals.
How to use variant data to identify discrete groups. Why this organism
appears to have more than two mating types -- and what the signal from
session 1 has to do with that.

Topics: variant calling, VCF format, bcftools, PCA, clustering, mating
types, population structure, resonance.

**Session 8 -- Hypothesis testing and experimental design**  
How to frame a biological question as a testable hypothesis. How to
design a computational experiment that can answer it. What p-values
actually mean. How to communicate uncertainty honestly.

Topics: H0 and H1, t-tests, permutation tests, experimental design,
avoiding p-hacking.

**Sessions 9--10 -- Synthesis and transmission**  
Catch-up time. Q&A. Mission log and report drafting. Reflection.
Optional: the alien egg hunt (details in [the alien egg hunt](https://biozelenina.github.io/signs-of-life/alien_egg_hunt)).

---

## HOW EACH SESSION IS STRUCTURED

Almost every session follows the same pattern:

**Mission briefing** -- what has happened in the story, why you are
doing this analysis, what question you are trying to answer.

**Pre-mission lecture** -- the scientific concepts you need, explained
clearly and embedded in the narrative.

**Tutorial** -- you practice every skill in this session using a small
dataset from *Saccharomyces cerevisiae* (baker's yeast). All commands
are annotated. You can return to the tutorial at any time.

**Main mission** -- you apply the same analysis to the alien data, with
the same structure but less hand-holding. ARIADNE-7 comments throughout.

**Mission debrief** -- what you found, what it means, what to add to
your mission log.

**Gate question** -- one question per session, answered by running a
specific command and submitting the result with `ariadne submit
--session N`. You must pass the gate before the next session unlocks.

---

## WHAT YOU WILL WORK WITH

Each session has two phases. In the **tutorial phase**, you practice
with data from *Saccharomyces cerevisiae* (baker's yeast): small
genome, well-annotated, standard genetic code, fast to run. In the
**mission phase**, you apply the same skills to the alien data.

The alien data was generated using real bioinformatics simulation
tools, based on a real organism whose identity you are not told until
later. The tools you use are the same tools researchers use in real
studies. The workflows are realistic.

---

## WORKING WITH ARIADNE-7

ARIADNE-7 is the ship's computer. She is an AI with access to a
comprehensive biological database. Her factual statements about biology
are accurate. Her interpretations of data are not always correct --
she draws wrong conclusions from correct facts, states them
confidently, and occasionally doubles down when challenged. This is
intentional.

One of the most important skills in computational biology is knowing
when to trust a tool and when to question it. ARIADNE-7 models the
habit you need to develop: always ask whether the conclusion actually
follows from the data.

All commands for interacting with ARIADNE-7, exiting the container,
and adjusting her output are provided in
[session 0: setup](https://biozelenina.github.io/signs-of-life/session_00_setup)
once you have completed the setup. You will not need them before then.

---

## BEFORE SESSION 0

Download the session materials from the course GitHub repository and
follow the setup guide in [session 0: setup](https://biozelenina.github.io/signs-of-life/session_00_setup) before the first
session. The setup takes approximately 20 minutes and must be done at
home beforehand.

*The science in this course is real. The planet is not. Now, start and have fun. Resistance is futile.*

*-- Course designer*
