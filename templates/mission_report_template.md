# Mission Report Template
## Survey Mission XB-7734-DELTA -- Final Transmission to Earth Command

*Fill in each section with your findings. Delete these instructions
before submitting. Word limit: 1,500--2,500 words.*

---

**TRANSMISSION HEADER**
From: Survey Scientist [your name]
Mission: XB-7734-DELTA
Status: Unscheduled extension complete
Rescue arrival: confirmed

---

## Executive summary

*One paragraph (100--150 words). What did you find? Is there life on
this planet? What evidence do you have?*

---

## 1. Biochemical characterisation of the alien polymer
*(Sessions 2 and 4)*

### 1.1 Sequencing and base composition

*What did the first sequencing scan reveal? What alphabet did the
reads use? How did you decode it? What does UV absorption at 260nm
suggest?*

### 1.2 Assembly statistics

*What were the key statistics of your assembled genome? (contig
count, total length, N50, GC content). What do these tell you about
the organism's genome structure?*

### 1.3 The genetic code

*How does the alien genetic code differ from the standard code? How
did you determine what the code was? What does finding clean open
reading frames with the alien code -- but not the standard code --
tell you?*

---

## 2. Aurora-responsive expression
*(Sessions 5 and 6)*

### 2.1 Expression during aurora activity

*Which contigs were most highly expressed in aurora-on conditions?
What fraction of the transcriptome was active?*

### 2.2 Differential expression

*How many genes changed significantly between aurora-on and
aurora-off? What were the fold changes of the most significant
genes? Include a brief table of the top 5 DE genes.*

| Transcript ID | Mean off | Mean on | Fold change | p-value |
|---|---|---|---|---|
| | | | | |
| | | | | |
| | | | | |

### 2.3 Interpretation

*What does this expression pattern tell you about when and how this
organism is active? Why did the previous survey missions find nothing?*

---

## 3. Population structure and mating types
*(Session 7)*

### 3.1 Variant calling

*How many variant sites did you identify? How many individuals were
sequenced? Were any individuals diploid?*

### 3.2 Population clusters

*How many distinct clusters did PCA identify? Which individuals
belong to each cluster? Include your population clustering plot
(export the HTML as an image).*

### 3.3 The mating-type cassette

*Describe the mating-type cassette you extracted. What is its
sequence? What is its period? What frequency does it produce?
How does this relate to the signal you observed in session 1?*

*For mating type II specifically: what is unusual about its cassette?
What does this tell you about how it mates?*

### 3.4 Compatibility matrix

*Complete the table below based on your resonance analysis:*

| Type A | Type B | Frequency A (Hz) | Frequency B (Hz) | Ratio | Compatible? |
|---|---|---|---|---|---|
| I | III | 600 | 400 | 3:2 | Yes |
| I | II | 600 | | | |
| III | II | 400 | | | |

---

## 4. Hypothesis test: candidate gene expression by mating type
*(Session 8)*

### 4.1 Hypothesis

*State your null and alternative hypotheses clearly:*

H0: [your null hypothesis]

H1: [your alternative hypothesis]

### 4.2 Test and result

*Which gene did you test? Which mating types did you compare?
What test did you use? What was your p-value?*

| Group | Mean expression |
|---|---|
| [mating type 1] | |
| [mating type 2] | |

Test: Welch's t-test
p-value: [your value]
Conclusion: [reject / fail to reject H0]

### 4.3 Interpretation and limitations

*What does your result mean biologically? What are the limitations
of your test (sample size, confounds, alternative explanations)?*

---

## 5. Synthesis and significance

*Address these questions in 2--4 sentences each:*

**Why was this organism missed twice before?**

**What is the most significant single finding of this mission?**

**The Solaris question** *(optional but encouraged)*: This planet was
surveyed twice by competent scientists with working instruments and
declared lifeless. What does this tell you about the limits of
biosignature detection? What would need to be different about how we
design surveys for life elsewhere?

---

## Data and reproducibility

*All analyses were run inside Docker container
`biozelenina/signs-of-life:latest`. Raw data is available
from [course repository URL]. The mission log recording my complete
analysis workflow is attached.*

---

*End of transmission.*
