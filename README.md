# slides-template

A LaTeX Beamer template for technical talks: dark title page, a top
navigation bar that fills as the deck advances, a plain-language
**Takeaway** bar on every slide, and speaker notes embedded in the PDF.

Build it, and you get [`main.pdf`](main.pdf) — four slides showing the
title page, a text frame, a diagram frame and the closing page.

## Build

```bash
./build.sh          # -> main.pdf
./build.sh clean    # remove build/ and the PDF
```

Intermediates stay under `build/`. The script uses `latexmk` when it is
installed and falls back to running `xelatex` twice — the navigation bar
needs two passes, because frame counts round-trip through the `.aux`
file.

**XeLaTeX is required** (`fontspec`). LuaLaTeX works too; pdfLaTeX does
not.

**Overleaf:** upload the folder as is. `latexmkrc` switches the compiler
for you. If it still complains that fontspec needs XeTeX or LuaTeX, set
Menu → Compiler → XeLaTeX.

### Dependencies

Only `beamer`, `tikz` and `fontspec` are required. Three things are
optional, each with a fallback, so the deck builds on a minimal install
such as BasicTeX:

| Optional | Without it |
|---|---|
| `pdfpc` | Speaker notes are dropped from the PDF; everything else builds |
| `tex-gyre` | Falls back to a system sans (Helvetica, then Arial) |
| `pgfplots` | Chart styles are unavailable; diagrams still work |

For the intended look on a minimal install:

```bash
sudo tlmgr install pdfpc tex-gyre pgfplots latexmk
```

## Writing a deck

Set the title block in `main.tex`, then write one file per section under
`sections/` and `\input` each. [`sections/01-example.tex`](sections/01-example.tex)
demonstrates every idiom.

```latex
\section{Movement of the talk}        % one navbar slot, sized by frame count

\begin{frame}{Topic}{The angle on it}
  Body text.
  \begin{itemize}
    \item \tmhi{one highlighted phrase} per slide;
  \end{itemize}
  \takeaway{One plain-language sentence stating the point.}
  \pdfpcnote{The spoken script. Must be the LAST element of the frame.}
\end{frame}
```

| Command | Does |
|---|---|
| `\maketitlepage[note]` | Dark title slide from the `\title` block |
| `\takeaway{...}` | The pale-blue bar; one sentence, every slide |
| `\tmhi{...}` | Highlight one phrase per slide |
| `\alert{...}` | Inline accent for a single word |
| `\pdfpcnote{...}` | Speaker script; **last element of the frame** |
| `\makeqapage[note]{contact}{logos}` | Closing slide |

### Speaker notes

Notes are embedded as PDF annotations, hidden from ordinary viewers.
**Preview, Chrome and Evince will not show them.** Present with
[pdfpc](https://pdfpc.github.io/) or
[pympress](https://github.com/Cimbali/pympress) to get them on the
presenter screen.

`\pdfpcnote` redefines `\\` as a literal newline, so put it last in the
frame or the body above it loses its line breaks.

## Design conventions

- **The Takeaway bar carries the point.** Write it for someone who reads
  nothing else on the slide. The body carries the detail.
- **One highlight per slide.** `\tmhi` stops meaning anything if it is
  everywhere.
- **Diagrams:** gray outlines (`tmbox`) for everything; the pale-blue
  fill (`tmboxfill`) for the one thing the diagram is about, at most one
  kind per diagram.
- **Charts:** `chartone` first, `charttwo` second, never cycling. The two
  hues are checked for colour-vision deficiency and for contrast on
  white.
- **No math mode for `×`, `÷` or `≈`.** Type the Unicode character —
  there is no math font configured, so math mode falls back to a
  mismatched face.

## Customising

- `theme.sty` — the knobs: colours, fonts, font sizes, bar geometry.
- `style.sty` — the implementation: templates, navbar, `\takeaway`,
  diagram and chart styles, title and closing pages.

**Logo:** drop a square `icon.png` next to `main.tex` to show your own
mark top-left; without one a plain ink square is drawn. If your mark sits
on a coloured square, set `navactivebg` to match it — the navbar progress
fill runs underneath the icon, and a mismatch shows as a seam.

**Fonts:** the original uses FoundersGrotesk, a commercial typeface. If
you hold a license, put the `.otf` files in `fonts/` and they are picked
up automatically. **Never commit them** — `.gitignore` excludes
`fonts/*.otf` for exactly this reason.

## Credit

The theme is by **Bo Jiang** (Tensormesh), from "Why a KV cache, and what
LMCache adds", a Tensormesh weekly knowledge-sharing talk, September
2026. Licensed under Apache 2.0.

This repository strips the original talk content and makes `pdfpc`,
TeX Gyre Heros and `pgfplots` optional so the deck builds anywhere.
See [`NOTICE`](NOTICE) — keep it with any redistribution, as the license
requires.
