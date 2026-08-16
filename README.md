# Principia

A personal canon of software taste: classic talks and essays digested into decision
procedures, priced for the coding-agent era, and backed by defects real projects paid
for. Not a quote collection — every rule traces to evidence.

## Structure

| File | Role | Loaded |
|---|---|---|
| `core.md` | The distillate: decision procedures only, self-contained | Always — imported by each project's CLAUDE.md |
| `canon/*.md` | Full digests, one per source (or paired sources): the import, the do-not-import, the evidence | On demand |
| `case-studies.md` | The evidence ledger — paid-for defects, per project | On demand |
| `agent-era.md` | Original position: how these rules reprice under coding agents | On demand |
| `METHOD.md` | How sources get digested and admitted; the core budget rule | When adding sources |
| `QUEUE.md` | Ranked mining list + rejected-as-redundant list | When adding sources |
| `transcripts/` | Archived primary sources | Reference |

## Consumption

In any project's `CLAUDE.md`:

```markdown
@~/Dev/principia/core.md
```

Then keep the project's **local anchors** in its own CLAUDE.md — repo-specific constructs,
file names, and defect stories that make the portable rules fire. De-anchored rules are
weaker rules; the import supplies the procedures, the project supplies the triggers. When
a project pays for a new lesson, contribute the anchor back to `case-studies.md`.

## The two laws of this repo

1. **`core.md` has a hard budget** — a new line enters only by displacing one. The canon
   grows freely; the always-on layer does not. (This is the repo's own surface-accounting
   rule applied to itself.)
2. **No rule without evidence** — admission requires a `case-studies.md` entry a real
   project paid for. Everything else waits in `QUEUE.md`.

## Publishing note

`transcripts/` holds archived talk transcripts for local reference — they are other
people's intellectual property, so the archive contents are untracked (`.gitignore`).
What IS tracked is the provenance: `transcripts/MANIFEST.md` (origin + SHA-256 per file)
and `transcripts/fetch.sh`, which re-downloads what has a stable upstream and verifies
everything present. Files with no stable upstream live in a private mirror
(`Tomczik76/principia-transcripts`). The canon cites each source by URL where a public
one exists (and by venue otherwise); `transcripts/SOURCES.md` (archived, mirrored) maps
archive filenames to their origins.

## Current sources

Hickey, *Simple Made Easy* + *The Value of Values* · Bjarnason, *Constraints Liberate,
Liberties Constrain* + *Composing Programs* · King, *Parse, Don't Validate* · Ousterhout,
*A Philosophy of Software Design* · Metz, *The Wrong Abstraction* + Markbåge, *Minimal
API Surface Area* · Hughes, *How to Specify It!* ·
Bailis et al., *Feral Concurrency Control* + Kleppmann, *Transactions: Myths, Surprises
and Opportunities*.
