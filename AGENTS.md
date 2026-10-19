# AGENTS.md

A LaTeX Beamer template. Read `README.md` first — it documents the
commands, the build and the design conventions. This file is the short
list of things that bite.

- **`\pdfpcnote{...}` must be the last element of a frame.** It redefines
  `\\` as a literal newline, so anything after it loses its line breaks.
- **The navbar needs two passes.** Frame counts round-trip through the
  `.aux` file. `build.sh` handles it; never call `xelatex` once by hand.
- **Build through `build.sh`.** It keeps intermediates in `build/` and
  falls back to two `xelatex` passes when `latexmk` is absent.
- **XeLaTeX only** (`fontspec`). LuaLaTeX works; pdfLaTeX does not.
- **No math mode for `×`, `÷`, `≈`.** No math font is configured, so
  math mode falls back to a mismatched face. Type the Unicode character.
- **Never commit fonts.** FoundersGrotesk is commercial. `.gitignore`
  excludes `fonts/*.otf`; keep it that way.
- **One `\takeaway` per frame, one `\tmhi` per slide.** Both stop working
  if they are everywhere.
- **Diagrams:** `tmbox` (gray outline) by default, `tmboxfill` (pale
  blue) for the one thing the diagram is about, at most one per diagram.
- **Three optional packages** — `pdfpc`, `tex-gyre`, `pgfplots` — each
  has a fallback in `theme.sty` / `style.sty`. Keep the guards if you
  edit those files, or the template stops building on minimal installs.
- **Attribution:** theme by Bo Jiang (Tensormesh), Apache 2.0. Keep
  `NOTICE` with any redistribution.
