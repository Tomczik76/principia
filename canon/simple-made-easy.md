# Simple Made Easy (Rich Hickey)

**Source:** Strange Loop 2011. Transcript: matthiasn/talk-transcripts repo
(`Hickey_Rich/SimpleMadeEasy.md`).

## The import

*Complecting* is the name for the parallel-representations defect class. *Simple* means
unentangled — one concern per artifact, a property of the thing itself and so objectively
checkable. *Easy* means near to hand — familiar, short, matches the neighbors, already in
your fingers — a property of the reader and so subjective. When arguing for or against an
approach, say which axis you are on. "This complects the wire shape with the render shape"
is a claim about the artifact and it decides the question. "This is unfamiliar / longer /
adds a file" is a claim about proximity and it does not decide anything on its own. The
default pull is always toward easy — shortest diff, fewest new files, looks like its
neighbors — so naming the axis is the cheapest available correction.

Separating two concerns usually produces MORE files, and that is the intended outcome
rather than a cost to apologize for: DRY is about one *fact* in one place, not one
*concern* per file, and the two point opposite ways when a shared helper serves callers
that are entangled for different reasons.

Two corollaries, both measured rather than imported (see case studies):

- **State the tradeoff, not only the benefit.** Hickey's line is that programmers know the
  benefits of everything and the tradeoffs of nothing, and an adversarial audit measured
  exactly that asymmetry: every false finding overstated reach; none understated. The
  measurement rule fixes the bias for *claims*; this fixes it for *proposals*. An approach
  put forward with only its upside named is as incomplete as a reach claim with no printed
  count.
- **Guardrails do not tell you which way to go.** A passing suite says nothing broke; it
  never says the shape is right. Thousands of green tests cannot see that a value never
  arrived when the tests guard hops and the *design* is the hop chain. Reach for a
  structural fix when the failure is structural; more tests around a tangle measure the
  tangle.

## Do not import

The talk's construct table is Clojure-shaped, and at least two rows are wrong for typed-FP
codebases: it treats pattern matching as complecting decisions into one closed location,
but exhaustive matching over a sealed ADT is precisely the mechanism behind "make invalid
states unrepresentable"; and its skepticism of types does not survive contact with
deriving wire types from schemas (`typeof Schema.Type`) instead of hand-writing twins.
Take the simple/easy distinction and the two corollaries; leave the prescriptions.

## Agent-era note

The *easy* axis is literally the token-probability gradient: an LLM's sampling is the pull
toward familiar-shortest-matches-the-neighbors, automated and run at scale. Naming the
axis matters more with agents, not less. See `../agent-era.md`.

## Evidence

See `../case-studies.md` — Contrapunctus: the beats/voices duality, the score-document hop
chain, the audit-bias measurement, the bar-map episode.
