# Denotational Design with Type Class Morphisms (Elliott)

**Source:** Conal Elliott, "Denotational design with type class morphisms" (2009;
paper archived in `transcripts/` as
`elliott-denotational-design-type-class-morphisms-2009.pdf`, stable upstream in
`fetch.sh`; the companion talk is "Denotational Design: From Meanings to Programs").
Direct lineage: Strachey/Scott denotational semantics applied to *library* design.

## The import

- **Ask what it MEANS before what it does.** For each abstract type, name the
  mathematical object it denotes and write the semantic function μ (the paper's ⟦·⟧):
  "A map is a representation of *what mathematical object*?" — ⟦Map k v⟧ = k → Maybe v,
  and every operation's meaning is defined against that model before any
  representation exists. The denotation is the interface's real contract; the
  representation is negotiable forever after. (This is `deep-modules.md`'s
  interface/implementation split with the interface made *mathematical* — and
  therefore checkable.)

- **"The instance's meaning follows the meaning's instance."** The paper's boxed
  principle. When the type gets a `Monoid`/`Functor`/`Traverse` instance, μ must be a
  homomorphism: the meaning of `a ⊕ b` is ⟦a⟧ ⊕ ⟦b⟧, the meaning of `empty` is the
  meaning's `empty`. An instance that breaks this misleads every generic consumer that
  was promised the class's algebra. Decision procedure: before shipping an instance,
  write μ and check each method commutes with it — "the laws thus come, if not 'for
  free', then 'already paid for'."

- **A failing morphism check is a design signal, not a test failure.** "Sometimes the
  TCM property fails, and when it does, examination of the failure leads to a simpler
  and more compelling design for which the principle holds." The broken law points at
  the wrong denotation or the wrong operation set — redesign toward the model that
  makes the law hold, rather than documenting the exception.

- **Equality is semantic.** a ≡ b ⟺ ⟦a⟧ = ⟦b⟧ — the type's exported equality must be
  equivalence of meaning, or substitution breaks and no instance built on the type can
  be trusted. (Hughes states the same requirement from the property-testing side;
  Elliott grounds it: it is the precondition for μ existing at all.)

- **The denotation is the specification; fast forms certify against it.** House
  sharpening, evidenced: keep the lawful instance as the executable meaning, and admit
  fused hot-path implementations only with a parity proof against it plus the measured
  constants — Elliott's purism relaxed exactly one notch (representation-level
  overrides allowed, *certified*), which preserves the property he actually cares
  about: reasoning happens against the meaning.

## Do not import

- **The FRP corpus** (behaviors/events denotations, memo tries, the Haskell
  implementation apparatus) — the principle travels; the artifacts don't.
- **Purity absolutism at the implementation layer.** The house allows contained
  imperative kernels on measured hot paths; the morphism obligations sit on the
  *interface*, which is exactly where Elliott put them.
- **"Good semantic models tend to be reusable" as a license to import someone else's
  model unexamined** — the model is chosen per type, against its own domain.

## Evidence

`case-studies.md`, Contrapunctus — **the cata-as-spec pair (2026-08-15)**: the lawful
`Traverse[Pulse]` instance is the executable meaning of the rhythm tree, and the fused
hot-path forms are certified against it at the production entry points with their
measured constants recorded — the paid instance of both the morphism obligation and
this file's one deliberate relaxation of Elliott (representation-level overrides
allowed, *certified*). That entry also carries the negative instance —
`NoteType.equals` breaking semantic equality — which is bullet 4 failing in the wild.
See `theorems-for-free.md` (where laws come from when polymorphism can supply them)
and `how-to-specify-it.md` (how to generate against them).
