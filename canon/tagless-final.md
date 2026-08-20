# Typed Tagless Final Interpreters (Oleg Kiselyov; Carette–Kiselyov–Shan)

**Sources:** SSGIP lecture notes —
https://okmij.org/ftp/tagless-final/course/lecture.pdf; the Böhm–Berarducci page —
https://okmij.org/ftp/tagless-final/course/Boehm-Berarducci.html; Carette/Kiselyov/Shan,
"Finally Tagless, Partially Evaluated" (JFP 2009) —
https://homes.luddy.indiana.edu/ccshan/tagless/jfp.pdf. Cited by URL; nothing archived.

Companion: `data-and-codata.md` (Welsh) generalises this file's initial/final
result to data-versus-codata and adds the derivation strategies — read it for the
choice rule, this one for the interconvertibility proof and its limits.

## The import

The corpus already says make invalid states unrepresentable, one canonical
representation, least-powerful construct, detonate late — and none of them decides the
first question a DSL author actually faces: encode programs as **data** (initial — an
ADT consumed by interpreter functions) or as **functions** (final — a signature of
constructors, a trait/type class, whose instances ARE the interpreters and whose
programs are polymorphic over them). Kiselyov's corpus is that decision procedure.

- **For a fixed signature, expressiveness never decides — the encodings are
  interconvertible.** Böhm–Berarducci: the tagless-final representation of an ordinary
  algebraic data type *is* a form of the BB encoding of that type, so final→initial is
  one more interpreter (reify: instantiate the signature at the ADT's constructors) and
  initial→final is the fold. Any argument of the form "encoding X can't express
  interpreter Y" is wrong; the honest question is *which interpreters are folds and
  which need cleverness*. Bonus: the interconvertibility is directly testable — reify
  the final programs and `assertEquals` against the initial trees — which turns
  "design it twice" into a machine-checked record that the alternative was built.
- **Choose by your least fold-like interpreter.** A final program is its own fold, so
  every compositional (catamorphic) interpreter — evaluate, print, measure — is free in
  either encoding and cannot discriminate. The discriminating workloads are the ones
  that want the whole tree in hand: pattern-matching on structure, joint reasoning
  across siblings (counterexample search), normalization (his `push_neg`). These are
  native on data; on final they need per-transformation context-threading tricks or
  roll/unroll deconstruction, which Kiselyov himself prices: a single deconstruction
  costs time proportional to the size of the value, so repeated non-compositional
  consumption goes quadratic, and "in practice the ad hoc methods … are usually
  preferred." Procedure: before choosing, enumerate the interpreters you will ever
  need — *including* the inspection, search, and transform ones — and take the encoding
  on which the hardest of them is structural recursion. If the hardest one needs the
  tree, final reaches it only by reifying to initial first — becoming the thing it
  avoided.
- **Score the expression problem by who extends.** Final's headline prize — new forms
  without touching existing interpreters — is real exactly when extension crosses a
  team or compilation boundary you do not control. For a closed, single-team DSL it
  scores zero and *inverts*: closedness is the drift guard, because adding a form
  should break every interpreter at compile time. The guard is only real if
  exhaustiveness warnings are errors — as a warning it is a convention, and final's
  missing-method error (definition-site, unconditional) is strictly stronger; escalate
  the warnings before citing the guarantee.
- **Speed is an interpreter, not an encoding.** CKS remove interpretive overhead by
  staging the final interpreter (MetaOCaml) into a residual program with no dispatch.
  The portable shadow of that result: fold the initial data once into a closure tree at
  construction time — final's runtime shape recovered as an optimization pass over the
  data, keeping the data canonical. So never choose final *for performance*; the
  performance is purchasable on either side, and true staging carries a deployment
  constraint (the compiler on the runtime classpath) that many targets — anything
  compiled to JS/WASM — cannot meet. Fold-to-closures is itself conditional, not
  universal: it pays where the program is fixed before its inputs arrive, and buys
  nothing on a one-input traversal, which wants fusion instead — see
  `data-and-codata.md` for the criterion and both paid instances.
- **Inspectability is drawn at the binding line, not the initial/final line.** A final
  program restricted to applicative-shaped operations is exactly as inspectable as a
  free applicative: instantiate at a constant functor and fold. What blinds static
  analysis is metalanguage binding — HOAS and monadic bind embed host-language
  closures, the one-way door out of strict positivity (BB: the encoding applies only to
  strictly positive types, not HOAS) — and it blinds *either* encoding equally. Two
  corollaries. A DSL you intend to inspect must keep function-valued constructor
  arguments out of the data, and that is auditable. And at a genuinely monadic effect
  seam, take final (fine-grained per-capability algebras over `F[_]`, never a
  do-anything capability in business signatures) and drop the inspectability claim
  honestly: Free's "persistable, resumable programs" pitch is false as stated — the
  binds hold closures — and the real defunctionalized resumable program is the intent
  ledger in the database (the ACID-island crossing rule, from the other side).

Net procedure: closed DSL whose value is inspection, derivation, serialization →
initial data as the canonical form, with fold-to-closures as the hot-path interpreter.
Open capability seam whose only interpreters are run-shaped (prod, test, trace) →
final. The initial ADT is also "detonate as late as possible" applied to programs —
the tree is the unexploded form; folding to closures or executing is the detonation,
kept at the boundary where it belongs.

## Do not import

The lectures' motivating enemy — tag overhead and the impossibility of typed DSLs in
GADT-less Hindley–Milner, circa 2007–2010 — is largely gone: Scala 3 and modern Haskell
have GADTs, so the headline pitch solves a metalanguage deficiency you probably do not
have, and "tags are the problem" is not vocabulary worth carrying. The
expression-problem framing as an unconditional good inverts for closed DSLs (above) —
do not cite extensibility that no one will ever exercise. And the papers underplay a
recurring ergonomic tax the pitch conceals: *storing* a final program (a registry, a
table of rules) means storing a higher-rank polymorphic value, ceremony paid at every
storage site, where storing data is just storing data.

Two non-conflicts, recorded so they are not relitigated: final does not contradict "one
canonical representation" (a program with no representation at all looks like the
opposite of a canonical one) — interconvertibility means you designate the canonical
form and derive the other, and reification keeps the final side honest. And Kiselyov is
not the loser of his own digest: the quadratic-deconstruction caveat and the
bespoke-per-transformation admission are *his* stated limits, which is why this source
digests into a two-sided procedure instead of an advocacy piece.

## Evidence

See `../case-studies.md` — Contrapunctus 2026-08 (the rule-DSL bake-off,
`docs/design/rule-dsl-bakeoff.md` in that repo): the reification test proving
interconvertibility structurally; counterexample generation as the discriminating
least-fold-like workload (reachable in final only via reify); the expression-problem
prize scoring zero for the closed rule DSL, with exhaustiveness escalated to errors as
the landed drift guard; compiled-initial measured fastest of everything including the
hand-written production code (2.72 ms vs 7.22 ms), with true staging unavailable on the
Scala.js/WASM target; and the effect-seam verdict (per-capability final algebras +
intent ledger, not Free).
