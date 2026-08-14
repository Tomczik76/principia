# Agent-era pricing

The canon predates coding agents. The rules survive; their justifications migrate. This
file is the original position of this repo — not a digest of anyone's talk — on how
classic design principles reprice when most code is written and rewritten by LLM agents.
The stress test that prompted it: "the wrong abstraction isn't nearly as costly when a
coding agent can rewrite your whole codebase in less than a day."

## What genuinely got cheap

Three costs collapsed. The **repair cost** of a wrong abstraction — Metz's whole pricing
model assumed weeks of human unwinding; an agent re-inlines and re-extracts across a
codebase in an afternoon. The **sunk-cost psychology** — an agent told to back out does it
without ego. And **alternative generation** — "design it twice" assumed sketching a second
decomposition was expensive; it is now nearly free, so the rule is under-ambitious:
generate five, judge them. Consequence: the Metz exit stops being a dreaded project and
becomes routine maintenance you can schedule.

## The two costs that didn't drop — and now dominate

**Verification.** "Rewrite the codebase in a day" is true for *producing* the rewrite.
Certifying it is the cost, and it is bounded by exactly what the canon builds: seams you
can test, types that machine-check invariants, parsers that carry proof, end-to-end
arbiters at the system boundary. A tangle with no oracle can be rewritten in a day and
certified never. The claim inverts: **the wrong abstraction is cheap to fix only in
codebases built as if it were expensive.** The verification infrastructure that makes
agent rewrites safe is downstream of following these rules, not a reason to drop them.

**Context economics.** Ousterhout's "interface = everything a caller must hold in mind"
was a metaphor about human working memory. For agents it is literal and metered: module
boundaries are context-window boundaries, and interface width is measured in tokens.
Markbåge's surface accounting gets *worse* in the agent era: humans amortize learning a
bespoke abstraction over years; an agent re-learns it every session from zero. A helper
that exists in the model's training distribution (standard library, common pattern) costs
nothing; the idiosyncratic one costs context in every session that touches it, forever.
"Write boilerplate, use the standard" is more correct for agents than it ever was for
humans — and explicit code is what agents transform reliably (they are universal
codemods), while implicit magic is what they break.

## The empirical kicker

The defects in `case-studies.md` that motivate these rules were committed *by agents* —
see the hop-chain, audit-bias, and diverged-siblings entries in the ledger. The
structural reason: agents have no cross-session memory, so anything that requires knowing
"a twin of this exists elsewhere" — sync functions, hop lists, fact duplication — is
precisely what they are worst at.

Hence the sharpest repricing: **tolerance for *pattern* duplication rises** (agents
regenerate patterns cheaply, and periodic sweeps can unwind tangles), while **tolerance
for *fact* duplication falls further** (keeping two copies aligned requires exactly the
cross-session memory agents lack). The fact/pattern admission gate is not weakened by the
agent era; it is the agent era's central rule.

One more inversion: Hickey's *easy* axis — familiar, matches the neighbors, shortest
diff — is literally the token-probability gradient. An LLM's sampling IS the easy axis,
automated and run at scale. The default pull he warned about is no longer a human
temptation; it is the physics of the tool. An instructions file's entire function is to
be the counterweight: to make the simple path the easy path by putting it in context.

## Operational consequences

- Every rule that produces **oracles** (types, parsers, baselines, e2e arbiters) outranks
  every rule that produces elegance. Verification is the bottleneck.
- **Prefer properties over examples for agent-written code.** Hughes's warning that
  implementation misconceptions replicate into test code (`canon/how-to-specify-it.md`)
  becomes automatic when one model writes both sides; a property plus a generator
  decorrelates verification from generation.
- **Schedule the Metz exit.** Wrong abstractions are no longer permanent debt; an agent
  pass can re-inline and re-derive. Tangle-unwinding is maintenance, not archaeology.
- **Design it N times** with a judge, not twice by hand.
- **Instructions files are code.** They drift like code (dead identifiers, stale claims,
  duplicated facts that diverge) and deserve adversarial review like code. A prose rule
  an agent must remember is a compensating filter; where possible, move it into a hook,
  a type, a constraint — the layer that owns it — and let the prose shrink to one line
  naming the mechanism.
