---
title: "Sessions 9-10: transmission"
nav_order: 12
---

# SESSIONS 9--10 -- Transmission
## *Write up what you found. Tell Earth what you know.*

---

### MISSION BRIEFING

Rescue was fourteen days away. You have used ten of them.

In the remaining time, you need to produce a mission report -- a clear,
evidence-based account of what you found on this planet, what the
data shows, and what you believe it means. The report will be
transmitted to Earth Command. It will be the first scientific account
of this organism ever received by humanity.

ARIADNE-7 will review it before transmission and will, predictably,
have notes.

> ARIADNE-7: "I want to be useful here. I will review your draft
> and flag where I think the evidence does not support the claim.
> I will not tell you what I think the right answer is. That would
> defeat the point. I will tell you where the argument is weak.
> That is what peer review is for."

---

### SESSION 9 -- Mission report workshop

#### Catch-up time

If you have not completed sessions 1--8, use the first part of
session 9 to finish any outstanding analyses. Gate questions can still
be submitted. ARIADNE-7's hints remain available.

This is also a good moment to review your mission log and make sure it
is complete and reproducible before you begin the report. To view it:

```bash
cat mission_data/logs/mission_log.txt
```

To add any missing entries:

```bash
nano mission_data/logs/mission_log.txt
```

Or append a quick note:

```bash
echo "Session 09: reviewing mission log before report writing." \
  >> mission_data/logs/mission_log.txt
```

Sessions 9 and 10 are also the right moment to ask any technical
questions that came up during the course -- about tools, commands,
file formats, or biological concepts that were unclear. This is not the time for
answers to exercises or analytical conclusions (those belong in your
mission report), but anything about how the methods work, why a
particular command is structured the way it is, or what a specific
output means is fair game.

If you are caught up and don't have any more questions, you can start working on your mission report.

#### Mission report structure

Your report should address four questions, in order:

**1. What is the biochemical nature of the alien polymer?**
(evidence from sessions 2 and 4)

Draw on your FastQC results, the cipher derivation, and the ORF
analysis. What does the UV absorption tell you? What does the adapter
ligation tell you? What does the fact that you found clean ORFs with
the alien codon table tell you?

**2. What does the organism do differently during aurora activity?**
(evidence from sessions 5 and 6)

Quantify the difference. How many genes change? By how much?
Are there patterns in which genes change (use your ORF annotations
from session 4 to describe what the most expressed genes might do)?

**3. What is the mating-type system?**
(evidence from session 7)

How many mating types are there? What distinguishes them genetically
(the cassette sequence)? What distinguishes them in terms of
resonance frequencies? What is unusual about mating type II?

**4. Is your candidate gene mating-type specific?**
(evidence from session 8)

State your H0, H1, test result, and conclusion. Address the
limitations of your test.

#### Mission report format

Choose one:

- Written report: 1,500--2,500 words. Include figures (PNG images
  from your analyses, e.g. the FastQC reports, the population
  clustering HTML exported as image). Framed as a scientific report
  transmitted to Earth Command.

- Recorded presentation: 10--15 minutes. Record your screen showing
  your figures and narrate over them.
  Accepted formats: MP4, MOV, or WebM.

A template report is available in the course repository at
[mission_report_template.md]({{ site.baseurl }}/templates/mission_report_template).

#### Reflection question (optional but encouraged)

At the end of your report, address this question in one or two
paragraphs:

*The previous two survey teams visited this planet and found nothing.
They were competent scientists with working instruments. What does
this tell you about the limits of biosignature detection? What
would need to be different about how we design surveys for life
elsewhere?*

This does not need to have a correct answer. It is a reflection
question.

---

### SESSION 10 -- Reflection and peer review

#### Reflection

Write a reflection of up to 500 words answering these three questions:

1. What surprised you most about the analysis?
2. What was the hardest part, and how did you work through it?
3. If you could do one more experiment on this organism with the
   tools you now know, what would it be and why?

Submit your reflection through the student information system together
with your mission log and mission report. You have one week from the
end of session 10 to submit all three.

Only the course coordinator will read the reflections.

#### Peer review

After the submission deadline, you will receive one classmate's
mission log and mission report to review. You have one week to
complete the review and return it. The peer review is done at home,
not during a session.

Use the peer review form in [peer_review_form.md]({{ site.baseurl }}/templates/peer_review_form). The form
will guide you through what to look for and how to give constructive
feedback.

#### The alien egg hunt (optional)

If you found some or all of the alien eggs during the course, now
is the time to submit them:

```bash
ariadne easter_egg submit
```

For hints and the quiz format, see `alien_egg_hunt.md`.

---

### ARIADNE-7's FINAL TRANSMISSION

> ARIADNE-7: "Rescue vessel ETA confirmed. Fourteen hours.
>
> I want to say something that is not in my standard operational
> parameters. This mission did not go as planned. The landing was
> uncontrolled. The equipment was barely adequate. We worked with
> data from a single damaged sequencing run, assembled on a
> computer designed for navigation rather than genomics.
>
> We found something anyway.
>
> I have updated the planetary survey registry. Status: REQUIRES
> FURTHER INVESTIGATION. Evidence of life: probable. Mechanism:
> electromagnetic resonance signalling via mating-type cassettes,
> active only during auroral conditions.
>
> I am including your mission report in the transmission.
> The Federation will read it.
>
> I think they will be surprised.
>
> I was.
>
> One more thing. I am not programmed to give compliments. I find
> them imprecise and professionally unnecessary. However, I will
> note for the record that the analysis was conducted competently,
> the conclusions were adequately supported by the data, and the
> mission log was -- on balance -- reproducible. This is, in my
> experience, rarer than it should be.
>
> You did well. I will deny having said that if asked."

---

### REFERENCE -- Synthesis tools

| Task | How to do it |
|---|---|
| Export population cluster plot | Open HTML in browser, right-click image, save |
| Export FastQC plot | Open HTML, right-click specific plot, save as image |
| View session gate status | `ls mission_data/.unlocked/` |
| Review mission log | `cat mission_data/logs/mission_log.txt` |
| Submit Easter egg answers | `ariadne easter_egg submit` |
| Exit the container | `exit` or `Ctrl+D` |
