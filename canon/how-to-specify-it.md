# How to Specify It! (John Hughes)

**Source:** "How to Specify It! A Guide to Writing Properties of Pure Functions," LNCS
12053 (TFP 2019), open-access author version:
https://research.chalmers.se/publication/517894/file/517894_Fulltext.pdf (PDF archived
locally in `transcripts/`, untracked). Title after Polya's *How to Solve It*.

## The import

Property-based testing's hard part is not the tool; it is the *oracle problem* — knowing
what to assert about a randomly generated input. The paper's first commandment answers
the naive solution (recompute the expected result in the test):

- **Avoid replicating your code in your tests.** A predictor function is the
  implementation again — expensive, and low value, because "misconceptions in the
  implementation will be replicated in the test code." The whole discipline exists to
  state checks that are *independent* of the implementation's shape. (The agent-era form
  is sharper still — see below.)

**The five property styles**, each with its slogan and its place:

1. **Validity** — "every operation should return valid results." Define the datatype
   invariant as a function; check every constructor preserves it. Necessary, and *far*
   from sufficient: if every operation returned the empty structure, all validity
   properties still pass. Measured: validity properties missed five of the eight seeded
   bugs.
2. **Postconditions** — "postconditions relate return values to arguments of a single
   call"; found by asking "what should be True after calling f?". When the postcondition
   for one function would require reimplementing it (find's would), use his trick:
   *construct a test case whose outcome is easy to predict* — `find k (insert k v t) ===
   Just v` needs no oracle because the setup call created the fact being checked.
3. **Metamorphic** — "related calls return related results." When you cannot predict one
   result, you can still state how *changing the input* changes the output:
   `insert k v (insert k' v' t) ≃ insert k' v' (insert k v t)` (with a case split for
   equal keys). With O(n) operations usable as both subject and modifier, there are
   O(n²) candidate properties — a fertile source when no model exists. Individually
   weaker, powerful in combination; they are an axiomatization with no completeness
   guarantee. Preconditioned "weak" variants miss bugs precisely because the excluded
   tricky cases are where bugs live.
4. **Inductive** — a subset of metamorphic properties that covers all constructor cases
   is a complete specification by induction. But the induction carries a hidden
   *reachability* assumption (every value is expressible via the constructors you
   inducted over) — test it with completeness properties, which also justify the
   generator. Completeness checks need *structural* equality, not equivalence: the point
   is which shapes are reachable.
5. **Model-based** — "abstract away from details to simplify properties" (Hoare's 1972
   commuting diagram): map
   the concrete structure to a simple model (tree → sorted list) and require each
   operation to commute with its model version. One property per operation forms a
   complete specification. **Measured strongest by an order of magnitude**: mean tests
   to first failure 5.8, vs 56 (metamorphic) and 77 (postconditions) — because each
   model-based test validates the *entire* result, while a postcondition samples one
   random observation of it. His time-limited default: model-based + validity; when the
   model is too expensive or would resemble the implementation (replicating its bugs),
   metamorphic properties are the alternative.

**Test your tests.** Generators and shrinkers are code with the same invariants as the
code under test, and a bug in either produces very-hard-to-debug failures elsewhere:
`prop_ArbitraryValid` (all generated values valid — when THIS fails, every other failure
is noise; fix the generator first), `prop_ShrinkValid` (shrinking preserves validity —
his own shrinker broke the invariant and reported nonsense counterexamples). And
**measure the distribution**: his key generator left the queried key absent from the tree
in ~80% of tests — most of the test budget spent on the uninteresting case — fixed by
narrowing the key range so collisions occur. The choice of generator is a choice about
which cases matter; a generator that cannot reach the interesting case makes every
property it feeds vacuous.

**Two equalities.** Metamorphic properties forced an *equivalence up to observation*
(`toList t1 == toList t2` — different tree shapes, same contents), and it is the
equivalence, not structural equality, that belongs in the exported API: structural
equality distinguishes representations that clients must treat as equal. Structural
equality survives only for white-box checks (completeness/reachable shapes). This is the
testing-side face of the abstraction barrier — compare what callers can observe, not how
the artifact is shaped.

## Placement in this corpus

A roundtrip property is the testing face of parse-don't-validate: it certifies that the
parse and its inverse agree, which is what a boundary owes its interior. Exact
representations are what let algebraic properties *hold* — associativity is perfectly
statable over floats, it is simply false there, which is detonate-late's point in
testing form. And the jurisdiction line stands: **a property certifies the artifact,
never the wiring** — the bar-map case study is a property that proved equivalence while
the value never arrived; arrival belongs to the red-e2e-first and test-the-seam rules,
not to PBT.

One non-conflict worth recording, because it looks like a violation of the paper's first
commandment: a hand-ported twin (the per-platform parser topology in
`parse-dont-validate.md`) *is* implementation replicated in test-facing code. It exists
for platform reasons, not testing ones, and its parity suite's jurisdiction is
**divergence between the twins, not correctness** — it sits at the degenerate end of
Hughes's own model-resemblance caveat, where shared misconceptions pass both sides. That
is a reason to keep the twin count at one and lean on independent properties per
platform, not a reason to call parity a correctness oracle.

## Do not import / scope

The paper is titled and scoped *pure functions*. Stateful and concurrent code needs
different machinery (operation sequences against a state-machine model — his Quviq line
of work; queued separately). The eight-bug measurement is one example, one seeding —
import the direction (model-based ≫ postconditions; validity alone weak), not the
magnitudes. And properties do not retire example tests wholesale: examples pin
regressions cheaply and document intent, and locked regression baselines are a
complementary oracle where no model exists.

## Agent-era note

Hughes's misconception-replication warning is the pre-agent statement of the
decorrelation argument; `../agent-era.md` carries it.

## Evidence

See `../case-studies.md` — Contrapunctus: the bar-map inertness property (jurisdiction:
artifact, not wiring), `rhythm/Rational.scala` (exactness as the precondition for
algebraic properties *holding*), and the `Pitch` primitive's two-suite pattern —
`PitchSuite`'s wire→`Pitch`→wire roundtrip section alongside `PitchPropertySuite`'s
ScalaCheck properties (associativity of `+`, `(p + m) − m == p`, `m + m.invert ==
PerfectOctave`), a production instance of algebraic properties over an exact
representation.

Admitted on source authority, awaiting a paid-for anchor (see the ledger's IOU section):
test-your-tests (generator/shrinker validity), measure-the-distribution, and
equivalence-not-structural-equality as the exported equality.
