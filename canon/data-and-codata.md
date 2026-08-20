# Data and Codata (Welsh)

**Source:** Noel Welsh, *Functional Programming Strategies in Scala with Cats*
(scalawithcats.com, free online; Scala 3). Read for Ch 2 (structural recursion
and corecursion), Ch 5 (Reified Interpreters), Ch 14 (Tagless Final
Interpreters), Ch 15 (Optimizing Interpreters and Compilers). Companion to
`tagless-final.md`, which holds the same initial/final result from Kiselyov —
this file is admitted for what Welsh adds, not for that overlap.

## The import

- **Data is defined by how it is CONSTRUCTED; codata by how it is USED.** The
  more general frame under initial-versus-final: data enumerates its cases and
  is eliminated by pattern matching, codata declares its observations and is
  eliminated by calling them. The choice rule is short enough to apply at a
  whiteboard — *use data when you transform inputs into outputs by matching on
  cases; use codata when you are defining what operations a consumer may
  perform.* It generalises past DSLs to every interface decision, which is why
  it earns a file next to the DSL-shaped one.

- **The trade is exhaustivity versus open implementation, and you pick which
  one the compiler enforces.** Data buys exhaustivity checking: add a case and
  every consumer breaks at compile time. Codata buys new implementations
  cheaply and fixes the interface instead. This is the expression problem
  stated as a decision rather than a lament — and it says which failure you
  would rather have the compiler catch.

- **Derive the implementation from the type instead of inventing it.**
  Structural recursion gives the skeleton — "for each branch in a sum type we
  have a distinct `case` in the pattern match" — plus the recursion rule:
  *whenever the data is recursive the method is recursive in the same place.*
  Structural corecursion is the mirror: consider the possible OUTPUTS, which
  are the constructors, then work out the conditions under which each is
  called. Blanks get filled by three moves: reason independently by case,
  assume the recursive calls already work, and follow the types. The practical
  claim is that a large share of ordinary functional code is not designed at
  all, it is *derived*, and treating it that way makes review mechanical.

- **The interpreter ladder is a sequence, not a leap.** Reify the language as
  data, write the obvious interpreter, then transform it — continuations,
  then an explicit stack, then a machine — with each step a mechanical
  rewrite rather than a redesign. Optimisation as staged transformation is
  what makes "make it a data structure first" affordable in production rather
  than merely elegant.

- **Which rung: stage when the program is fixed before its inputs arrive, fuse
  when it is not.** House sharpening, evidenced — the ladder says optimisation
  is a sequence of mechanical rewrites, not which rewrite a given interpreter
  admits, and the two this corpus has paid for are not interchangeable.
  STAGING splits a two-input interpreter by arrival time: `Compile.pred` takes
  the predicate tree alone and returns `F => Boolean`, so the match on rule
  structure runs once at rule-set construction instead of once per frame — and
  the load-bearing detail is that the recursive calls sit OUTSIDE the returned
  closure, since moving them inside rebuilds the interpreter with extra
  allocation. FUSION collapses a one-input traversal: `Pulse.flatten` walks the
  tree once into a builder rather than a generic fold plus `++`. Staging a
  one-input function buys nothing — no early argument to specialise on, so the
  closure tree is allocated only to be walked once. Read the criterion off the
  signature: two arguments arriving at different times, or one. The staged
  rung's price is that its residual closures go stale when the program changes,
  so something must own rebuilding them.

- **A compiler over data may rewrite its input; an interpreter made of
  functions has no input to rewrite.** House sharpening, evidenced — the
  staged rung's win is not only removed dispatch. `Compile.rule` runs `Pred.nnf`
  before folding, and `Compile.sharedPass` expands one quantifier across a
  whole rule set instead of re-enumerating per rule, which is where the 0.43×
  came from. Both moves require SEEING the program, so the final encoding
  reaches them only by reifying to data first. This is the performance-side
  twin of "whole-tree operations are native only on data": normalisation,
  shared-subexpression hoisting and reordering are whole-tree operations that
  happen to be about speed.

## Do not import

- **The Cats tutorial spine** (Monoid/Functor/Monad instances, the case
  studies). Good teaching, but the corpus already runs on cats and does not
  need a second introduction to it.
- **Chapter 15's specific machines** (CPS → stack machine → bytecode) as a
  prescription. The ladder's EXISTENCE is the import; how far to climb is a
  measurement, and this corpus stopped at a staged compile because that is
  where the numbers stopped improving.
- **"Codata is functions, data is ADTs" as a slogan.** Welsh is careful that
  the distinction is about construction versus observation, not syntax; a
  trait with one method is still codata, and copying the slogan without the
  criterion produces the usual interface-per-class sprawl that
  `deep-modules.md` and `wrong-abstractions-surface-area.md` both refuse.

## Evidence

`case-studies.md`, Contrapunctus — the rule-DSL bake-off and its migration.
The same codebase applied Welsh's criterion twice and got OPPOSITE answers,
which is the strongest form the evidence could take:

- **Rules chose DATA.** `Atom[F]` / `Pred[F]` / `Quantifier[F]` are an ADT
  because the work is whole-tree — describe, normalise, search for a
  witness — and because adding an atom must break every interpreter at
  compile time. The repo escalated match-analysis warnings to errors to make
  exactly that guarantee real, which is Welsh's exhaustivity half bought
  deliberately.
- **Key detectors chose CODATA.** `KeyDetector` is a trait defined by what a
  detector DOES (`name`, `detect`), because new detectors must be cheap and
  nothing needs to inspect a detector's structure. The one place that must be
  total — mapping a router's choice to a detector — keeps a sealed enum next
  to it, so the *selector* is data while the *implementations* are codata.

The derivation half is evidenced by the cata-as-spec pair: `Traverse[Pulse]`
is the structural recursion the recursive `Pulse` type dictates, and the fused
hot paths are certified against it. That pair is also the fusion half of the
rung criterion, and the bake-off's `Compile.scala` is the staging half — the
same codebase, two interpreters optimised by different rewrites because
`Pred` evaluation has two inputs arriving at different times and `Pulse`
traversal has one. See `tagless-final.md` for the initial/final result this
generalises, `denotational-design.md` for the parity obligation both fast
forms owe, and `simple-made-easy.md` for why the construct table there does
not transfer to Scala 3.
