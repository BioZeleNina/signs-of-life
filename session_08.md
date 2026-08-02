---
title: "Session 8: testing what you know"
nav_order: 11
---

# SESSION 8 -- Testing what you think you know
## *A hypothesis is only as good as the test you put it through.*

---

### MISSION BRIEFING

You have assembled a genome, cracked the genetic code, mapped
expression, identified differentially expressed genes, called variants,
and discovered a mating-type system. You have a picture of what this
organism is and what it does.

Now you need to test one specific claim rigorously.

Session 8 is about hypothesis testing by framing a biological question
as a statistical test, running the test, and interpreting the result
honestly -- including when the result is ambiguous or negative.

> ARIADNE-7: "I will offer a hypothesis for you to test. In session 6
> you identified genes strongly upregulated during aurora activity.
> My hypothesis: that upregulation is statistically consistent across
> all three aurora-on replicates, not an artefact of one outlier
> sample. This is a testable claim. Run the test. Tell me if I am
> right. I have a prior on this. I am not going to tell you what it
> is, because that would bias your interpretation. Science."

---

### PRE-MISSION LECTURE -- Hypothesis testing and experimental design

#### H0 and H1

Every statistical test involves two hypotheses:

**H0 (null hypothesis):** there is no effect. The observation is
consistent with random variation between samples.

**H1 (alternative hypothesis):** there is a real effect that is
larger than expected by chance.

The test asks: assuming H0 is true, how likely is the observed data?
If the probability -- the p-value -- is below a threshold (usually 5% or 0.05), we reject H0 in favour of H1.

Rejecting H0 does not mean H1 is true. It means the data are
inconsistent with H0. These are not the same thing. This distinction
matters in every paper you will ever read or write.

#### The p-value

A p-value of 0.05 means: if H0 were true, you would see a result at
least this extreme by chance 5% of the time. It does not mean "there
is a 5% chance H0 is true."

A result with p = 0.04 and a result with p = 0.06 are not
categorically different. Both are uncertain. The threshold is a
decision rule, not a description of reality.

#### Welch's t-test

With three replicates per condition, Welch's t-test is the
appropriate parametric test for comparing means between two groups.
It does not assume equal variance between groups (unlike Student's
t-test), which makes it more appropriate for genomic data where
highly expressed genes tend to have higher variance.

#### Effect size vs statistical significance

Always report both: the p-value (significance) and the fold change
(effect size). A significant result with a fold change of 1.01 is
not biologically interesting. A non-significant result with a fold
change of 50 with only n=2 replicates might be worth investigating
further with more data.

#### Multiple testing

If you run one t-test, a threshold of p < 0.05 gives a 5% false
positive rate. If you run 10,000 tests (one per gene), you expect
500 false positives by chance. In session 8, you test a single
pre-specified hypothesis, so multiple testing is not the primary
concern -- but be aware of it when interpreting session 6 results.

---

### TUTORIAL -- Hypothesis testing with yeast chrI RNA-seq data

In this tutorial you test a specific hypothesis about the yeast chrI
data from sessions 5--6: that the top differentially expressed gene
is significantly upregulated in condition B compared to condition A.

**No new data is needed.** This tutorial uses the counts matrix from
session 5 and the DE results from session 6.

```bash
cd /work
```

#### Step 1 -- Confirm your input files exist

```bash
ls -lh tutorial_data/yeast/session_06/de_results.csv
ls -lh tutorial_data/yeast/session_05/counts_matrix.csv
```

If these do not exist, return to sessions 5 and 6 tutorials first.

#### Step 2 -- Identify the candidate gene

```bash
head -3 tutorial_data/yeast/session_06/de_results.csv

CANDIDATE=$(awk -F',' 'NR==2 {print $1}' tutorial_data/yeast/session_06/de_results.csv)
echo "Candidate gene: ${CANDIDATE}"
```

#### Step 3 -- State your hypothesis before looking at the numbers

```bash
echo "Session 08 tutorial hypothesis test:" \
  >> mission_data/logs/mission_log.txt
echo "  Candidate gene: ${CANDIDATE}" \
  >> mission_data/logs/mission_log.txt
echo "  H0: Expression does not differ between condition A and B" \
  >> mission_data/logs/mission_log.txt
echo "  H1: Expression is higher in condition B than condition A" \
  >> mission_data/logs/mission_log.txt
```

Writing the hypothesis before seeing the data is not a formality.
It prevents you from unconsciously adjusting your expectations after
you see the result.

#### Step 4 -- Run the t-test

```bash
python3 -c "
import pandas as pd
from scipy import stats

candidate = '${CANDIDATE}'
df = pd.read_csv('tutorial_data/yeast/session_05/counts_matrix.csv', index_col=0)

if candidate not in df.index:
    print(f'ERROR: {candidate} not found. Check counts matrix headers.')
    exit()

expr_a = df.loc[candidate, ['A_1','A_2','A_3']].values.astype(float)
expr_b = df.loc[candidate, ['B_1','B_2','B_3']].values.astype(float)

print(f'Gene: {candidate}')
print(f'Condition A: {expr_a.tolist()}')
print(f'Condition B: {expr_b.tolist()}')
print(f'Mean A: {expr_a.mean():.2f}')
print(f'Mean B: {expr_b.mean():.2f}')
print(f'Fold change B/A: {expr_b.mean()/max(expr_a.mean(),0.01):.2f}')
print()
t, p = stats.ttest_ind(expr_a, expr_b, equal_var=False)
print(f'Welch t-test: t = {t:.3f}, p = {p:.2e}')
if p < 0.05:
    print('Result: p < 0.05 -- reject H0')
else:
    print('Result: p >= 0.05 -- fail to reject H0')
"
```

#### Step 5 -- Record your conclusion

```bash
echo "  p-value: [paste result]" >> mission_data/logs/mission_log.txt
echo "  Conclusion: [reject H0 / fail to reject H0]" \
  >> mission_data/logs/mission_log.txt
```

#### Step 6 -- Check the truth list

```bash
cat tutorial_data/yeast/yeast_de_genes_truth.txt
```

Is your candidate in the seeded DE gene list? If yes, you identified
a true positive. What does it mean if the p-value was still high
despite the gene being seeded as DE?

---

### MAIN MISSION -- Is the aurora response statistically robust?

```bash
cd /work/mission_data
mkdir -p session_08
```

#### Step 1 -- Identify your candidate gene

```bash
CANDIDATE=$(awk -F',' 'NR==2 {print $1}' session_06/results/de_results.csv)
FC=$(awk -F',' 'NR==2 {print $4}' session_06/results/de_results.csv)
PVAL=$(awk -F',' 'NR==2 {print $5}' session_06/results/de_results.csv)
echo "Candidate: ${CANDIDATE}"
echo "Fold change (from session 6): ${FC}"
echo "P-value (from session 6):     ${PVAL}"
```

#### Step 2 -- State your hypothesis

```bash
echo "Session 08 mission hypothesis test:" >> mission_data/logs/mission_log.txt
echo "  Candidate: ${CANDIDATE}" >> mission_data/logs/mission_log.txt
echo "  H0: Expression does not differ between aurora-off and aurora-on" \
  >> mission_data/logs/mission_log.txt
echo "  H1: Expression is higher in aurora-on than aurora-off" \
  >> mission_data/logs/mission_log.txt
```

#### Step 3 -- Run the t-test manually

The session 6 `de_analysis` tool computed this internally. Here you
run it explicitly so you see the individual replicate values and
understand what is being tested:

```bash
python3 -c "
import pandas as pd
from scipy import stats

candidate = '${CANDIDATE}'
df = pd.read_csv('session_06/results/counts_matrix.csv', index_col=0)

if candidate not in df.index:
    print(f'Candidate {candidate} not found. Check the contig name.')
    exit()

expr_off = df.loc[candidate, ['off_1','off_2','off_3']].values.astype(float)
expr_on  = df.loc[candidate, ['on_1', 'on_2', 'on_3']].values.astype(float)

print(f'Gene: {candidate}')
print()
print('Aurora-off replicates:', expr_off.tolist())
print('Aurora-on  replicates:', expr_on.tolist())
print()
print(f'Mean aurora-off: {expr_off.mean():.2f}')
print(f'Mean aurora-on:  {expr_on.mean():.2f}')
print(f'Fold change:     {expr_on.mean()/max(expr_off.mean(),0.01):.2f}')
print()
t, p = stats.ttest_ind(expr_off, expr_on, equal_var=False)
print(f'Welch t-test: t = {t:.3f}, p = {p:.2e}')
print()
print('Variance check:')
print(f'  Variance aurora-off: {expr_off.var():.2f}')
print(f'  Variance aurora-on:  {expr_on.var():.2f}')
"
```

> ARIADNE-7: "Note the variance values. A gene with zero variance in
> aurora-off because it is completely silent makes the t-test
> mathematically awkward -- dividing by zero. The `de_analysis` tool
> adds 1 pseudocount before computing fold change to avoid this.
> This is standard practice. It is worth knowing it is there."

#### Step 4 -- Check replicate consistency

```bash
python3 -c "
import pandas as pd

candidate = '${CANDIDATE}'
df = pd.read_csv('session_06/results/counts_matrix.csv', index_col=0)
row = df.loc[candidate]
print(f'Gene: {candidate}')
print()
print('Condition    Sample   Reads')
print('-' * 35)
for col in ['off_1','off_2','off_3']:
    print(f'aurora-off   {col:<8} {row[col]:>8.1f}')
print()
for col in ['on_1','on_2','on_3']:
    print(f'aurora-on    {col:<8} {row[col]:>8.1f}')
print()
print('Consistent replicates: all three off values similar, all three on values similar.')
print('Inconsistent: one replicate very different from the other two.')
print('Consistency strengthens confidence in the result.')
"
```

#### Step 5 -- Consider multiple testing in the session 6 results

```bash
N_SIG=$(awk -F',' 'NR>1 && $5<0.05 {count++} END {print count}' \
  session_06/results/de_results.csv)
N_TOTAL=$(awk -F',' 'NR>1 {count++} END {print count}' \
  session_06/results/de_results.csv)
echo "Significant genes (p<0.05): ${N_SIG} out of ${N_TOTAL}"
echo "Expected false positives by chance: $(python3 -c "print(f'{${N_TOTAL} * 0.05:.0f}')")"
```

If 5% of tests are expected false positives, how many of your
significant genes might be noise?

#### Step 6 -- Record your full conclusion

```bash
nano mission_data/logs/mission_log.txt
```

Add:
- The p-value from your manual t-test
- Whether all three replicates in each condition agreed
- Whether you reject or fail to reject H0
- The expected number of false positives in your session 6 gene list
- One limitation of this test
- One follow-up experiment you would want to run

---

### MISSION DEBRIEF

You have framed a specific biological question as a statistical
hypothesis, run the appropriate test, and interpreted the result --
including its limitations. The most important thing to have learned
is not the test procedure but the epistemology -- what conclusions the
test actually licenses, and what it does not.

Sessions 9--10 will ask you to synthesise everything into a mission
report. The report is an argument built from evidence. The evidence
includes the p-values from your tests and the reasoning about what
those p-values mean.

---

### GATE QUESTION -- Session 8

```bash
ariadne submit --session 8
```

> ARIADNE-7: "Is your p-value below 0.05 for the candidate gene
> expression test between aurora-on and aurora-off? Answer YES or NO."

---

### REFERENCE -- Session 8 commands

| Command | What it does |
|---|---|
| `awk -F',' 'NR==2 {print $1}' file.csv` | Extract first data value |
| `python3 -c "from scipy import stats; t,p = stats.ttest_ind(a, b, equal_var=False)"` | Welch's t-test |
| `awk -F',' 'NR>1 && $5<0.05 {count++} END {print count}'` | Count significant results |
| `ariadne submit --session 8` | Submit gate answer |
| `ariadne hint --session 8` | Get a hint |
