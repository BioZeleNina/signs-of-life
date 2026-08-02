---
nav_exclude: true
---

# Signs of life

---

You have crash-landed on a planet catalogued as lifeless. You have a
sequencer, a polymer sample, a ship's computer with strong opinions,
and fourteen days until rescue. You might as well find out what this
thing is.

This is a practical bioinformatics course structured as a science
fiction survival scenario. The science is genuine. The planet is not.
The organism is based on a real one. There are five alien eggs hidden
in the materials.

---

## What this course teaches

| Session | Topic |
|---|---|
| 0 | Docker, terminal setup |
| 1 | Command line and file system |
| 2 | Sequencing technologies, FASTQ format, quality control |
| 3 | Genome assembly |
| 4 | The genetic code and ORF finding |
| 5 | RNA-seq mapping and expression |
| 6 | Differential expression analysis |
| 7 | Variant calling and population structure |
| 8 | Hypothesis testing and experimental design |
| 9--10 | Mission report, mission log, reflection |

---

## Prerequisites

- Basic familiarity with biology at the level of an introductory
  university course
- No prior programming or bioinformatics experience required
- A computer running macOS or Windows with at least 8 GB RAM and
  10 GB free disk space
- Docker Desktop (installed in session 0)

---

## Repository contents

```
signs-of-life/
├── README.md                        <- this file
├── download_data.sh                 <- downloads all data from Releases
├── prologue.md                      <- narrative introduction and course overview
├── session_00_setup.md              <- Docker installation and setup
├── docker_install_guide.md          <- Docker installation (Mac and Windows)
├── session_01.md                    <- Session 1: terminal and file system
├── session_02.md                    <- Session 2: sequencing and QC
├── session_03.md                    <- Session 3: genome assembly
├── session_04.md                    <- Session 4: the genetic code
├── session_05.md                    <- Session 5: RNA-seq mapping
├── session_06.md                    <- Session 6: differential expression
├── session_07.md                    <- Session 7: variant calling and population structure
├── session_08.md                    <- Session 8: hypothesis testing
├── session_09_10_synthesis.md       <- Sessions 9-10: report and reflection
├── assessment.md                    <- Assessment information
├── alien_egg_hunt.md                <- Optional alien egg hunt
├── references.md                    <- Tool citations
├── acknowledgements.md              <- Credits
├── accessibility.md                 <- Accessibility features
├── alien_dataset_build_manual.md    <- How the alien dataset was generated
├── assets/
│   ├── header.png                   <- Course header image
│   └── css/custom.scss              <- Custom styles
├── _includes/
│   └── head_custom.html             <- Jekyll custom includes
└── templates/
    ├── mission_report_template.md
    └── peer_review_form.md
```

Data files (FASTQ, reference sequences) are distributed via GitHub
Releases, not committed to this repository. Instructions for
downloading them are in [session_00_setup.md](session_00_setup.md)
(Step 4).

---

## Reproducing the alien dataset

The alien genomic dataset was generated from *Dictyostelium
discoideum* chromosome 6 (GCF_000004695.1) using a fixed-seed
simulation pipeline. Full instructions, commands, and random seeds
are in [alien_dataset_build_manual.md](alien_dataset_build_manual.md).

---

## Reporting issues

Open a GitHub issue for:
- Errors in session documents or commands that do not work as described
- Accessibility barriers
- Suggestions for improvement

Label issues with the relevant session number where applicable.
