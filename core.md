# Principia — core

The always-on distillate: decision procedures only, self-contained, importable into any
project's CLAUDE.md via `@~/Dev/principia/core.md`. Full arguments live in
`~/Dev/principia/canon/`; earned evidence in `~/Dev/principia/case-studies.md`; how
entries get admitted in `~/Dev/principia/METHOD.md`. This file has a hard budget: a new
line enters only by displacing one.

## Arguing about designs

- **Name the axis.** *Simple* means unentangled — one concern per artifact, a property of
  the thing, objectively checkable. *Easy* means near to hand — familiar, short, matches
  the neighbors, a property of the reader. "This complects X with Y" decides a design
  question; "this is unfamiliar / longer / adds a file" does not, on its own. The default
  pull is always toward easy — shortest diff, fewest new files — so naming the axis is the
  cheapest correction.
- **State the tradeoff, not only the benefit.** A proposal with only its upside named is
  incomplete. Say what it complects and what it costs in the same breath.
- **Claims of reach or completeness require a printed measurement.** "Reaches N consumers",
  "only X does this", "none of the M cases" — paste the count or do not write the
  sentence. Measured bias: false claims overstate reach; they do not understate it.
- **Design it twice.** Sketch two genuinely different decompositions before committing —
  you cannot state the tradeoff of an alternative you never generated. For existing code,
  the ideal: end up where a from-scratch build, knowing what you know now, would land.
- **Spend top-down authority on the least important decisions.** Enforce the style guide
  strictly precisely *because* style is unimportant — it kills relitigation. Save the
  arguing for decisions that matter.

## Shapes of data

- **Make invalid states unrepresentable.** The procedure: count the states the rule
  permits, then give the type exactly that many inhabitants. A record of optional fields
  plus a prose rule ("at least one of these must be present") is the smell — the optional
  encoding always admits a state the rule forbids; replace it with one case per legal
  combination, and exhaustive matching drags every consumer along. Where types cannot
  reach, the same move one layer down is a `CHECK (num_nonnulls(a, b, c) = 1)`.
- **Make broken data unreachable, not merely handled.** Enforce an invariant in the layer
  that owns it: a stored reference is a real foreign key with a cascade decision, never a
  bare id the app resolves defensively. Where the constraint can't reach, enforcement
  lives in the one transaction that makes the change — never as compensating filters
  spread across readers. But a transaction is not a lock: at default isolation two
  check-then-act transactions do not see each other, so an invariant spanning rows the
  write doesn't touch (uniqueness, a reference under delete, "at least one left") needs
  the database — a constraint or `FOR UPDATE`; the racing check only shrinks the window.
- **One canonical representation; derive the rest.** Two parallel forms needing manual
  sync = every edit is a drift bug and the sync function is the bug surface. A layering
  chain where each hop RE-LISTS the fields it forwards is the same defect at N-fold: one
  datum in N representations, and the hop list is the sync function. Refuse to build a
  layer that cannot state what it hides. The general form is data versus codata: DATA is
  defined by how it is constructed and eliminated by matching its cases; CODATA by the
  observations it offers and eliminated by calling them. Choose per subsystem, by the
  work: data when you transform inputs by cases — it buys exhaustivity, so a new case
  breaks every consumer at compile time; codata when you are declaring what a consumer
  may do — it buys cheap new implementations and freezes the interface instead. For a
  DSL specifically, encode by the least fold-like interpreter: initial (data) and final
  (functions) are interconvertible for a fixed signature, so expressiveness never
  decides; whole-tree operations (inspection, search, normalization) are native only on
  data, and speed is one more interpreter away — closures when the program is fixed
  before its inputs, fusion when not (`canon/data-and-codata.md`, `canon/tagless-final.md`).
- **Know when a change leaves the ACID island.** A system is centralized while its whole
  state updates atomically; distributed the moment one call mutates state the transaction
  cannot reach — and every external API call IS a state mutation somewhere. Prefer designs
  that stay inside. A crossing is a design-time commitment: the process can die between
  the DB write and the external effect, so the transaction records intent first, and the
  seam gets an idempotency key, a ledger row, or persist-result-then-process.

## Boundaries

- **Parse, don't validate.** A validator checks a property and discards the proof (returns
  `Unit`/`Boolean`); a parser returns a refined type that carries it, so the check can
  never need repeating. Given a partial function, strengthen the argument type rather than
  weaken the return type. One parser per boundary (per platform, if a boundary spans
  platforms — twins kept honest by parity tests, whose jurisdiction is divergence between
  them, never correctness), and everything routes through it. A defensive check deep in
  the interior is a diagnostic that the boundary failed to parse; the fix direction is
  always upward. When the invariant won't fit in a type, a smart constructor over an
  opaque type makes the parse the only source of the value — and that type's exported
  EQUALITY must be equivalence of meaning, or substitutivity fails and every instance,
  property and cache built on it inherits the lie (`canon/denotational-design.md`). Caveats: not every invariant
  merits a type; complex input can need several passes; authorization may precede parsing.
- **Detonate as late as possible.** Keep the symbolic, structured, exact representation as
  long as you can; go lossy — strings, doubles, rendered output, executed effects — as the
  last step. A small language embeds into a larger one later; the reverse leaks.
  Premature loss of precision is the root of all evil. (With parsing, this is one
  symmetry: gain structure as early as possible on the way in, lose it as late as
  possible on the way out.)

## Modules and abstractions

- **Modules should be deep.** A module's worth is functionality per unit of interface,
  where *interface* is everything a caller must hold in mind — side effects, dependencies,
  ordering — not just signatures. Few meaty layers beat many skinny ones. Design the
  interface for what the mechanism does, not for the one current caller's quirks: slightly
  general-purpose is usually simpler *and* deeper. When arguing about a design, reach for
  the countable symptom — *change amplification* (one change, many sites) over *cognitive
  load* or *unknown unknowns*.
- **Reach for the least powerful construct that says exactly what you mean.** Each rung up
  the power ladder (`map` → fold → recursion → local mutation → shared state) buys
  capability and spends what a caller can conclude from the signature alone. Narrow what a
  signature knows to narrow what it can be: prefer the most general type parameters that
  still compile.
- **Pull complexity downward — unless the caller owns the decision.** Absorb the gnarly
  part and hand callers a computed default; but when the module cannot know the right
  answer, a required parameter beats a wrong default.
- **Define errors out of existence, bounded by the contract.** Redefine the operation so
  the failure case has meaningful semantics where possible; where the contract is
  fundamentally unfulfillable, the failure must surface. An exception earns its keep in
  proportion to how far it propagates — caught adjacent to the throw, it is a clunky
  return value.
- **DRY is for facts; patterns wait for bugs.** The same knowledge stated twice — a
  formula, a scoring rule, an encoding — is a queued drift bug: extract immediately.
  Similar-shaped code serving different concerns is extracted only when the repetition
  demonstrably causes bugs. The gate governs *convenience* abstractions only:
  invariant-enforcing structure (opaque types, parsers, foreign keys, sealed ADTs) is
  admitted on the bug class it makes unrepresentable — that is the gate passing, not an
  exception. And separating two concerns usually produces MORE files: DRY is one *fact*
  in one place, not one *concern* per artifact, and the two point opposite ways when a
  shared helper serves callers entangled for different reasons. Degradation signature of a wrong abstraction: a parameter
  whose job is to tell the helper which caller is calling. The exit is re-inlining —
  inline into every call site, delete each site's untaken branches, extract only what
  survived everywhere (sometimes nothing; that outcome is fine).
- **An abstraction must remove at least as much surface area as it adds** — surface being
  the sum of what every future reader must learn to be productive. Net-new surface is a
  cost even when the code got shorter.
- **Explicit beats implicit, asymmetrically.** You can recover from an explicit API later
  by adding sugar; you cannot cleanly undo an implicit one — when implicit wiring breaks,
  there is no call site to read.

## Tests

- **When a change threads a value through layers, write the end-to-end check FIRST and let
  it stay red until the last commit.** A check that fails until the work is finished is
  the only thing that distinguishes "staged and inert" from "staged and forgotten."
- **Test the seam, not the two ends.** A test arbitrating whether a value reached its
  consumer must call the production entry point, never rebuild the computation.
- **A test that has never run is worse than an absent one** — it occupies the slot where
  real coverage would go. A guard that cannot find its anchor must fail, not pass, and a
  generator that cannot reach the interesting case makes every property it feeds vacuous.
- **Prefer properties to examples where structure exists.** An example written beside the
  implementation replicates its misconceptions; a property plus a generator states the
  check independently of the code's shape. Reach for a model-based property when a simple
  abstract model exists (measured strongest), metamorphic relations when it does not;
  validity invariants alone are weak. A metamorphic relation is a commutation square
  (transform-then-run == run-then-transform), and a polymorphic signature DONATES one —
  the type cannot inspect what it abstracts over, so the square holds for free. Concrete
  code that must read its values owes the same square instead: state it over the domain's
  own symmetry and pay for it with a suite (`canon/theorems-for-free.md`). Jurisdiction: a property certifies the artifact,
  never the wiring — arrival is the e2e check's job.
- **Guardrails do not tell you which way to go.** A passing suite says nothing broke,
  never that the shape is right. Reach for a structural fix when the failure is
  structural; more tests around a tangle measure the tangle.
