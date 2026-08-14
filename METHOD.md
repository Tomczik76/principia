# Method — how sources get digested and admitted

The discipline that produced this repo, recorded so future digestion runs the same
playbook. Developed over one day of encoding six sources into a project's instructions
file, then adversarially reviewing the result.

## Digestion rules

1. **Primary sources.** Get the transcript or the original essay, not summaries of it.
   Secondhand sources flatten the argument and miss the best material (the real Bjarnason
   transcript's spine was detonate-late, which no summary led with; the real Ousterhout
   talk contained the errors-contract boundary and the from-scratch ideal, which the
   book notes blurred). Archive transcripts in `transcripts/` — download links rot.
   (The directory is untracked: transcripts are other people's IP and stay off the
   public repo; the canon cites URLs.)
2. **Encode only what is additive.** Restating an already-earned rule in borrowed
   vocabulary weakens it. Before writing a section, list what the existing corpus already
   covers; import only the delta. If a source is mostly restatement, its digest is one
   paragraph, or nothing.
3. **Anchor every imported claim.** A rule enters the canon only with at least one
   `case-studies.md` entry a real project paid for. Rules without evidence are queued,
   not admitted.
4. **Write the do-not-import paragraph.** Where the source conflicts with earned rules,
   say so explicitly, in the digest, with the reason — otherwise a future reader
   (human or agent) imports the whole talk by association. Also record *non-conflicts*
   that look like conflicts (e.g. anti-TDD vs red-e2e-first), so nobody relitigates them.
5. **State the tradeoff of the source itself.** Every digest should note what the source
   gets wrong or overstates (the Hickey construct table, Markbåge's dependency
   asceticism, the vendor pitch halves). A digest with only upside is as incomplete as a
   proposal with only benefits.

## The core budget

`core.md` has a hard budget: **a new line enters only by displacing one.** Every source
you digest adds to `canon/` freely; `core.md` is the always-on layer and pays per-session
context cost in every consuming project forever. This is the repo's own surface-accounting
rule applied to itself, recursively. Expect to be tempted; the temptation is the easy
axis.

## Consumption topology

- `core.md` — always-on, imported by each project's CLAUDE.md (`@~/Dev/principia/core.md`).
  Self-contained; never references a specific project.
- `canon/` — on-demand depth. Read when arguing a design decision, or when a core rule
  needs its full justification.
- `case-studies.md` — the evidence ledger; grows as projects contribute paid-for defects.
- Each project's own CLAUDE.md keeps its **local anchors** (repo-specific constructs,
  file names, defect stories) — the portable rule text triggers weakly without them.
  De-anchored rules are weaker rules; the per-project anchor layer is not optional.
- Prefer retiring a prose rule into an enforcing mechanism (hook, type, constraint,
  CI guard) over perfecting its wording. A rule an agent must remember is a compensating
  filter; the mechanism is the foreign key. The prose then shrinks to one line naming
  the mechanism.

## Review

The corpus is code: it drifts (dead identifiers, stale claims, duplicated facts that
diverge in wording) and deserves periodic adversarial review — multiple reviewers on
distinct dimensions (contradictions, anchor accuracy against real repos, redundancy /
surface budget, cross-reference integrity, actionability by its own standards), each
finding verified by a reviewer instructed to refute it. The first such review of the
source material confirmed real violations of the corpus's own measurement and accounting
rules (see the self-review entry in `case-studies.md` for the numbers); expect the same
of this repo and re-run the review after any growth spurt.
