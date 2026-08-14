# The ACID Island (after John De Goes)

**Source:** "Distributed Systems Wizardry," LambdaConf (transcript archived locally in
`transcripts/`, untracked). Only the front half
is imported — the back half is a product pitch (Golem, durable execution) and stays out;
his own caveat supports the cut — asked how durable execution solves the distributed
state problem, his answer is "It doesn't"; it solves recovery.

## The import

A system is centralized while its whole state can be updated atomically and consistently;
it becomes distributed the moment one call mutates state the transaction cannot reach.
The sharpening that makes the test bite: **every external API call IS a state mutation
somewhere** — "charge the card" is a write to someone else's database, not an action.
Stateless logic plus one ACID store is still effectively centralized; add one stateful
external API and you have crossed.

Consequences:

- **Effectively-centralized is an asset to preserve, not an accident.** One database
  owning every invariant is what makes constraints, transactional enforcement, and
  make-broken-data-unreachable rules possible at all. Prefer designs that stay inside the
  island.
- **A crossing is a design-time commitment, not a runtime surprise.** The process can die
  between the DB write and the external effect, so the transaction records intent first,
  and the seam gets one of three shapes — an idempotency key, a ledger row, or
  persist-result-then-process. These are the same solution wearing three coats. A new
  external stateful call without one of them is a distributed-state bug queued, not
  avoided.
- **Locks don't compose across a network**, and a failure cannot be distinguished from a
  partition. This is why the crossing discipline is ledgers-and-idempotency rather than
  coordination: the ambition to make the crossing atomic is the consensus problem, and you
  do not want to be solving the consensus problem in application code.

## Queue note

This distillate is deliberately small. The deeper treatment of the same territory is
queued (see `../QUEUE.md`): Helland's "Life Beyond Distributed Transactions" generalizes
the crossing discipline into a design method (entities, at-most-once messaging,
idempotency as a first-class input), and Kleppmann/Bailis cover the gap this file does not
address — two *concurrent* transactions racing inside the island under weak isolation.

## Evidence

See `../case-studies.md` — Contrapunctus: the `stripe_events` webhook-idempotency ledger,
the Bedrock raw-response persist-before-parse, the SES webhook topic-pin + fail-closed —
three crossings, three coats of the same solution.
