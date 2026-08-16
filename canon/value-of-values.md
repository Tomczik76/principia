# The Value of Values (Rich Hickey)

**Source:** JaxConf 2012 — https://www.youtube.com/watch?v=-6BsiVyC1kM. Transcript:
matthiasn/talk-transcripts (`Hickey_Rich/ValueOfValues-mostly-text.md`), archived locally
in `transcripts/` (untracked). Same author as `simple-made-easy.md`, and the two barely
overlap: that talk asks whether concerns are entangled *inside* an artifact; this one asks
whether the artifact destroys its own past.

**Reopening note.** `QUEUE.md` had this rejected as redundant — "covered by core's
least-power/immutability defaults." Measured against the corpus: `immutab` occurs zero
times in `core.md`, and exactly once in the whole tracked repo — in that rejection
sentence. The rejection was written from memory of the talk instead of the transcript,
which is the failure METHOD rule 1 exists to prevent, and it asserted reach without
printing a count, which is the failure the measurement rule exists to prevent. The
companion rejection (*Hammock Driven Development*) stands; only this half is reopened.

## The import

- **The PLOP detector: any time new information replaces old, you are doing
  place-oriented programming.** This is the payload — a one-line, mechanically checkable
  trigger for a defect class the corpus otherwise has no rule for. *Place* is a delimited
  portion of space with an address (a memory cell, a disk sector, a row); place-oriented
  programming is building information models out of them, so an update destroys its
  predecessor. The corpus already reasons hard about *whether the current state is legal*
  — foreign keys, CHECK constraints, one canonical representation — and says nothing about
  whether the prior state survived the write. It usually does not, and nothing downstream
  can recover it: no type, no test, no log. The rationale for PLOP was real (four kilowords
  of memory; disks measured in megabytes) and it is gone — capacity moved by six orders of
  magnitude while the encoding decisions it forced did not.
- **Facts are values, because a fact incorporates time.** The apparent counterexample —
  "but facts change, we get a new president" — dissolves: *fact* is `factum`, something
  done, and you can no more update one than change the past. A new president is a new fact,
  not a mutation of the old one. The operative consequence is the distinction between a
  **fact log** and a **current-state store**: the second is a projection of the first, and
  a system that keeps only the second cannot answer any question whose answer needs two
  time points. Since decision support is almost entirely comparison across time — trends,
  rates, deltas, aggregates — a store of most-recent-facts-only is structurally unable to
  do the job the system was built for.
- **Values aggregate to values; the policies that make places safe do not.** The sharpest
  compositional argument in the talk, and it upgrades a rule the corpus already has. Give
  a mutable class a locking policy and a cloning policy — real work, often recorded
  nowhere better than a napkin — then compose two such classes. The composite inherits
  neither policy; both must be redesigned from scratch at every level of nesting.
  Immutability is the opposite: an aggregate of values is a value, and every property
  (shareable without coordination, comparable, storable, conveyable) survives composition
  for free. In `deep-modules.md`'s terms, a locking protocol is *interface* — something
  every caller must hold in mind — and it is precisely the part of the interface that
  evaporates when you compose. In `composing-programs.md`'s terms, immutability is
  compositional and a mutation protocol is merely composable-if-you-twist-its-arm.
- **Perception costs coordination; a value costs none.** To observe several places
  consistently you must stop the world — that is what a read transaction *is*, and it is
  why nobody likes them. To observe a value you just look at it, as long as you like.
  This is the read-side complement to the ACID-island crossing rule (`core.md`; write-side
  crossings, grounded via `feral-concurrency-control.md`); and it is the mechanism behind
  "values make the best interfaces," which the
  industry already concedes in the large (CORBA and DCOM died; JSON and XML are value
  representations) while continuing to pass references in the small. The same property
  buys **location flexibility**: components that exchange values can be moved across a
  thread, a process, a language, or a machine, because nothing in the contract was a
  pointer into one address space. Components that exchange interfaces cannot.
- **Fabrication cost is the hidden precondition of property-based testing.** Values are
  trivially fabricable in any language — a number, a list of them, a map of lists — which
  is what makes programs that write programs, and programs that write *tests*, tractable.
  You cannot cheaply fabricate an instance of someone's interface. This is the missing
  precondition on `how-to-specify-it.md`'s "prefer properties where structure exists":
  properties are cheap exactly to the degree the domain under test is made of values, and
  a generator for a place-shaped API is mostly setup code that reconstructs a world. It
  also states the failure directly — a test over places is conditional on your ability to
  restore the place, so it certifies the fixture as much as the code.
- **The programmer-IT asymmetry is a reusable argument form.** Hickey's proof that we
  already believe all of this: our own two information systems are source control and
  logs, and neither updates in place, and both timestamp everything, and nobody would
  tolerate otherwise for a day. We ship our users the database that remembers only the
  last thing we told it. The generalized form is worth keeping as an audit move: **when a
  discipline you insist on for your own tooling is one you refuse to your users' data,
  the asymmetry is the finding.** It needs no external authority to make the case.

## Non-conflicts that look like conflicts

- **Accretion vs. "one canonical representation; derive the rest."** These read as
  opposites — accretion means many rows about one entity — and they are not. The fact log
  *is* the canonical representation; the current-state row is the derived one. The corpus
  rule already supplies the missing direction: derive the projection from the log, never
  sync the two by hand, because a hand-maintained current-state table beside an event
  table is the beats/voices duality with a new schema.
- **Accretion vs. the ACID island.** Recording intent before a crossing, persisting a
  Bedrock response raw before parsing it, writing a `stripe_events` row before acting —
  the corpus arrived at fact-first storage three times from the crossing side without ever
  naming the principle. They are the same move.

## Do not import

- **"Values are semantically transparent" as an argument against encapsulation.** The talk
  says a value's job is to expose itself for comparison, not to hide behind methods. Taken
  literally this deletes the corpus's central invariant mechanism — opaque types with
  smart constructors (`Pitch` as an opaque `Long`, `Pulse.Atom(NonEmptyList[A])`). The
  resolution is that Hickey is arguing against *place*-hiding, not against
  *construction*-hiding: a smart constructor restricts who may **make** a value, never who
  may **read** it, so transparency of content and opacity of construction compose fine.
  Import the transparency claim about content; do not let it reach constructors.
- **The cost-of-specificity argument, and the anti-type turn inside it.** "Every new idea
  gets a new class," code explosion, more code equals more bugs, and typed languages
  deliver less reuse — this is the talk's weakest stretch, and it collides head-on with
  parse-don't-validate and make-invalid-states-unrepresentable. His preferred encodings
  (a map of lists of numbers) are the record-of-optionals-plus-a-prose-rule smell at
  maximum strength: maximally general, maximally reusable, and admitting every state the
  domain forbids. The corpus's counterposition is that a new type is not new *knowledge*
  — it is the same knowledge relocated from prose into a checked position — so it does not
  pay the duplication cost the argument assumes. Note that Hickey's own reuse premise
  fails on its terms too: a generic map is reused by being re-interpreted at each site,
  which is the caller-identity flag wearing a different hat.
- **"Place has no role at all in an information model," absolutized.** Read as *never
  maintain a constrained current-state store*, this trades away the ACID island: foreign
  keys, `CHECK` constraints, uniqueness, and one-transaction enforcement all live on the
  place side, and they are what makes broken data unreachable rather than merely handled.
  Keep both — accrete the facts, project a constrained current view — and note the talk
  gives no account of enforcing an invariant over an append-only log, which is genuinely
  harder than a constraint on a row.
- **The economics of "you can afford this."** The talk prices accretion as storage and
  waves at garbage collection. Three costs it does not carry: query and index cost on
  accreted history grows superlinearly against the retention window; a history of personal
  facts is a **liability**, and the 2012 framing predates GDPR/CCPA erasure rights, which
  make "never delete" a legal position rather than a technical one; and someone must
  decide which facts are worth keeping forever, which is design work the talk assigns to
  nobody. Accrete deliberately per fact class, not by default across the schema.

## Agent-era note

Two repricings, opposite in sign.

The import gets **stronger**. Agents overwrite; they have no cross-session memory
(`agent-era.md`), so the prior state of anything they touch survives only if the substrate
kept it. The reason agent-written code is survivable at all is that source control is not
place-oriented — Hickey's own programmer-IT slide, now load-bearing for a workflow he
did not anticipate. The unhandled case is every store an agent writes that *is*
place-oriented: an overwritten config, a clobbered save, a regenerated file. Where an
agent can destroy a fact, accretion is the substitute for the memory it lacks.

The do-not-import gets **stronger too**. "More code equals more bugs" assumed a human
writing each class; agents make the writing nearly free, which shifts the whole cost to
verification — and `agent-era.md`'s standing ruling is that rules producing oracles
outrank rules producing elegance. Types are oracles. A generic map is not. The specificity
argument loses harder in 2026 than it did in 2012.

## Admission status

Nothing from this digest enters `core.md` yet, on two independent grounds. **No anchor:**
METHOD rule 3 requires a paid-for defect, and the ledger's nearest entries (the three
crossings, the clobbered sandbox save) are already spent on other rules — reusing them
here would be the reach overstatement this repo measures in others. **No displacement:**
the core budget requires ejecting a line, and no current line is weaker than the candidate.

The candidate, recorded so a future session need not re-derive it:

> **Ask what an update destroys.** When a write replaces a fact — a thing that happened —
> the prior value leaves the system and no type, test, or log recovers it. Accrete the
> fact, project the current view. Place-orientation is free only where the past has no
> decision value.

Admit it when a project pays for the loss of a fact it needed a second time point to
answer. Until then the rule lives here and the debt is printed in the ledger's IOU list.

## Evidence

None yet — see the IOU entries in `../case-studies.md`. The nearest paid-for material
(`stripe_events`, Bedrock persist-before-parse, the clobbered sandbox save) evidences the
ACID-island and explicit/implicit rules and is not re-spent here.
