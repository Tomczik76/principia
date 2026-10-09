---
name: principia-contribute
description: Record a lesson the current project paid for into the Principia evidence ledger, retiring an IOU or proposing a core.md displacement if it earns one.
disable-model-invocation: true
argument-hint: "[the defect or lesson, in a phrase]"
---

# Contribute a paid-for anchor to Principia

This is the procedure; the law it serves is `~/Dev/principia/METHOD.md` rule 3, and the
entry format is the header of `~/Dev/principia/case-studies.md`. Read both first.

Lesson to record: $ARGUMENTS

If no lesson is given above, take it from this session's work and name the defect you
mean before writing anything.

## 1. Prove it was paid for

Collect from this project's history: the date, the commits / PR / files, what broke, how
it surfaced, what fixed it. If you cannot point at the defect in history, stop — it is a
candidate, not an entry. Reasoned-about near-misses do not qualify.

## 2. Find what it evidences

Grep `~/Dev/principia/core.md` and `canon/` for the rule it bears on. Exactly one of:

- **It pays an IOU** (`case-studies.md`, `## IOUs`) — write the entry and delete that IOU
  line in the same edit.
- **It anchors a stated rule** — write the entry; nothing else changes.
- **It evidences an unstated rule** — write the entry; the rule goes to the canon file it
  belongs to (or `QUEUE.md` if it needs a source first), never straight into `core.md`.

## 3. Write the entry

Under the project's `##` heading — create it if missing, matching the existing headings'
one-line parenthetical. Each check below is a defect this ledger has already paid for
(`## Principia`, the corpus review of 2026-08-20):

- Every count, reach or boundary claim is computed in this session and printed in your
  reply. A correction is a claim too and pays the same toll.
- A status claim about live code carries the date it was measured, in the past tense.
- Cite a fact's home instead of restating it; if a canon file states it, point there.

## 4. If it argues for a `core.md` change

Run `~/Dev/principia/check-budget.sh` for the current headroom — do not trust a number
written anywhere else. A line enters only by displacing one: propose which line leaves and
why it is weaker, apply it, re-run the script. Raising the ceiling is the user's call;
do not make it unasked.

## 5. Land it

Principia is its own repo; these edits are not part of this project's diff. Check
`git -C ~/Dev/principia status` before editing — if it is dirty or off `main`, say so and
ask where to write. Show the entry; commit in principia only when asked. If the rule needs
a local trigger here, propose the anchor line for this project's `CLAUDE.md` (README,
"Consumption").
