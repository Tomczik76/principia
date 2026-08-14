# Queue — sources to mine, and sources rejected

## Queued (ranked)

1. **Pat Helland — "Life Beyond Distributed Transactions: An Apostate's Opinion" (CIDR
   2007).** The ACID-island crossing discipline generalized into a design method:
   entities as the unit of atomicity, at-most-once messaging, idempotency as a
   first-class design input rather than a retrofit. Companion: "Memories, Guesses and
   Apologies." Would deepen `canon/acid-island.md`.
2. **Saltzer, Reed & Clark — "End-to-End Arguments in System Design" (1984).**
   Correctness checks belong at the endpoints; reliability in the middle is only an
   optimization. Unifies two things the corpus already believes separately: webhook
   fail-closed seams and red-e2e-first testing are both end-to-end arguments. Canon-tier.
3. **Kleppmann (weak-isolation talks, e.g. "Transactions: myths, surprises and
   opportunities") + Bailis et al., "Feral Concurrency Control."** Targets the sharpest
   known gap in the corpus: the enforce-in-the-one-transaction rule is silent about two
   *concurrent* transactions racing under read committed. Bailis measured exactly that
   failure mode in app-level validations at scale.
4. **Hyrum's Law.** Anything you expose gets depended on; Ousterhout endorses it in the
   Google talk Q&A ("applications find every crevice and sink their roots"). Small;
   admit only with a paid-for anchor (candidate exists: a hook exported from a layout
   module solely so a test could call it — which then became load-bearing).
5. **Richard Cook — "How Complex Systems Fail."** The operations axis the corpus lacks
   (catastrophe requires multiple small failures; every defense is a new failure source;
   hindsight bias). Admit when an ops-shaped case study earns it.

## Rejected as redundant (do not re-litigate without new evidence)

- **Hickey, "The Value of Values" / "Hammock Driven Development"** — covered by core's
  least-power/immutability defaults and its red-check-first testing rule respectively.
- **Yaron Minsky, "Effective ML"** — origin of "make illegal states unrepresentable";
  the rule is already in core with paid-for evidence in the ledger.
- **Richard Feldman, "Making Impossible States Impossible"** — same rule, Elm-shaped.
- **Gary Bernhardt, "Boundaries"** — functional core / imperative shell is core's
  detonate-late rule applied to effects (execute at the last step, at the run boundary);
  its avoid-mocks testing payoff is achieved more directly by integration-testing against
  real dependencies.
- **Moseley & Marks, "Out of the Tar Pit"** — the ancestor of half the corpus; reading it
  after Hickey is re-derivation.
- **Raft/Paxos/CAP internals** — vocabulary without decisions for effectively-centralized
  systems that do not operate a distributed database.
