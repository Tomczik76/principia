# Wrong Abstractions and Surface Area (Sandi Metz, Sebastian Markbåge)

**Sources:** Metz, "The Wrong Abstraction" (essay, 2016-01-20,
https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction); Markbåge, "Minimal API
Surface Area" (JSConf EU 2014 — the earlier, stronger form: "it's much easier to recover
from no abstraction than from the wrong abstraction"; transcript archived locally in
`transcripts/`, untracked).

## The import

Together they give DRY-for-facts its admission gate, its failure signature, and its exit.

- **The unit of an abstraction's cost is surface area** — the sum of what every future
  reader must learn to be productive: Ousterhout's interface-as-mental-load summed over
  everyone who will ever touch the code. An abstraction must remove at least as much
  surface as it adds; net-new surface is a cost even when the code got shorter.
- **The admission gate: abstract when the repetition causes bugs, not when it offends.**
  Repetition of a *fact* — the same knowledge stated twice — is a queued drift bug:
  extract immediately (that is DRY, correctly scoped). Repetition of a *pattern* —
  similar-shaped code serving different concerns — waits until it demonstrably bugs. "It
  might look ugly, but it's not hurting anyone." This turns DRY's escape clause from
  taste into a decision procedure.
- **The degradation signature: a parameter whose job is to tell the helper which caller is
  calling.** Metz's lifecycle: the next programmer finds almost-right shared code and,
  under the sunk-cost authority of existing code ("someone spent effort on this; it must
  be right"), adds a parameter and a branch instead of questioning the fit — repeated
  until the helper is interleaved conditionals serving vaguely related purposes. Each
  parameter-plus-branch pair is a caller paying rent on an abstraction that stopped
  fitting; in Hickey's terms, the branch is proof the helper complects concerns that were
  only superficially similar, and the pull to keep it is the *easy* axis wearing
  camouflage.
- **The exit is re-inlining, and it is progress, not retreat.** Inline the helper into
  every call site; at each site delete the branches that site never takes; only then
  extract what survived everywhere — which is sometimes nothing, and that outcome is fine.
  Backing out restores the information the flag parameters had destroyed: what each caller
  actually needs. The test for any proposed extraction is Ousterhout's from-scratch ideal:
  would these callers share this helper if the code were written today, knowing what we
  know now? A sharing that needs a caller-identity flag on day one fails on day one.
- **Explicit beats implicit, and the asymmetry is Rúnar's.** You can recover from an
  explicit API later by adding sugar; you cannot cleanly undo an implicit one — when
  implicit wiring breaks (his example: implicit event bubbling), there is no call site to
  read. Sugar over explicit code is embedding a small language in a larger one later;
  implicit magic is pre-detonated. (Historical footnote that proves the framework can
  arbitrate its own author: React hooks fail the explicitness test — state keyed on call
  order, linter-enforced rules — and were justified by the *other* principle: they removed
  more surface than they added. The accounting rule outranked the explicitness rule.)
- **Spend top-down authority on the least important decisions.** Enforce the style guide
  strictly precisely *because* style is unimportant — it kills relitigation on every diff,
  and nobody has to fight for their preferences. One blessed way, argued once.

## Do not import

Markbåge's "use the standard library, write boilerplate instead of taking a dependency" is
2014-JS-ecosystem-shaped — import the surface accounting, not dependency asceticism
(load-bearing libraries earn their surface). The admission gate governs *convenience*
abstractions; invariant-enforcing structure (opaque types, parsers, FKs, sealed ADTs) is
admitted on the bug class it makes unrepresentable — the gate passing, not an exception.
Also under-weighted by the talk: duplication carries its own surface (N almost-identical
blocks must each be read, and diffed against each other, to be understood) — the gate
prices the abstraction side of the ledger, not the duplication side.

**One lattice, two named failure modes — the boundary with `constraints-liberate.md`
(2026-08-15).** Both talks are about wrong abstractions. Model an abstraction by its
semantic extent A (what it admits) against the domain's need D; the failures are
positions in the containment lattice:

- **D ⊊ A — pure oversize (Rúnar).** Everything needed is covered, plus surplus, and
  the surplus is exactly what leaks: every unused capability is a behavior consumers
  can no longer rule out, a law that stops holding, an interpreter that stops
  existing ("the strictly-more-powerful encoding supports strictly fewer
  conclusions"). Cure: restraint — the least-powerful construct that says exactly
  what you mean; audit that nothing stronger snuck in (one HOAS constructor or
  monadic method resizes the whole structure).
- **A, D incomparable — wrong shape (Metz).** Inferred from similarity that was
  coincidence: junk in one direction AND gaps in the other — wrong shape *contains*
  wrong size as a component. The parameter-and-flag graft is the predicted dynamic:
  each graft grows A chasing the gaps while accumulating more junk, monotone growth
  toward a containment it never reaches. Cure: the admission gate, or *prove* the
  shape (laws certified against existing code — reification, parity, a proven
  decomposition — after which the constraint's consumer-side payoff governs).
- **A ⊊ D — undersize.** The cheap failure, by the repair asymmetry: growing A is
  compatible (a small language embeds into a larger one later — detonate-late's own
  observation), while shrinking A breaks consumers, because Hyrum's law makes every
  shipped surplus load-bearing. You cannot put the explosion back in the dynamite.

The asymmetry is the deepest justification for least-power on record: not asceticism
but choosing the recoverable failure mode — err small, because undersize is fixed by
addition, oversize only by breakage, and wrong shape requires both. The bake-off is
the diagnostic procedure for the whole lattice: build the alternatives, prove or fail
to prove the shape, and let the least-fold-like interpreter veto any encoding too
large to support it.

## Evidence

See `../case-studies.md` — Contrapunctus: the `persistence` prop's four-boolean ancestor
(the caller-identity-flag state on an interface), the CLAUDE.md self-review (the canon
cluster violating the accounting rule the day it introduced it).
