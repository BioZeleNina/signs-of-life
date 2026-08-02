---
title: "Accessibility"
nav_order: 17
---

# Accessibility -- Signs of life

This document describes the accessibility features of the course
materials and how to report issues.

---

## Document formats

All session documents are plain Markdown files. They can be:

- Read directly on GitHub as formatted text
- Read as plain text in any editor or terminal
- Read aloud by screen readers and assistive technology
- Displayed in light mode, dark mode, or sepia mode via the GitHub
  Pages theme switcher (button at the top of each page)

No essential information is conveyed through colour alone. Every image
and diagram includes a plain text description.

---

## ARIADNE-7 output

ARIADNE-7's output uses rainbow colours by default. If this causes
accessibility difficulties or display issues, run the following command
inside your Docker container:

```bash
export ARIADNE_PLAIN=1
```

All subsequent ARIADNE-7 output will appear as plain white text. This
setting lasts for the current container session only. To restore
rainbow mode:

```bash
export ARIADNE_PLAIN=0
```

---

## Audio output

The resonance tools in session 7 produce `.wav` audio files. For
students who cannot hear audio, each tool also produces:

- A **PNG image** showing the waveform and a frequency bar chart,
  so the same information a hearing student receives from audio is
  available visually
- A **plain text summary** listing the detected frequencies, periods,
  and ratios, suitable for screen readers

No audio is required to complete any gate question or assessed
component. The audio is an additional channel, not the only channel.

---

## Code blocks

All commands in the session documents use standard monospace code
blocks. On GitHub Pages, code blocks have sufficient contrast in both
light and dark modes.

Commands are always shown in full -- no partial commands that require
inferring context from surrounding prose. Every command includes a
comment on the line above (not inline, to avoid zsh compatibility
issues) explaining what it does.

---

## Reporting issues

If you encounter an accessibility barrier in any course material,
report it as an issue on the course GitHub repository with the label
`accessibility`. Issues are addressed as a priority.

If you need an alternative format for any material, contact the course
coordinator directly.
