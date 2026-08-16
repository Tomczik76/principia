# Profunctor Optics (Milewski)

**Sources:** Bartosz Milewski, "Profunctor Optics: The Categorical Approach" (Lambda
World 2017, Cádiz; auto-generated-caption transcript archived in `transcripts/`,
untracked) and its written companion, "Profunctor Optics: The Categorical View"
(bartoszmilewski.com, 2017-07-07). The talk twice defers to Bjarnason's adjunctions
talk from the same conference — `constraints-liberate.md`'s author, two slots over —
and its derivation leans on Pastro–Street's Tambara-module paper; both the adjunction
detour and the paper stay out (see Do not import).

## The import

- **An accessor should be a value that composes.** The talk's entire payoff: an optic
  is `forall p. Constraint p ⇒ p a b → p s t` — *just a function* — "and the beautiful
  thing about functions is that you can compose them." A lens composed with a lens is a
  lens deeper in; telescoping into a structure costs one composition, not new plumbing.
  The review-time test: does reaching a sub-sub-object mean composing two accessors
  that already exist, or hand-writing a third?

- **The dimap decomposition: contravariant in what you consume, covariant in what you
  produce.** A profunctor is adapted by a *pair* of functions, one reversed: "when
  you're consuming, you have to adjust the input; when you are producing, you adjust
  the output in the opposite direction." The decision procedure this buys: when
  checker/validator/renderer B looks like A applied to a transformed view, do not fork
  A. Write the view (B's world → A's world), run A unchanged, map A's findings back
  (A's coordinates → B's), and whatever refuses to fit the two adapters becomes an
  explicitly **named residual**. A fork is a second implementation that drifts; the
  dimap form is one implementation, two adapters, and a residual you can point at —
  and the decomposition is checkable, because the pipeline can be reconstructed and
  certified equal to the fused production form.

- **Yoneda is a representation license.** "The left-hand side is a polymorphic
  higher-order function; the right-hand side is what we normally call data. These two
  representations are totally equivalent — and sometimes you want to use a different
  representation for your data type, for performance reasons, or because it composes
  better." This is the theorem underneath `tagless-final.md`'s initial/final
  interconvertibility: data when you need to inspect the whole tree, functions when
  you need composition or speed — expressiveness never decides, so choose on the
  operational ground and *certify the swap by law*, never by resemblance.

- **Strong vs Choice is product-focus vs sum-focus — say which you mean.** A lens
  presumes its focus is always present: "the whole data structure S can be split into
  a product of some C — the environment — and the focus A." A prism presumes the focus
  may be absent (environment *or* focus; the tensor swaps product for sum). Reaching
  for the always-there accessor on a sometimes-there part is the wrong-SHAPE failure
  (`wrong-abstractions-surface-area.md`) at the accessor scale, and the type
  constraint is where it surfaces at compile time instead of at `null`.

## Do not import

- **The derivation.** Yoneda in the functor category, pro-Yoneda, Tambara modules, the
  Pastro–Street co-end, the adjunction chain — the machinery exists to prove the
  interface honest, and its user-facing content is fully spent in the bullets above.
  The talk's own framing licenses the cut ("it's perfectly normal in category theory…
  things clear out after a moment") — the tour is for deriving new optics, not for
  using them.
- **An optics library.** The import is the decomposition discipline, not a dependency.
  The paid instance below uses no lens library — the seam is a contramap, a location
  remap, and a named carve-out. A library admission (Monocle et al.) would be its own
  surface-area case under Markbåge.
- **Haskell encoding detail** — constraint-kind phrasing, the existential lens as an
  implementation prescription.

## Evidence

`case-studies.md`, Contrapunctus — the species-profunctor theorem (2026-08-15): a
300-line bespoke species-2 checker proven, exact-list over generated contexts in both
layout modes and on partial inputs, to contain no new motion-rule logic — it IS the
shared first-species rules dimapped (contramap the context, remap the locations) minus
one named carve-out. `SpeciesProfunctorSuite` reconstructs the pipeline as an explicit
`CheckPass[C]` with `dimap` and certifies it equal to production, whose fused seam now
names its three operations at the call site. See also `tagless-final.md` — its
initial/final interconvertibility is this file's Yoneda bullet at the encoding scale.
