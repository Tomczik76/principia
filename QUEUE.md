# Queue — sources to mine, and sources rejected

## Queued (ranked)

1. **Pat Helland — "Life Beyond Distributed Transactions: An Apostate's Opinion" (CIDR
   2007).** The ACID-island crossing discipline generalized into a design method:
   entities as the unit of atomicity, at-most-once messaging, idempotency as a
   first-class design input rather than a retrofit. Companion: "Memories, Guesses and
   Apologies." NOW OWES THE TERRITORY ITS CANON FILE: the prior distillate of a
   conference talk covering the same ground was removed as superfluous (2026-08-16 —
   the territory already had three homes and that was the weakest; DRY applies to
   sources). Until this is digested, `core.md`'s "Know when a change leaves the ACID
   island" bullet stands on the Kleppmann re-derivation in
   `canon/feral-concurrency-control.md` and the paid evidence in `case-studies.md`
   (three shipped crossings).
2. **Saltzer, Reed & Clark — "End-to-End Arguments in System Design" (1984).**
   Correctness checks belong at the endpoints; reliability in the middle is only an
   optimization. Unifies two things the corpus already believes separately: webhook
   fail-closed seams and red-e2e-first testing are both end-to-end arguments. Canon-tier.
3. **Hyrum's Law.** Anything you expose gets depended on; Ousterhout endorses it in the
   Google talk Q&A ("applications find every crevice and sink their roots"). Small;
   admit only with a paid-for anchor (candidate exists: a hook exported from a layout
   module solely so a test could call it — which then became load-bearing).
4. **Richard Cook — "How Complex Systems Fail."** The operations axis the corpus lacks
   (catastrophe requires multiple small failures; every defense is a new failure source;
   hindsight bias). Admit when an ops-shaped case study earns it.
5. **Hughes — "Experiences with QuickCheck: Testing the Hard Stuff and Staying Sane."**
   The stateful/concurrent complement to the digested "How to Specify It!"
   (`canon/how-to-specify-it.md` is scoped to pure functions by design): operation
   sequences against a state-machine model, race detection. Admit when a stateful-PBT
   case study earns it.
6. **Noel Welsh — *Functional Programming Strategies in Scala with Cats*, the
   data/codata and interpreter chapters.** The initial/final distinction as data vs
   codata, in Scala 3 specifically — the book-excerpt companion to
   `canon/tagless-final.md` (Kiselyov is Haskell/OCaml-centric; Welsh speaks the
   consuming projects' language). Sources need not be talks: book excerpts, blog
   posts from lesser-known wizards, and treatises qualify on the same terms —
   primary text, delta only, paid-for anchor. The Contrapunctus rule-DSL bake-off
   (2026-08-14) already provides the anchor; admit on the next digestion pass.
7. **Fabio Labella (SystemFw) — the effect-systems treatises** ("the case for effect
   systems"; the shared-state-in-FP talks/gists). The strongest lesser-known-Scala-
   wizard material on WHY suspension buys compositionality — would deepen the
   Effect.ts/cats-effect side of `constraints-liberate.md`'s detonate-late rule.
   Admit with an effect-seam case study (the Contrapunctus backend TF seam, when
   built, is the natural anchor).

## Reversed rejections (kept visible so the failure mode stays priced)

- **Hickey, "The Value of Values"** (JaxConf 2012) — rejected as "covered by core's
  least-power/immutability defaults," reopened and digested 2026-08-14 as
  `canon/value-of-values.md`. The rejection was wrong twice over, both times by this
  repo's own rules: it was written from memory of the talk rather than the transcript
  (METHOD rule 1), and it asserted coverage without printing a count (the measurement
  rule). Measured at reopening: `immutab` occurs **0** times in `core.md` and **1** time
  in the whole tracked corpus — in the rejection sentence itself. The delta the transcript
  actually carried: the PLOP detector (new information replacing old), fact-log vs.
  current-state store, policies-don't-compose-but-values-do, and the fabrication
  precondition under property-based testing.
  **Lesson for future triage: a rejection is a reach claim and pays the same evidence
  toll as an admission.** Rejecting a source unread is cheaper than digesting it and
  looks identical afterward.

## Rejected as redundant (do not re-litigate without new evidence)

- **Hickey, "Hammock Driven Development"** — covered by core's red-check-first testing
  rule and its design-it-twice discipline. (Rejection unread; see the reversal above for
  what that is worth. Re-check against the transcript before relying on it.)
- **Yaron Minsky, "Effective ML"** — origin of "make illegal states unrepresentable";
  the rule is already in core with paid-for evidence in the ledger.
- **Richard Feldman, "Making Impossible States Impossible"** — same rule, Elm-shaped.
- **Gary Bernhardt, "Boundaries"** — functional core / imperative shell is core's
  detonate-late rule applied to effects (execute at the last step, at the run boundary);
  its avoid-mocks testing payoff is achieved more directly by integration-testing against
  real dependencies.
- **Moseley & Marks, "Out of the Tar Pit"** — the ancestor of half the corpus; reading it
  after Hickey is re-derivation.
- **Wlaschin, "Designing with Types: Making Illegal States Unrepresentable"** — the
  slogan and its worked refactoring (record-of-optionals → union of legal states) are
  already core rules; the one genuinely additive part, the *counting procedure*, was
  absorbed into core's invalid-states bullet rather than given a canon file. His
  property-pattern taxonomy (roundtrip, oracle, idempotence) is likewise covered by the
  five styles in `canon/how-to-specify-it.md`.
- **Raft/Paxos/CAP internals** — vocabulary without decisions for effectively-centralized
  systems that do not operate a distributed database.
