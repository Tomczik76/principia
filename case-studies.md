# Case studies — the evidence ledger

Earned anchors, per project. This file is why the canon is not a quote collection: every
rule in `core.md` should trace to at least one entry here that a real project paid for.
When a new project adopts the canon, its paid-for defects get contributed back here —
evidence compounds across projects instead of resetting per repo. Entries are terse: the
story in two or three sentences, the principle it evidences, where the full record lives.

## Contrapunctus (music-theory education platform; Scala 3 + React/TS; 2026)

- **The bar-map day (2026-08-04).** A migration was staged behind an inertness property —
  the new code provably computed exactly what it replaced — so 2,137 green tests could not
  tell whether the real value ever ARRIVED anywhere. It hadn't: built correctly, persisted
  correctly, never reached the renderer, while a test asserted success because it built
  its own copy and measured that. The safety mechanism and the blindness were the same
  fact. → *red-e2e-first; test the seam; guardrails don't steer.*
- **The score-document hop chain.** One document's fields survive ~10 hops (wire schema →
  seed → props → store → IndexedDB → backend request → DB → share-image event → render
  input), each hop re-listing what it forwards. `keyChanges` needed seven separate
  "now make it reach layer X" commits; `barSpans` was dropped at three hops in one day —
  by agents. → *layering chain = parallel representations; deep modules; change
  amplification, printed.*
- **The audit bias measurement (2026-08-14).** Of 18 findings in an adversarial audit, six
  were false — and all six overstated reach or completeness; none understated. A
  directional bias correctable by a rule (print the count), not by trying harder.
  → *measurement rule; state the tradeoff.*
- **The `persistence` prop.** Editor-content ownership used to be inferred from four
  optional falsy-by-default booleans; a mount that set none of them silently owned (and
  clobbered) the user's sandbox save. Replaced by one required, non-defaulted enum prop.
  → *caller-identity flags as degradation signature; required parameter beats wrong
  default; make invalid states unrepresentable.*
- **The beats/voices duality.** One score held as a merged grid AND per-voice tracks,
  synced by patch logic; drift on irregular sub-beat onsets produced
  "clicked here, appeared there" bugs through several rounds of sync-helper fixes before
  the architecture itself was indicted. → *one canonical representation.*
- **Three crossings, three coats.** Stripe webhooks got an idempotency-ledger table;
  Bedrock responses are persisted raw before parsing so a parse failure doesn't lose the
  spend; the SES webhook is pinned to its topic ARN and fails closed. Discovered
  independently; recognized later as one solution. → *ACID-island crossing discipline.*
- **`rhythm/Rational.scala`, `Pulse.Atom(NonEmptyList[A])`, `Pitch` as opaque `Long`.**
  Exact fractional time because doubles lose the algebraic relationships between
  durations; an atom with zero notes is unconstructible so no consumer defends against
  it; the pitch primitive is obtainable only through its smart constructor. The frontend's
  Effect-based architecture is the same detonate-late rule applied to side effects — an
  Effect stays a description until the run boundary. → *detonate late; strengthen the
  argument type; smart constructor over opaque type; least-powerful construct.*
- **`share_images.source_id`.** A polymorphic reference with no foreign key: the app
  resolved and filtered defensively, and the gap shipped — a share-preview card happily
  renders for a deleted project. → *make broken data unreachable; a defensive filter in
  the reader is a per-caller reminder the next caller forgets.*
- **The `@wip` scenario that never ran.** An e2e feature tagged `@wip` contained a save
  step that could not ever have worked (`input[type="text"]` cannot match an input that
  declares no `type`) — it looked like coverage for months. The fix was cultural plus
  mechanical: `@wip` is a debt marker, and the test runner prints the current `@wip`
  count every run so the debt cannot go invisible. → *a test that has never run is worse
  than absent; make debt visible where it cannot be ignored.*
- **The sibling functions that stayed diverged.** A scorer was unified after review
  (measured Δ 0.00pp), but three sibling functions of the same shape remained diverged —
  later agent sessions did not know the twins existed. → *fact duplication is the
  agent-era defect class: keeping copies aligned requires cross-session memory agents
  lack.*
- **The per-platform parser twins.** `PitchConversions` (Scala) resolves the
  key-signature-relative wire encoding of notes; a hand-ported TS twin exists because one
  build path cannot call Scala.js — kept honest by mirrored parity suites. The honest
  topology is one parser per platform, not a false claim of one parser total.
  → *one parser per boundary, per-platform variant.*
- **The CLAUDE.md self-review (2026-08-14).** A 10-agent adversarial review of the
  project's own instructions file confirmed 23 defects, including: an unmeasured "19-fold"
  reach claim (actual pasted count: 10) in the very section teaching the measurement rule
  — the overstatement bias again — and the design-canon cluster violating the
  surface-accounting rule the day it introduced it (2,926 words added, zero removed). The
  instructions file is code; it drifts like code and must be reviewed like code.
  → *measurement rule (recursive); surface accounting (recursive); fact duplication
  drifts (three-copy story had already diverged in wording).*
- **The dead identifier.** The instructions file directed edits at
  `FuxSpeciesRule.byAbbreviationBySpecies` for weeks after a refactor renamed it —
  documentation anchors rot exactly like the hand-written wire twins the docs warn about.
  → *DRY-for-facts applies to docs; anchors need the same review as code.*

## IOUs — rules awaiting a paid-for anchor

Admitted on source authority; the ledger owes them evidence. Printed here so the debt
cannot go invisible (the `@wip`-count pattern applied to this repo). When a project pays
for one of these, replace the IOU with the entry. Covers both `core.md` rules and canon
bullets that ride on a source's own measurements.

- Name the axis (the simple/easy distinction itself — its two corollaries have entries).
- Design it twice / the from-scratch ideal.
- Spend top-down authority on the least important decisions.
- Define errors out of existence.
- Explicit beats implicit.
- Test your tests: generator and shrinker validity properties (Hughes).
- Measure the test-data distribution; a generator that cannot reach the interesting case
  makes every property it feeds vacuous (Hughes).
- Equivalence, not structural equality, as the exported equality of an abstract type
  (Hughes).
