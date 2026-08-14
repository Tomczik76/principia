# Feral Concurrency Control (Bailis et al. + Kleppmann)

**Sources:** Bailis, Fekete, Franklin, Ghodsi, Hellerstein & Stoica, "Feral Concurrency
Control: An Empirical Investigation of Modern Application Integrity" (SIGMOD 2015;
author version at bailis.org/papers/feral-sigmod2015.pdf), and Kleppmann, "Transactions:
Myths, Surprises and Opportunities" (Strange Loop 2015 — chapter 7 of *Designing
Data-Intensive Applications* in embryo). Both archived in `transcripts/`, untracked.
Digested as a pair: Kleppmann supplies the anomaly recognizers, Bailis the field
measurements of the same failure class. Jurisdiction split with `acid-island.md`: that
file governs crossings *out* of the ACID island; this one governs races *inside* it.

## The import

**A transaction is not a lock.** The corpus's enforcement rule — where a constraint
can't reach, enforce in the one transaction that makes the change — silently assumed
that a transaction excludes concurrent transactions. It doesn't. Isolation, not
atomicity, is the concurrency guarantee, and the isolation you actually run at is almost
never serializable: Postgres defaults to Read Committed, MySQL to (snapshot-flavored)
Repeatable Read, and in the Berkeley survey Kleppmann shows, serializable is the default
in about 3 databases of ~20 and unsupported in roughly half. Wrapping a check in
`BEGIN…COMMIT` changes nothing about what a concurrent checker sees.

- **The recognizer: read, decide, write elsewhere (write skew).** A transaction reads
  state, decides based on what it read, and writes its decision to rows the read didn't
  cover — so no write-write conflict fires, and by commit time the premise can be false.
  Kleppmann's example: two on-call doctors each check "≥ 2 on call," both go off call,
  invariant dead; snapshot isolation permits it, and on Oracle it is unpreventable short
  of explicit locks. Every app-level validation is this shape: SELECT, if, INSERT.
- **The merge test: which checks are safe in app code.** Invariant confluence,
  informally: imagine two transactions, each preserving the invariant alone; merge their
  results. If the merge still satisfies it, an application-level check is sound with no
  coordination — this covers checks on values the write itself carries (presence,
  format, ranges, numericality): 86.9% of built-in validation uses in Bailis's corpus
  are safe under concurrent insertion. If the merge can violate it, no app-level check
  below serializable is enforcement. The failing classes are exactly: *uniqueness under
  concurrent insert*, *references under concurrent delete* (only 36.6% of validation
  uses are safe when deletions run), and *thresholds over rows the write doesn't touch*
  (quotas, "at least one left", non-negative stock).
- **For those classes the database is the only enforcer — and constraint beats isolation
  level.** The measurements: across 67 open-source Rails apps, feral invariants outnumber
  transactions ~37:1 (1.80 validations + 3.19 associations per model vs 0.13
  transactions). Under a worst-case concurrent-insert stress test, the uniqueness
  validation admitted 70 duplicates at 2 workers and 249 at 3 (6,300 with no validation);
  an in-database unique index: zero. Feral foreign-key checking under concurrent delete
  left the validation "almost worthless" at 64 workers; a real FK: zero orphans. And the
  isolation-level route failed even where it was chosen: Bailis found a then-live bug in
  Postgres's serializable (SSI) admitting duplicates from the Rails primary-key
  validator's own transaction shape, and Oracle's "serializable" is snapshot isolation.
  A unique index or foreign key holds at every isolation level, in every client, forever.
- **Keep the racing check; demote it.** Bailis's other headline: even racing validations
  cut anomalies by orders of magnitude (they shrink the race window to
  validation-duration). So the app-level check stays — for fast feedback and good error
  messages — but as UX, not enforcement: it is a compensating filter for a constraint
  that must exist independently.
- **Abortability is the useful reading of A.** Kleppmann: atomicity is not about
  concurrency at all — it collapses every failure class (deadlock, crash mid-write,
  constraint violation, yanked power cable) into one handler: abort, then retry.
  Corollary: bespoke cleanup code after a partial failure is hand-rolling the collapse a
  transaction gives free. His microservices half — every sufficiently large deployment
  "contains an ad hoc, informally specified, bug-ridden slow implementation of half of
  transactions" — is `acid-island.md`'s crossing discipline re-derived from the failure
  side (compensating transactions = app-level atomicity, apologies = app-level C).
  Convergent; already imported there.

## Do not import

- **The isolation-level ladder as vocabulary.** The level names are System R lock
  configurations from the 1970s, not semantics, and per-database meanings shift under
  you ("repeatable read" mostly means snapshot isolation; Oracle's "serializable"
  isn't). Import the two recognizers — write skew above, and read skew (a multi-read
  observer needs one point in time: backups, analytics, exports — snapshot isolation's
  actual job) — not the taxonomy.
- **Kleppmann's causality research program.** Coordination-free causal consistency
  across services is, by his own framing, problems not solutions; the corpus already
  rejects distributed-systems vocabulary that carries no decisions for
  effectively-centralized systems.
- **Bailis's §7 design agenda** (domesticating feral mechanisms) — addressed to the
  database research community, not to an application writer who owns a schema.
- **A non-conflict to not relitigate:** the 86.9%-safe finding does not argue against
  DB-enforcement, and DB-enforcement does not mean every validation becomes a
  constraint. A format check gains nothing from the database; uniqueness gains
  everything. The merge test scopes the rule; the sources and the corpus agree.

## The sources' own tradeoffs

Bailis's headline numbers are worst-case stress workloads by design; the paper's own
realistic workload (LinkBench, 1M keys) observed zero duplicates, and it says plainly
that validations may be "good enough" for many applications — the argument for the
constraint is the *unbounded worst case* on invariants whose violation is corruption,
not the typical rate. It measures Rails at default settings; the survey of six other
frameworks shows the same pattern but the numbers are Rails's. Kleppmann's talk is by
his own admission problems-without-solutions, and its implementation-status claims (the
SSI bug, VoltDB's niche) are 2015 facts — cite the shapes, not the bug numbers.

## Agent-era note

Check-then-act is the token-gradient shape: SELECT–if–INSERT reads as obviously correct,
passes every single-threaded test, and survives any single-context review — concurrency
is invisible in a diff, and `agent-era.md`'s verification bottleneck bites at full
strength (no e2e oracle can certify the absence of a race window). That makes the
constraint the canonical retire-prose-into-mechanism move: a unique index is enforcement
that holds across every future session at zero context cost. Bailis's authorship data
agrees from the human side: 95% of invariants in his corpus were written by 20% of
authors — invariant placement was never reliably in the head of whoever writes the next
controller, and an agent is the limit case of that author.

## Evidence

See `../case-studies.md` — Contrapunctus: **the double award** (an app-level "already
awarded?" check inside a transaction raced anyway; duplicate rows reached production;
the fix was a partial unique index whose migration header states this file's thesis —
the check keeps a repeat graceful, "this index is what makes a double award impossible
rather than merely unlikely") and **the quota twins** (the audio-track cap enforced with
`FOR UPDATE` plus a conditional INSERT, its pre-check demoted in writing to "an
OPTIMISATION, not the enforcement"; the project cap the same shape with no backstop).
The same codebase carries the safe patterns live: the `stripe_events` ledger decides by
insert-and-branch on affected rows, never SELECT-then-INSERT; email verification
serialises concurrent redemptions with `UPDATE … AND email_verified = FALSE`; handle
claiming treats the unique index as the check and catches the violation. And no
statement anywhere sets an isolation level — the whole app runs at Postgres's default
Read Committed by omission, which is precisely the deployment Bailis measured.
