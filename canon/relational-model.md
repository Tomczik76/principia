# The Relational Model and the Five Normal Forms (Codd + Kent)

**Sources:** E. F. Codd, "A Relational Model of Data for Large Shared Data Banks" (CACM
13(6), June 1970, 377–387; DOI 10.1145/362384.362685) and William Kent, "A Simple Guide
to Five Normal Forms in Relational Database Theory" (CACM 26(2), Feb. 1983, 120–125;
author's copy at bkent.net/Doc/simple5.htm). Both archived in `transcripts/`, untracked.
Queued as a pair on the expectation that Kent would carry the normal forms and Codd the
model underneath them. The expectation was half wrong, and the correction is this digest:
**the import section is entirely Codd's, none of it is a normal form, and Kent's five
forms yielded zero importable bullets.** Jurisdiction: `core.md`'s "normalize by default;
denormalize against a number" was admitted *before* this digest, on paid evidence, not on
these papers' authority — so this file is that rule's depth, not its ground, and it adds
no core line.

## The import

The normal forms themselves were measured and rejected as restatement (METHOD rule 2 —
the measurement is in "What Kent's five forms actually say" below). What survived is two
claims from the parts of Codd 1970 that have nothing to do with normalization, and both
are paid.

- **Name the role, or the relation cannot state its fact.** Codd §1.3: where two or more
  domains of the same type occur in one relation, each occurrence must be qualified by "a
  distinctive role name" — his case is `component(sub.part, super.part, quantity)`, which
  he says is central to the parts-explosion problem — and he makes the inability to say
  this an *expressiveness* failure of the systems of his day, not a tidiness complaint.
  The recognizer for a schema: a table with two participants of the same kind, one of
  which is nameless. **The tell is that the guard you need cannot be written** — every
  uniqueness key expressible over the columns you have also forbids something legal. This
  is not a normal form and no normal form reaches it: a table can satisfy all five and
  still be unable to state its fact, because the missing thing is an attribute, not a
  decomposition. Census, taken before this file existed: `role` occurred 2 times in the
  tracked corpus, neither in this sense — a table header in `README.md`, a Hickey
  quotation in `canon/value-of-values.md`.
  → *paid by `point_events.actor_id`; see the ledger.*
- **A copy you cannot rebuild was never a copy.** Codd §1.2.2 classes an index as "purely
  performance-oriented," informationally redundant, and then turns that into a test: can
  application programs "remain invariant as indices come and go"? He names the failure
  mode in the same breath — IDS made programs refer to indexing chains by name, and those
  programs stopped working when the chains were removed. Extended to any derived store,
  the test is destruction: **drop it and rebuild it from its source.** If you cannot, it
  holds information nothing else holds and it is the system of record, promoted without
  anyone deciding. The extension is this corpus's inference, not Codd's sentence; the
  direction is his — §2.2.1's strong redundancy is "characterized by an equation" and is
  the administrator's lever, while §2.2.2's weak redundancy is inherent in the users'
  logical needs and removable by nobody. Census before this file: `droppab` 0 hits,
  `rebuild|reconstruct` 6, none about a stored copy's source. This is the mechanism
  `core.md`'s denormalization clause was missing — it named a generated column and a
  `CHECK`, and the corpus's own best example uses neither: it recomputes from a live
  ledger.
  → *paid by `users.total_points` against `student_lesson_work.best_score`.*

**IOU (printed in the ledger): the connection trap.** Codd §2.1.4: following the paths
supplier → parts → projects and concluding you have the projects that supplier supplies
is "in general, erroneous" — correct only if the target relation *is* the natural
composition of the two traversed ones, and he adds that the phrase "for all time" is
normally implied in claims made for path-following. Reachability is not a relation.
Modern instances are everywhere the traversal is cheap: `user.team.projects` answering
"projects this user may open," a nested resolver answering a question no edge in the
graph states. Census before this file: 0 hits, and no existing rule yields
it. Admitted on source authority only, with no anchor in any project here yet.

## What Kent's five forms actually say, and why none of it entered

The QUEUE entry commissioned depth rather than admission — which anomaly each form
removes, when 4NF/5NF bite, what a decomposition costs a read path. In one paragraph:
**1NF** is shape, not design — every record has the same fields — and Kent says so
himself, "not so much a design guideline as a matter of definition." **2NF and 3NF** are
one rule with two cases, and Kent's slogan is the whole procedure: a non-key field must
state a fact about the key, the whole key (2NF — violated when it is a fact about part of
a composite key), and nothing but the key (3NF — violated when it is a fact about another
non-key field). The anomalies are four, and the corpus already carries three of them: the
value repeats, an edit must touch many rows, the copies can disagree — and the fourth, the
one the corpus's drift-shaped rules do not name, is that *the fact has nowhere to live*
when the row it rode on is absent (a department with no employees has no record to keep
its location in). **4NF** forbids two independent multi-valued facts in one record, and
its argument is not redundancy but that the maintenance policy becomes undetermined —
disjoint rows, mixed rows with repeats, mixed rows with nulls, or the full cross-product
are all defensible, and a blank field stops having one meaning. Its independence test
quantifies over *pairings*: pairings carry information only if some of them can be absent,
so if every combination must always be present there is nothing in the pairing and the
record splits. **5NF** is the cyclic case — Kent's agents/companies/products — and applies
only where a symmetric constraint holds; absent one, a 4NF record is already in 5NF. Its
payoff is the growth curve, and it is the one quantitative argument in the paper: adding
an agent selling x products for y companies costs x+y rows normalized and xy
unnormalized. **The retrieval cost** Kent states but never prices: the normalized design
makes the application "search two record types, and connect the appropriate pairs," and he
defers the threshold three separate times.

None of this entered `core.md` because each lands on held ground — the key test and three
of the four anomalies on the canonical-representation and normalize-by-default rules, the
blank-field ambiguity on the state-counting procedure in make-invalid-states-
unrepresentable, 4NF's independence test on that same counting procedure, and the closing
five-factor design checklist on rules already in *Arguing about designs*. Six candidate
imports went to adversarial review on three lenses (does the source say it, is it already
in the corpus, is it a procedure); all six were refuted, three of them on all three
lenses. `check-budget.sh` reported 166/166 lines and 1976/1976 words at the time — zero
headroom — and nothing here outweighed what it would have displaced.

## Do not import

- **The attribution boundary, and the dead motive behind it.** Codd 1970 contains exactly
  one normal form — every domain simple — and justifies it *representationally*: all-simple
  relations fit a two-dimensional array, a nonsimple one needs "some more complicated data
  structure." He then closes the door explicitly, saying further normalizing operations are
  not discussed in the paper. 2NF/3NF are Codd 1971/1972, 4NF is Fagin 1977, 5NF is Fagin
  1979 — by Kent's own reference list. The part that matters for design: the 1970 motive is
  a claim about 1970 storage engines and it is dead. A reader who imports "1NF forbids
  JSONB" is importing an array-layout constraint dressed as a design rule. The live
  question about a nested column is never its shape; it is whether anything reaches inside
  it. Measured on this corpus's own anchor project: 0 JSON path operators in the entire
  Scala application layer, and 6 of 70 migrations reaching inside a JSON column — the
  nesting is free where the value is read and written whole, and is paid for only by the
  data fixes, which must hand-write positional paths.
- **Codd's consistency regime — a non-conflict with a stated boundary.** §2.3 offers two
  responses to a detected inconsistency: check on every insertion, deletion or key update,
  which "will slow these operations down," log it internally and notify a human only if it
  is not remedied within some reasonable interval; or batch-check against a journal of
  state-changing transactions. **Neither rejects the write.** That is eventual detection
  with a grace window and a human adjudicator, which is precisely the compensating-filter
  posture `core.md` refuses — so it looks like a conflict and is not one. The partition is
  satisfiability at the instant of the write: Codd's window is scoped to cross-relation
  invariants no single write can satisfy, where the legal edit passes through inconsistent
  states by construction; core's rule is scoped to invariants a constraint can express, and
  where Codd has one of those he puts it in the schema too (§1.5's declared deletion and
  update dependencies are the seed of `ON DELETE CASCADE`).
- **Neither paper licenses "more tables."** The likeliest wrong import for anyone who has
  read a normalization tutorial. Kent's default in the 5NF case is *not* to decompose — the
  three-field record "is necessary in the general case," because his agent sells Ford cars
  and GM trucks but neither Ford trucks nor GM cars. 4NF never splits on shape alone: where
  the pairings are meaningful, a single record is acceptable and he says so. And
  normalization is not the design process — the initial set of data elements "has to be
  developed, as candidates for normalization" first, and that step is out of scope.
- **"Codd rejected introspection" is backwards.** The abstract's line about a prompting
  service is scoped by the sentence before it to how the data is organized *in the
  machine*. One page later he proposes the logical-schema version himself: relation and
  domain names offered in menu style by the system on request. An agent reading the schema
  is the endorsed case; an agent coding against the storage layout is the rejected one.
- **Nobody prices a join.** Kent gives one query's cost as an illustration, never as a
  metric, and defers the threshold three times. Codd never prices a join at all; §1.6's
  line about representations "just adequate to cover the spectrum of performance
  requirements" is advice to DBMS implementers about what a product should ship, and the
  same paragraph pushes the other way — as sharing grows, responsibility shifts from the
  user to the data system. Do not let that sentence be cited for a schema decision.

## The sources' own tradeoffs

Kent states his own bias in the second paragraph of the paper, and it is the best thing in
it: the rules "are designed to prevent update anomalies and data inconsistencies," they are
biased toward assuming all non-key fields are updated frequently, they "tend to penalize
retrieval," and **there is no obligation to fully normalize when actual performance
requirements are taken into account.** That is `core.md`'s normalize-by-default rule with
its exit clause, written in 1983 — but it is the source's authority arriving after the
fact, not the ground the rule entered on, and Kent supplies no threshold anywhere in the
paper. Three further self-limits he prints and a reader must keep: the forms address
redundancy *within a single record type only*, so `EMPLOYEE-LOCATION` beside
`EMPLOYEE-DEPARTMENT` and `DEPARTMENT-LOCATION` is third-normal-form-clean, and two
identical copies of one record type pass every test in the paper — which is exactly the
inter-record, inter-layer drift this corpus actually pays for; the forms are only *defined*
where identifiers are unique and singular, so his own FATHER'S-ADDRESS table has no
functional dependency at all while suffering every anomaly one would cause; and some
redundancy is simply unavoidable once multi-valued facts are dependent rather than
independent. Codd's limits are structural: his §2 machinery presumes a system that accepts
a declared set of constraint statements and checks them, which no mainstream DBMS ever
shipped in that generality, so the half of his design that carries the redundancies you
keep has no implementation to lean on. And his own hedge is worth keeping over his stronger
sentence — a system cannot deduce the redundancies without semantic information, and
attempts to induce them from data over time "would be fallible." Fallible, not impossible.

## Agent-era note

The two imports are both mechanism-shaped, which is why they survived a corpus that prices
rules by what they cost to remember.

Codd's argument for role names is explicitly about working memory — degree-30 relations are
ordinary and users "should not normally be burdened with remembering the domain ordering."
Under `agent-era.md`'s pricing that stops being a metaphor and becomes metered: a column
named `user_id` in a table with two user participants costs *every* session the work of
re-deriving which participant it is, from zero, forever. A name is the cheapest enforcing
mechanism in the corpus — rename to `recipient` and `actor` and the wrong reading stops
being sayable — and it is METHOD's retire-prose-into-a-mechanism move executed on an
identifier. The anchor project finished that move on its own: `PointsService.actorKey`
carries a doc comment stating both failure directions, and the next migration reasons from
it.

The rebuild test lands on the other agent-era weakness. `agent-era.md` says agents are
worst at facts of the form "a twin of this exists elsewhere," because that is exactly what
no session inherits. "The ledger this column was derived from stopped being written eight
migrations ago" is that fact, and nobody re-examined it when a later migration added the
aggregate. The mechanism is one line and it is greppable: **every derived column carries
the query that rebuilds it, or a comment saying it cannot be rebuilt and is therefore the
system of record.**

Third, Codd's inducer is uncanny read in 2026. A system without semantic information
"might, over a period of time, make attempts to induce the redundancies," and those
attempts would be fallible. An agent handed a schema and a page of rows is that inducer —
and unlike Codd's system it reports the induced law in confident prose with no hedge. This
repo has the measurement: a uniform-meter law induced from the sample on hand, wrong on 9
of 32 shipped scores. Codd's prescription — the invariant is *declared* by whoever holds
the semantics — is now a rule about who is allowed to author the schema comment.

## Evidence

See `../case-studies.md` — Contrapunctus: **the nameless actor** (`point_events` recorded
recipient and subject but not the voter, so "an award had no identity" and the only
idempotency guard the schema admitted "would also have blocked the second legitimate
voter"; the migration that adds `actor_id` states Codd's
condition in its own words, and a later one restates it to conclude three columns suffice
where the recipient *is* the actor); **the two caches** (`users.total_points` recomputed
from a live ledger on every write, therefore droppable and self-healing, against
`student_lesson_work.best_score` and `attempt_count`, maintained by `GREATEST` and `+ 1`
over a ledger whose writer has zero production callers — same column shape, opposite
repairability); **the key-change duality** (a transitional second spelling still open
after 16 migrations); and **the double award** (whose ledger entry this digest corrected).

One observation about the anchor project worth recording, because it is what made the
evidence good: its schema discipline is not uniform in time. The early migrations
denormalize without argument; the recent ones argue schema design at essay length and
refuse a second spelling *by name*, citing the earlier migrations' defects as precedent.
The same repo therefore contains both the defect and the migration that names it — which
is why this digest could be paid rather than owed.
