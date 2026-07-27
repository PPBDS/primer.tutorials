# CLAUDE.md — Primer tutorials (PPBDS/primer.tutorials)

You are authoring a **Primer learnr tutorial** — the
`inst/tutorials/<NN-name>/tutorial.Rmd` files in this package.

**This package lives in its own repo, but its authoring guide does
not.** The package was split out of
[`PPBDS/primer`](https://github.com/PPBDS/primer) (2026-07) so that
installs stop downloading the whole book; the curriculum index and the
detailed guide (`guide/`) stayed in that repo, because they also serve
the book chapters. Authoring a tutorial therefore needs BOTH repos:

- If `PPBDS/primer` is checked out as a **sibling** (`../primer/`), read
  the files there — that is David’s normal setup.
- Otherwise, read them on GitHub at the URLs below.

Start at the primer repo index —
[`../primer/CLAUDE.md`](https://ppbds.github.io/primer/CLAUDE.md)
([GitHub](https://github.com/PPBDS/primer/blob/main/CLAUDE.md)) — for
the curriculum, the base-guide relationship, and the collaboration
protocol.

**These tutorials follow the base tutorial guide by default** —
[`tutorials/CLAUDE.md` in
PPBDS/ai-rules](https://github.com/PPBDS/ai-rules/blob/main/claude-md/tutorials/CLAUDE.md)
— which owns everything common to all tutorials (the AI-era philosophy,
the `analysis.qmd` + render + Live Server workflow, the canonical
question shape, `echo = TRUE` answers, knowledge-drop discipline,
evidence conventions). **Read it first.** The Primer parts below add
only Primer specifics or record explicit overrides.

What to read (sibling path first, GitHub fallback):

- [`../primer/guide/authoring.md`](https://ppbds.github.io/primer/guide/authoring.md)
  ([GitHub](https://github.com/PPBDS/primer/blob/main/guide/authoring.md))
  — Primer tutorial structure, question flow, exercise types, child
  documents, R tooling.
- [`../primer/guide/exercise-list.md`](https://ppbds.github.io/primer/guide/exercise-list.md)
  ([GitHub](https://github.com/PPBDS/primer/blob/main/guide/exercise-list.md))
  — the master exercise list (the per-virtue exercise sequence).
- [`../primer/guide/per-problem/<id>.md`](https://ppbds.github.io/primer/guide/per-problem/)
  ([GitHub](https://github.com/PPBDS/primer/tree/main/guide/per-problem))
  — the seed spec for the problem you’re building (read only that one).
- Shared with chapters:
  [`../primer/guide/curriculum.md`](https://ppbds.github.io/primer/guide/curriculum.md)
  (tier and framing),
  [`../primer/guide/tables.md`](https://ppbds.github.io/primer/guide/tables.md),
  [`../primer/guide/concepts-and-drops.md`](https://ppbds.github.io/primer/guide/concepts-and-drops.md),
  [`../primer/guide/guidance.md`](https://ppbds.github.io/primer/guide/guidance.md)
  (all under [guide/ on
  GitHub](https://github.com/PPBDS/primer/tree/main/guide)).

The tutorial directory, YAML `id`, packaged tibble (where applicable),
and student repo all share one string per tutorial
(e.g. `08-seguro-popular`); see `../primer/guide/authoring.md` §3.
