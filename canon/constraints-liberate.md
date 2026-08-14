# Constraints Liberate, Liberties Constrain (Rúnar Bjarnason)

**Source:** Scala World 2015 — https://www.youtube.com/watch?v=GqmsQeSzMdw (transcript
archived locally in `transcripts/`, untracked).

## The import

The composition-side complement to Hickey: where Hickey asks whether concerns are
entangled *inside* the artifact, Rúnar asks what a caller can conclude *without opening
it*. A constraint accepted at one level becomes freedom and reasoning power at the level
above, and the asymmetry is in who pays: the author feels the restriction once; every
consumer collects the freedom forever after. Most of the software we will ever write is a
consumer of the software we are writing today, so constraining now is paying the toll on
the cheap side. And since a composite needs the union of its components' privileges, every
capability a component does not claim widens where it can be deployed and shrinks what a
test must control.

- **Reach for the least powerful construct that says exactly what you mean.** The power
  ladder over a collection — `map` → `fold` → explicit recursion → local mutation → shared
  mutable state — is an inference ladder for the reader: each rung up buys capability and
  spends what a caller can conclude from the signature alone. This is the *reason* to default to
  combinators over `var`/`while`, and it prices the standard hot-path escape hatch
  correctly: if local mutation is permitted only with a comment saying why the functional
  form was too slow, that comment names what was spent (reader inference) and what was
  bought (speed).
- **Narrow what a signature knows to narrow what it can be.** `Int => Int` has on the
  order of 4 billion^4-billion implementations; `A => A` has one. Prefer the most general
  type parameters that still compile — a helper that never inspects its elements should
  take `List[A]`, not the concrete type. The function-side twin of "make invalid states
  unrepresentable," which only constrains data.
- **Detonate as late as possible.** Keep the symbolic, structured, exact representation as
  long as you can; go to the large lossy one — strings, doubles, rendered output, executed
  effects, binaries — as the last step. A small language embeds into a larger one later;
  the reverse leaks (you cannot put the explosion back in the dynamite). His
  generalization of Knuth: *premature loss of precision* is the root of all evil. His
  Pythagoras example: square the double you got from `sqrt(8)` and you get "something
  like eight — not exactly eight," and what is lost is not digits but the algebraic
  relationship between the squares. Building SQL, markup, or printer output by string
  concatenation instead of a structure compiled at the end is the same mistake in prose
  form. Suspended effect systems (an Effect as a *description* of a computation,
  unexploded until the run boundary) are this rule applied to side effects.
- **Power that composes only by hand is a cost, not a bonus.** His applicative-vs-monad
  and future-vs-actor pairs generalize: of two abstractions, the strictly-more-powerful
  one participates in strictly fewer mechanical compositions and supports strictly fewer
  conclusions (`Any => Unit` has no algebra at all). "Why wouldn't I take the more
  powerful one?" carries its own answer — precisely because it can do more, you know less
  about what it will do.

## Not imported (by omission, not conflict)

The Galois-connection/adjunction formalism in the talk's back half is the mathematical
underpinning (producer capability ↔ consumer constraint, witnessed by currying) but adds
vocabulary without changing any decision the bullets above don't already cover.

## Evidence

See `../case-studies.md` — Contrapunctus: `rhythm/Rational.scala` (exact fractional time),
the Effect.ts suspension architecture, `Pulse.Atom(NonEmptyList[A])`.
