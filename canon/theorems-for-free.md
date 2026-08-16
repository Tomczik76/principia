# Theorems for Free! (Wadler)

**Source:** Philip Wadler, "Theorems for Free!" (FPCA 1989; author's copy archived in
`transcripts/` as `wadler-theorems-for-free-fpca-1989.ps`, stable upstream in
`fetch.sh`). The result it popularizes is Reynolds' abstraction theorem
(parametricity); the paper's contribution is making it a working tool: "Write down the
definition of a polymorphic function on a piece of paper. Tell me its type, but be
careful not to let me see the function's definition. I will tell you a theorem that
the function satisfies."

## The import

- **A polymorphic type is a theorem generator.** Any `r : ∀X. List[X] → List[X]`
  satisfies `map(f) ∘ r == r ∘ map(f)` — not because of what `r` does but because its
  type cannot SEE the elements, so it can only rearrange, duplicate, or drop them, and
  every such operation commutes with mapping. The engineering reading: polymorphism is
  not (only) reuse — it is a constraint budget. The freer the signature, the fewer the
  implementations, the more behavior is proven before the body is read. When writing a
  combinator, generalize its type as far as it will go *for the theorem*, not for the
  callers (`constraints-liberate.md` is this same trade priced from the API side).

- **Free theorems are the canonical metamorphic-property shape.** Every free theorem
  is a commutation square: transform-then-run equals run-then-transform. That is
  precisely the property shape `how-to-specify-it.md` reaches for when there is no
  oracle — and Wadler shows where such squares come from: they are what polymorphism
  would have guaranteed. So the square is the FIRST property to try on any function
  with a relabeling symmetry in its domain.

- **Concretion converts the theorem from free to owed.** A domain function that must
  inspect its values (an analyzer that reads pitches; a parser that reads characters)
  cannot be parametric in them, and no theorem is free. The square does not stop being
  the right specification — it stops being automatic. State it anyway, over the
  domain's own symmetry group, and PAY for it with a suite. The paid instance: an
  analysis engine deliberately monomorphic in pitch, whose equivariance
  (analysis commutes with transposition) is asserted engine-wide as a law and tested,
  because the algebra of the pitch type (a torsor: intervals act, differences exist,
  no privileged origin) makes the square statable at all.

- **Purity is the license.** The paper's own caveats: the theorems weaken under `fix`
  and strictness, and fail entirely for functions that can inspect what their type
  says they cannot (polymorphic equality there; runtime-class inspection, reflection,
  and side effects in Scala). Parametricity is only as true as the discipline that
  keeps functions from cheating — the FP house rules are not style, they are what
  keeps the theorems valid.

## Do not import

- **The relational-semantics machinery** — frames, the relational reading of types,
  the proofs. The working engineer consumes the generated theorems, not the generator.
- **The strictness/fix conditions in detail** — Haskell-specific; in Scala the analogue
  is the purity caveat above, already imported.
- **"Free theorems replace tests."** They never did — in the polymorphic case the
  compiler enforces the precondition, not the property's use; in the monomorphic case
  (most of any domain engine) the theorem is owed, and only a suite pays it.

## Evidence

`case-studies.md`, Contrapunctus — the equivariance suite: the engine-wide
commutation square (analysis ∘ transpose == transpose ∘ analysis) over the full
chord-ID → labelling → refinements pipeline, diatonic and chromatic, including a
modulating case — the owed, monomorphic analogue of this file's free square, statable
because `Pitch` is kept a lawful ℤ²-torsor. See `how-to-specify-it.md` for the
property-shape taxonomy this file feeds, and `constraints-liberate.md` for the same
polymorphism-as-constraint trade priced at the API boundary.
