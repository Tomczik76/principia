# Composing Programs (Rúnar Bjarnason)

**Source:** Scala eXchange 2017 closing keynote —
https://skillsmatter.com/skillscasts/10746-keynote-composing-programs (transcript and
Philip Schwarz's slide/transcript montage archived locally in `transcripts/`, untracked). Same author as
`constraints-liberate.md`, and the two talks share material — the TNT/detonate-late
metaphor, SQL-in-strings, effects-in-return-types are all imported *there*. This digest
carries only what is new here.

## The import

**Compositionality is a checkable property, not a vibe: the composition of the meanings
is the meaning of the composition.** Software is compositional to the extent that you can
understand the whole by understanding the parts plus the rules of composition — with
*nothing left over*: no external context, no reading the rest of the program. Each
subexpression means something on its own, and the whole means the composition of those
meanings. Structure and meaning mirror each other.

- **Compositionality ≠ composability.** Composability says a thing is *able* to be
  composed — "if you twist its arm," with glue code. Compositional expressions are
  natively and fractally composable: they do nothing *other* than be composed, and every
  level of nesting has the same character as the parts. Glue code is the tell that you
  have the weaker property. Corollary worth keeping: compositional software is naturally
  modular, but **modular software is not necessarily compositional** — module boundaries
  prove nothing about whether the parts mean anything alone.
- **The test is a homomorphism.** "Compositional reasoning" made precise:
  `F(a ⊕ b) == F(a) ⊗ F(b)` — the map of the combination is the combination of the maps.
  His worked example: a parallel word count works precisely when
  `wc(s1 ++ s2) == wc(s1) ⊕ wc(s2)` and the identity half holds (appending `wc("")`
  does nothing) — which forces the *partial-result type* to carry the boundary junk
  (split words at chunk edges) so that assembly is associative. That is a reusable
  design move: when you want divide-and-conquer or parallelism, design the intermediate
  representation until the homomorphism equations hold, and the assembly order stops
  mattering. And the equation is directly testable: it is a metamorphic property in
  Hughes's sense (`how-to-specify-it.md`) — the homomorphism hands you the property to
  write.
- **The named blockers.** Composition fails by *connected sequence* — the meaning of the
  whole depends on something outside the parts (his assembly-language example: no
  reading of individual instructions reveals that the program echoes keyboard to
  console) — and by *dependency* — the meaning of a part depends on the other parts or
  on history (his chess example: `Nd5` is unintelligible without the whole game; the
  same is true of any operation whose meaning needs the call history). Side effects are
  the special case where the map-fusion law breaks: `map(f ∘ g) == map(f) ∘ map(g)`
  fails the moment f or g prints, because the two sides print different things.
- **Correctness composes when meaning does.** In a compositional pipeline, the
  correctness of the whole is composed of the correctness of the parts plus the
  arrangement — which is the only reasoning that scales: for large systems there is no
  hope of arguing correctness *except* compositionally. And *systematicity* comes free:
  if you understand `f(x)` and `g(y)`, you already understand `f(y)` and `g(x)` — parts
  plus combination rules cover combinations nobody has written yet.

One cross-note so the two Bjarnason files cannot be read as contradicting each other:
this talk says monads *recover* composition for effectful functions (Kleisli composition
makes `A => M[B]` arrows compose like functions, with the monad laws as the homomorphism
into the plain category); `constraints-liberate.md` says monads compose *worse* than
applicatives. Both are true about different compositions — Kleisli composition chains
effectful arrows **within one monad**; the applicative advantage is composing **two
different effect types** mechanically. Within one effect, monads are the fix; across
effects, they are the cost.

## Do not import

The category-theory ladder (categories → monoids-as-one-object-categories → functors →
Kleisli) is the talk's pedagogy, not its payload — the operative content survives
entirely in the homomorphism test and the blockers above, so the vocabulary is not
worth its always-on surface. "Entropy and perplexity" as the general diagnosis is the
expressive-power argument of `constraints-liberate.md` wearing thermodynamic clothes —
one import is enough. And "if a system can be built at all, it can be built
compositionally" is an article of faith, not a decision procedure; admire it, don't
cite it.

## Agent-era note

Systematicity is the compositional case for agents: parts-plus-rules is exactly what
lets a fresh context produce correct *novel* combinations without having seen them —
`agent-era.md`'s context economics, from the construction side.

## Evidence

See `../case-studies.md` — Contrapunctus: the score-document hop chain is his
*dependency* blocker in production (no hop is intelligible alone; understanding any part
required reading the whole chain — the defect re-described as loss of compositionality).
`PitchPropertySuite` carries the algebraic laws that compositional reasoning runs on,
and its `Note.toPitch preserves midi` property is a genuine homomorphism shape — a map
between representations that preserves the observation. The Effect-based SSE pipeline
(`sseAsk.ts`: source → framing → decode, each stage meaningful alone over any stream) is
the FS2-style compositional pipeline shape, live — see the ledger's exactness entry.
