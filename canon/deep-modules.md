# Deep Modules (John Ousterhout)

**Source:** *A Philosophy of Software Design* (book); "A Philosophy of Software Design,"
Talks at Google 2018 (transcript archived locally in `transcripts/`, untracked).

## The import

The interface-width criterion — a generative test for whether a layer should exist at all.
A module's worth is functionality per unit of interface, where *interface* means
everything a caller must hold in mind to use the thing (side effects, dependencies,
ordering constraints), not just the signatures. A *deep* module hides substantial
implementation behind a small interface; a *shallow* one's interface roughly restates its
implementation, adding interface complexity while absorbing none. His layering form of the
same rule: a small number of meaty layers beats many skinny ones. A forwarding hop whose
interface re-lists every field it passes is shallow by definition — it hides nothing, so
it is not earning its existence. That upgrades "audit the hop chain" to a refusal: don't
build a layer that cannot state what it hides.

His three symptoms of complexity give design arguments their measurable vocabulary:
*change amplification* (one change, many sites — see the hop-chain case study for a
printed instance), *cognitive load*, and *unknown unknowns*. When arguing about a design,
reach for the countable one.

- **Pull complexity downward — unless the caller owns the decision.** The module should
  absorb the gnarly part and hand callers a computed default; a configuration parameter is
  complexity pushed upward. Amendment earned in production (see case studies): when the
  module cannot know the right answer, a required parameter beats a wrong default. Pull
  complexity down when the module can genuinely decide; force the caller to state what
  only the caller knows.
- **Define errors out of existence.** Redesign the operation so the failure case is not
  semantically necessary (Unix deletes a file that is still open; Tcl unsets a nonexistent
  variable without complaint; substring clips to the available range). The API-design
  sibling of parse-don't-validate: King refines the *input* so the interior cannot fail;
  this redefines the *operation* so there was nothing to fail about. The boundary of the
  principle is the contract: redefine when the case can be given meaningful semantics
  (unset means "make it not exist" — for a missing variable that is already true); when
  the contract is fundamentally unfulfillable (`charAt` out of range, an I/O error on
  read), the failure must surface — his own students over-applied this by writing zero
  handlers. Corollary for the errors that remain: an exception earns its keep in
  proportion to how far it propagates — caught adjacent to the throw, it is a clunky
  return value. Typed error channels that ride failures untouched to the one boundary
  that can act are this corollary implemented.
- **Make it slightly general-purpose, even with one caller.** A design opinion he reports
  teaching the course changed for him: designing the interface for what the mechanism does,
  rather than for the one current caller's quirks, makes a class simpler *and* deeper.
  Rúnar's take-`List[A]` rule is the type-parameter special case.
- **Design it twice** (book; not in the archived talk). For any significant design,
  sketch two genuinely different decompositions before committing — you cannot state the
  tradeoff of an alternative you never generated. His companion ideal for changes to
  *existing* code (this one is in the talk): aim for where you would have ended up had
  you built it from scratch, knowing what you know now.
- **Classitis is the shallow-module failure at scale** — many tiny classes and methods,
  each contributing interface. Length is not the issue; depth is. He has no problem with a
  hundreds-of-lines method behind a deep interface.

## Do not import / non-conflicts

His anti-TDD position targets unit-level test-first, where the first testable increment
drags the interface design along with it. It does not touch a red-e2e-first discipline for
value-threading changes — an end-to-end check pins behavior at the system boundary and
exerts zero design pressure on the interfaces beneath it, which is exactly why it can stay
red across a whole staged migration without constraining the design. (His own "test the
seam" instinct — call the production entry point — agrees from the other side.) His
comment doctrine (interface comments for every abstraction) goes further than a
constraint-comments-only house style; take only his agreement that a comment must never
restate the code.

## Evidence

See `../case-studies.md` — Contrapunctus: the score-document hop chain (printed change
amplification), the required non-defaulted `persistence` prop (the
caller-owns-the-decision amendment).
