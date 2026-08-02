---
title: "Assessment"
nav_order: 13
---

# Assessment -- Signs of life

This document describes how the course is assessed.

---

## Components

### Mission log

Maintained throughout all sessions. Added to after every session.
Graded on **reproducibility**: Could someone else re-run your analysis
from your notes? A good entry includes the command you ran, the output
you got, and what you concluded from it.

The mission log is a plain text file at
`mission_data/logs/mission_log.txt` inside your container, saved to
your host machine via the volume mount. It persists between sessions.

### Mission report

A written synthesis of your findings from sessions 1--8. Framed
in-story as a transmission to Earth Command summarising what you
discovered about the alien organism and why it matters. You may write
this as a document or record it as a short presentation.

The report must address four questions using evidence from your
analysis:

1. What is the biochemical nature of the alien organism? (sessions 2--4)
2. What does the organism do during aurora activity that it does not do
   during quiet periods? (sessions 5--6)
3. How many mating types does the organism have and how can they be
   distinguished? (session 7)
4. Is the expression of your candidate gene significantly different
   between mating types? (session 8)

Length: 1,500--2,500 words, or a 10--15 minute presentation.
Guidelines and a template are provided in sessions 9--10.

### Reflection

500 words maximum. Answer three questions:

1. What surprised you most about the analysis?
2. What was the hardest part, and how did you work through it?
3. What does this exercise tell you about how biological diversity
   on Earth could have been different?

### Peer review

One written review of one colleague's mission log and mission report. You will receive
a specific log and report to review and a structured review form. Graded on the
quality and constructiveness of your feedback, not on whether you agree
with their conclusions.

### Gate questions

One gate question per session (sessions 1--8). Must be answered
correctly before the next session unlocks. These are not general quiz
questions -- they ask for a specific numerical or text result from your
analysis, so you can only answer correctly if you actually ran the
commands.

Submit with: `ariadne submit --session N`

If you are completely stuck, `ariadne hint --session N` gives a
directional hint. Using a hint does not affect your grade.

---

## Weighting

Exact weighting is provided by the course coordinator. The components
are designed so that a student who completes the analysis honestly,
keeps a reasonable mission log, and writes a thoughtful report will
pass comfortably regardless of whether their gate answers were
exactly correct on the first attempt.

---

## The alien egg bonus

Finding all five alien eggs earns access to a hidden lore file. The
classified backstory of what actually happened to the two
previous survey missions that declared this planet lifeless. This
does not affect your grade. Details in `alien_egg_hunt.md`.
