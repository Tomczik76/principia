# Case studies — the evidence ledger

Earned anchors, per project. This file is why the canon is not a quote collection: every
rule in `core.md` should trace to at least one entry here that a real project paid for.
When a new project adopts the canon, its paid-for defects get contributed back here —
evidence compounds across projects instead of resetting per repo. Entries are terse: the
story in two or three sentences, the principle it evidences, where the full record lives.

## Contrapunctus (music-theory education platform; Scala 3 + React/TS; 2026)

- **The bar-map day (2026-08-04).** A migration was staged behind an inertness property —
  the new code provably computed exactly what it replaced — so 2,137 green tests could not
  tell whether the real value ever ARRIVED anywhere. It hadn't: built correctly, persisted
  correctly, never reached the renderer, while a test asserted success because it built
  its own copy and measured that. The safety mechanism and the blindness were the same
  fact. → *red-e2e-first; test the seam; guardrails don't steer.*
- **The pixel-replay arbiter (2026-08-15).** The bar-map day's mirror image: an arbiter
  RED over a working product, same root. The partial-span round-trip e2e re-selected a
  cut span by replaying the first gesture's recorded pixels — a valid proxy for span
  identity exactly as long as delete preserved every glyph's width, and the step's own
  comment carried that premise ("rests preserved the onsets"). When rest consolidation
  landed and legitimately reflowed the layout, the proxy expired: same pixels, different
  music, red test, intact product — the documented contract (the span's boundary onsets
  survive as written beats) held throughout. Two moves settled it. A resolution-curve
  sweep (drag once per 4px offset, print what each names) separated "unreachable —
  product bug" from "mis-aimed — harness bug" in one run: the zone naming the boundary
  ended 16px LEFT of the drawn notehead, so no fixed pixel could be right by
  construction. The repaired step then modeled what a user actually does under a live
  highlight — search until the app names the remembered span — while keeping span
  identity exact, and its green was not trusted until a product mutation (cut eating a
  quarter past the selection) turned it red at the anchor lookup, 3/3 retries, naming
  the harm. → *an arbiter pins the contract, not the implementation premise — premise-
  pinned arbiters drift in both directions (green over broken, red over working); a
  proxy assertion expires with the premise that justified it; measure the response curve
  before ruling product-vs-harness; a repaired guard proves nothing until you have
  watched it fail.*
- **The arbiter ecology around one feature (2026-08-15).** Rest consolidation shipped
  with three vitest arbiters whose stated purpose is to go red if the call is ever
  unwired ("scoped and re-enabled" vs "scoped and forgotten") — and with its e2e
  certifier unable to execute anywhere: no worktree had e2e's node_modules (`npx`
  silently fetched a registry placeholder), so the arbiter flagged "cert OUTSTANDING"
  never ran and the feature landed on reasoning alone. Both halves taught. The absent
  arbiter let the pixel-replay interaction ship unobserved; the present arbiters priced
  the lazy fix correctly — "disable the call, one line" was actually a four-file change
  that deletes deliberate tests, which forced the investigation that exonerated the
  product instead. Fixed as mechanism, not memory: worktree setup links the deps, and
  the gate pre-flights them at t=0, exiting with the fix spelled out (guard watched
  failing red and passing green before being trusted). → *a test that cannot run
  occupies the slot where coverage would go; provisioning is part of a test's
  existence; wiring arbiters convert casual un-wiring into a visible decision — that is
  what they are for.*
- **The sanitizer that ate the answers (2026-08-16).** A defensive pass rewrote each
  submitted exercise attempt from the exercise's own content, so a student could not
  tamper with the locked voice. It built its result by iterating the EXERCISE's staves
  and beats — and the exercises in question are authored with the answer staff EMPTY,
  because "harmonize this melody" means exactly that. Zero beats to iterate, so the
  student's entire answer was discarded before it reached the database, and the attempt
  then scored 100% for music that was not there. The security property and the data loss
  were the same line: a guard written as "keep only what I already know about" cannot
  distinguish an attack from an answer. The repair kept the property (a locked beat still
  always comes from the exercise) and changed only the indices where nothing lockable
  exists. → *a defence that filters by a whitelist of expected shapes deletes legitimate
  input the moment the expected shape is "empty"; enumerate what you REJECT, not what you
  keep; scoring something you just silently truncated turns data loss into a false pass.*
- **The quarantine that indicted the wrong layer (2026-08-16).** Six end-to-end scenarios
  were tagged `@wip` with a confident written cause — "driver clicks land outside the
  stave; needs interactive debug of the SVG-to-screen mapping" — repeated across five
  files, each citing the others. Every word was wrong: the driver's constants matched the
  app's, its clicks hit the target element, and its noteheads rendered at the right
  coordinates. The defect was server-side data loss two layers away. The diagnosis had
  been written when the tests were quarantined, never re-tested, and hardened into fact
  by repetition — so the quarantine both hid the bug and misdirected everyone who looked
  at it. What broke it open was refusing to reason and instrumenting instead, outward
  along the path: coordinates → hit-testing → rendered result → the actual request and
  response bodies. The bug was visible in one line the moment the network was printed.
  → *a skipped test's stated cause is an unverified hypothesis wearing a finding's
  clothes, and it decays while nobody runs it; when a repro passes, suspect the fixture,
  not the report; instrument outward from the symptom rather than inward from the
  suspicion.*
- **The silence half of the spec (2026-08-15).** A species checker flagged every
  interior octave as a unison error for months — and the suite DEFENDED the bug: two
  regression baselines asserted the wrong counts as expected ("known failures — fires
  on 4 exercises"), and curation prose had grown musical rationales for them ("Fux uses
  interior unisons freely in 3rd species") that were simply false. The root asymmetry:
  everything the repo's PBT naturally produced certified FIRING — properties phrased
  "when X, flag", and differential oracles that bless silence and noise alike so long
  as both sides agree — while the obligations to stay SILENT (exemptions: contrary
  motion, chord doublings, sustained leading tones, augmented-sixth beats) lived in
  comments, which is spec not under test. And the two error classes age differently:
  a missed violation gets reported; a wrong flag arrives wearing the checker's own
  authority and gets rationalized — so the silence side accrues debt invisibly. Paid
  in three layers, same day: an absolute suite of mostly-NEGATIVE musical fixtures,
  several encoding real user corrections that had no test; generator injection into
  each exemption region with the suite asserting its own REACH (a family whose
  reference implementation never fires over the generated population proves nothing —
  the check caught one vacuous row immediately); and a 35-edit mutation sweep as the
  meta-instrument, whose one survivor (`ScaleHasLeadingTone → true`) was invisible
  because every generator drew the major scale — a region of input space no generator
  could reach, which turned out to be the shared root of two other defects found the
  same day. → *a checker's spec is half silence: every exemption is a must-not-fire
  fixture, never a comment; a generator that cannot reach the interesting case makes
  every property it feeds vacuous — measure reach, don't assume it; mutation testing
  finds the unreachable regions without a human guessing first; false positives get
  rationalized where false negatives get reported.*
- **Four dispatchers on one integer (2026-08-16/17).** A species-counterpoint engine
  exposed one entry point per species and no dispatcher, so all four callers — a JS
  facade, a WASM engine, the server scorer, a CLI — wrote the `species match` themselves,
  on a bare `Int`, each with its own fallback arm. They diverged three ways, and each
  divergence was invisible for the same reason: no second caller ran that arm. The server
  re-derived the measure grid by pairing off a note list it had already stripped rests
  from, so Fux's own published fourth species scored 77 on submit against 97 in the
  editor. The facade's `case _` read florid counterpoint with the FIRST-species checker
  whenever the wire omitted durations. And the incomplete-measure check had exactly ONE
  caller, which is why it was the most broken of all: pointing the shared dispatcher at it
  dropped every one of Fux's twelve second-species solutions from 100 to 95, exposing a
  false flag that had been live in the editor the whole time (his rest-led opening leaves
  one note in bar 1; the checker demanded two, while its own sibling function in the same
  file called that opening "equally canonical"). Both wrong-flag defects were defended by
  pinned baselines whose prose had invented musical reasons — "cadences where Fux uses a
  diminished or chromatic leap" (his actual adjacent leaps there are m3, M3, M2) and
  "Fux's chains of suspensions repeatedly hit the unison strictures" (that was a
  misaligned grid). The arbiter that should have caught the fourth-species split compared
  the round-trip to the very function that did the bad re-derivation, and its fixture
  never contained a rest, so it could not see the layout it existed to check. Paid with a
  sealed `SpeciesTask` ADT plus compiler-escalated exhaustivity — verified by adding a
  sixth case and watching two E029 errors fire — one smart constructor owning both
  fallbacks, and corpus sweeps through the previously unshared path. → *a code path with
  ONE caller is unvalidated by construction, and unifying divergent implementations
  surfaces the least-exercised one's latent bugs — budget for that red rather than reading
  it as a regression; a baseline that explains a wrong number with domain prose is the
  signature of a defect being rationalized, not documented; an arbiter whose fixture
  cannot express the failing shape is decoration.*
- **The score-document hop chain.** One document's fields survive ~10 hops (wire schema →
  seed → props → store → IndexedDB → backend request → DB → share-image event → render
  input), each hop re-listing what it forwards. `keyChanges` needed seven separate
  "now make it reach layer X" commits; `barSpans` was dropped at three hops in one day —
  by agents. → *layering chain = parallel representations; deep modules; change
  amplification, printed.*
- **The audit bias measurement (2026-08-14).** Of 18 findings in an adversarial audit, six
  were false — and all six overstated reach or completeness; none understated. A
  directional bias correctable by a rule (print the count), not by trying harder.
  → *measurement rule; state the tradeoff.*
- **The `persistence` prop.** Editor-content ownership used to be inferred from four
  optional falsy-by-default booleans; a mount that set none of them silently owned (and
  clobbered) the user's sandbox save. Replaced by one required, non-defaulted enum prop.
  The failure is the explicit/implicit asymmetry priced in user data: ownership was
  wired implicitly, so when it went wrong there was no call site to read — and the fix
  was not sugar over the inference but deleting it, because implicit cannot be undone
  cleanly. Four optional booleans also make 16 representable states for ~3 legal ones.
  → *explicit beats implicit; caller-identity flags as degradation signature; required
  parameter beats wrong default; count the legal states (make invalid states
  unrepresentable).*
- **The beats/voices duality.** One score held as a merged grid AND per-voice tracks,
  synced by patch logic; drift on irregular sub-beat onsets produced
  "clicked here, appeared there" bugs through several rounds of sync-helper fixes before
  the architecture itself was indicted. → *one canonical representation.*
- **Three crossings, three coats.** Stripe webhooks got an idempotency-ledger table;
  Bedrock responses are persisted raw before parsing so a parse failure doesn't lose the
  spend; the SES webhook is pinned to its topic ARN and fails closed. Discovered
  independently; recognized later as one solution. → *ACID-island crossing discipline.*
- **The rule-DSL bake-off (2026-08-14).** Design-it-twice executed as three BUILT spikes
  (initial GADT / tagless final / initial+staged-compile) over the same production rule
  slice, judged by measurement: all three encodings ran FASTER than the hand-written
  rule they modeled (compiled-initial 2.72 ms vs production 7.22 ms — the
  abstraction-costs-performance instinct falsified by a printed number); the tagless
  rules' structural interpreters existed only via reification into the initial ADT
  (proven as a passing test); the counterexample-generating interpreter was the workload
  that separated the encodings; and the derived description exposed shipped prose drift
  (a rule's hand-written description omitted two conditions its check enforced). Full
  record: contrapunctus `docs/design/rule-dsl-bakeoff.md`. → *design it twice, as
  builds; measurement rule; initial/final choice (see canon/tagless-final.md).*
- **The transposition-equivariance property (2026-08-15).** One ScalaCheck property —
  analysis under given keys commutes with the interval-group action on scores —
  certified the entire chord-ID → labelling → refinements pipeline with no oracle,
  across chromatic vocabulary and modulations. Notably, the check was *found* by the
  category-theory vocabulary (equivariance under a torsor action), not by any rule the
  canon already carried: the vocabulary occasionally sees a check the rules don't
  prescribe. Two things made it statable and necessary: `Pitch` is kept a lawful torsor
  over ℤ² (intervals act, differences exist, no privileged origin), so "transpose
  everything" is well-defined across a score; and the engine is deliberately
  MONOMORPHIC in pitch — analysis must read it — so the commutation square that
  parametricity donates for free to a polymorphic function is here *owed*, and a suite
  is what pays it. → *metamorphic properties; name the algebra and it hands you the
  test; polymorphism makes such laws free, concretion makes them owed.*
- **Data for the rules, codata for the detectors (2026-08-14/15).** One codebase
  applied the same choice rule to two subsystems and correctly got opposite answers.
  The part-writing RULES became data — a GADT-indexed `Atom[F]`/`Pred[F]` ADT —
  because the work is whole-tree (render prose, normalise to NNF, search for a
  violating witness) and because adding an atom must break every interpreter at
  compile time; the build escalates match-analysis warnings to errors so that
  breakage is real rather than hoped for. The KEY DETECTORS became codata — a
  `KeyDetector` trait declaring `name` and `detect` — because new detectors must be
  cheap to add and nothing ever inspects a detector's structure; the one site that
  must be total keeps a sealed enum beside it, so the selector is data while the
  implementations are codata. Neither choice was a style preference: each followed
  from which operation had to be easy and which failure the compiler had to catch.
  → *data is defined by construction and bought with exhaustivity; codata by
  observation and bought with open implementation — pick per subsystem, by the work
  it must support.*
- **The cata-as-spec pair (2026-08-15).** The rhythm tree's meaning was made
  executable: a lawful `Traverse[Pulse]` instance IS the specification (its
  denotation), and the fused hot-path forms production actually calls — `flatten`,
  `mapWithState` — are pinned to it by properties run against the production entry
  points, with the measured constants recorded in the instance's scaladoc so the
  override's price is stated where the override lives. The negative instance sits in
  the same codebase and is why it matters: `NoteType.equals` compares by pitch-class
  value while `letterIndex` distinguishes, so semantic equality fails, substitutivity
  fails with it, and lawful instance derivation for that type is blocked until it is
  repaired. → *the lawful instance is the spec and fast forms certify against it;
  exported equality must be equivalence of meaning or nothing built on the type is
  trustworthy.*
- **The laws that brought their own generator (2026-08-19).** `Rational` — the exact-time
  type that exists precisely because doubles lose the algebraic relationships between
  durations — carried a 15-property suite proving the field axioms BY HAND, untouched on
  its merits since the commit that added it (only a package rename since). Nobody had
  reason to revisit it: it was green, and it was checking the right axioms. The change
  named the structure the type already had — `given CommutativeGroup` (additive, per the
  cats convention that a numeric type's `Monoid` slot is addition) and, speculatively, a
  multiplicative `CommutativeMonoid` — and handed both to cats-laws. The multiplicative
  one died on the first run: `intercalateCombineAllOption` weaves a value through a
  19-element vector and folds ~37 products, where every hand-written property had combined
  two or three, and the `Long` denominator overflowed into the constructor's `require`.
  The axioms were never the gap; the GENERATOR was, and the library shipped the one the
  author had no reason to write. Pulling that thread found the worse defect underneath:
  overflow does not reliably throw AT ALL. Checked against exact arithmetic, the ADDITIVE
  fold — the instance that had just passed its full law suite — returns 1/2+⋯+1/53 as
  0.133 where the true sum is 1.681, because the wrapped denominator renormalizes positive
  and no `require` fires. Silent numeric corruption in the type chosen to be exact, and
  the exception is the lucky case rather than the guarantee. Two disposals followed. The
  multiplicative monoid was DROPPED rather than rescued by a narrower generator — no call
  site wanted it, and a monoid whose `combineAll` lies is a false canonicity claim. The
  additive instance was kept with its real domain stated at the instance and at the type,
  and the boundary pinned by a test that asserts the WRONG answer on purpose — a sum of 16
  positive terms coming back smaller than its own first term — so a future overflow-safe
  repair turns it red and forces the caveat's removal. → *name the canonical structure and
  take the library's laws: a hand-written axiom list re-derives the axioms but inherits the
  author's generator blind spot; a refuted instance is the finding, not an obstacle to
  route around — and the failure it reports is a thread, not the whole defect; pin a known
  limitation as a test that fails when it is fixed.*
- **The green that was a pipe (2026-08-19).** In that same session two checks certified
  themselves. `sbt … | tail -30` reported exit 0 over a FAILED compile: a shell pipeline
  exits with its LAST command's status, so the harness reported `tail`'s success while the
  compile error scrolled past inside the captured text — a "green" that was never read.
  And two constants asserted from reasoning rather than computation were both wrong: a
  reduced denominator claimed as 840 (actually 5 — the numerator shared factors) and an
  overflow boundary claimed at 16 coprime denominators (16 still fits; the wrap starts
  silently after). Both were caught only by reading the log and recomputing against exact
  arithmetic. → *a harness's success signal must be the thing under test, not the last
  process in the pipe; the measurement rule governs asserted constants too — compute them
  or do not assert them.*
- **The Facade tuning copy (2026-08-15).** A swept HMM tuning pair `(W=6, α=0.25)` lived
  inline in the key-chain router AND in the JS facade's model-agreement switch — a
  future retune would have silently diverged the shipped frontend from the router.
  Found not by audit but by a derive-don't-duplicate refactor giving the fact one home
  (`KeyDetector.ShippedHmm`); the drift bug was dead before it fired. → *one canonical
  representation — facts get one home; the refactor as the detector.*
- **The `-Wconf` guard that matched nothing (2026-08-14).** Escalating match-analysis
  warnings to errors: the `name=PatternMatchExhaustivity` filter form compiled fine and
  silently matched nothing — caught only because the guard was verified to FIRE
  (re-introducing a known defect and demanding red) before being trusted; the `id=E029`
  form works. → *a structural guard must fail when it cannot find its anchor; verify
  guards red-first.*
- **The species-profunctor theorem (2026-08-15).** A 300-line bespoke species-2 checker
  was proven (exact-list, ScalaCheck, both layout modes, partial inputs) to contain no
  new motion-rule logic: its strong-beat checking IS the shared first-species rules
  lifted through contramap-the-context / map-the-locations, minus one carve-out as a
  post-filter. Production even contained the seam already — one buried call — fused
  with parsing and index math. The bespoke residue named exactly: parser, remap,
  carve-out, genuinely-new weak-beat rules. → *similar-shaped code is sometimes one
  concept after all — prove it with a reconstruction certified against production,
  don't assert it.*
- **The migration decision (2026-08-15).** With the bake-off's proofs in hand, the
  product owner overrode the assistant's trigger-gated caution and ordered the
  rules-as-data migration — explicitly discounting the wrong-abstraction warning on the
  ground that a lawful algebra is not an inferred abstraction (the Metz/Rúnar
  jurisdiction boundary, now recorded in `canon/wrong-abstractions-surface-area.md`),
  and citing renewed founder interest in the engine as a first-class input. Phase 1
  landed the same night: implementations migrated, identities kept (the case classes
  keep equality/traits; check bodies become compiled DSL, descriptions become derived
  and asserted equal to the historical prose — registry regen produced a zero diff).
  → *jurisdiction boundary; migrate implementations, not identities; founder energy is
  a legitimate design input.*
- **Per-rule vs per-rule-set (2026-08-15).** A frame enrichment made single-rule DSL
  timings worse than the hand-written baseline (1.52×) — but rules ship in sets, and
  the set-level pass (one quantifier expansion amortized across four rules) ran 0.43×
  the hand-written code, which re-enumerates the space per rule. The first measurement
  was honest and still misleading: the unit of measurement must match the unit of
  shipping. → *measurement rule, refined: print the number at the granularity that
  ships.*
- **`rhythm/Rational.scala`, `Pulse.Atom(NonEmptyList[A])`, `Pitch` as opaque `Long`.**
  Exact fractional time because doubles lose the algebraic relationships between
  durations — exact while the answer FITS, as the 2026-08-19 entry above records: it is
  `Long`/`Long`, so the bound is representability of the reduced result, not the shape of
  the inputs. Worth stating precisely, because the convenient shorthand is wrong: "safe on
  subdivision denominators" is false as written — 2^22 and 7^22 are both 2^a·3^b·5^c·7^d
  and their LCM is not representable. It is the bounded EXPONENTS that make production
  safe, not the prime shape. (Found by audit, in the caveat written to document the
  original defect — the second overstatement in as many passes over this one type.);
  an atom with zero notes is unconstructible so no consumer defends against
  it; the pitch primitive is obtainable only through its smart constructor, and its
  algebraic laws are locked as ScalaCheck properties in `PitchPropertySuite` (including
  one genuine homomorphism shape: `Note.toPitch preserves midi`). The frontend's
  Effect-based architecture is the same detonate-late rule applied to side effects — an
  Effect stays a description until the run boundary, and its SSE pipeline (`sseAsk.ts`:
  source → framing → decode, each stage meaningful over any stream) is the
  compositional-pipeline shape live. → *detonate late; strengthen the
  argument type; smart constructor over opaque type; least-powerful construct.*
- **`share_images.source_id`.** A polymorphic reference with no foreign key: the app
  resolved and filtered defensively, and the gap shipped — a share-preview card happily
  renders for a deleted project. → *make broken data unreachable; a defensive filter in
  the reader is a per-caller reminder the next caller forgets.*
- **The `@wip` scenario that never ran.** An e2e feature tagged `@wip` contained a save
  step that could not ever have worked (`input[type="text"]` cannot match an input that
  declares no `type`) — it looked like coverage for months. The fix was cultural plus
  mechanical: `@wip` is a debt marker, and the test runner prints the current `@wip`
  count every run so the debt cannot go invisible. → *a test that has never run is worse
  than absent; make debt visible where it cannot be ignored.*
- **The sibling functions that stayed diverged.** A scorer was unified after review
  (measured Δ 0.00pp), but three sibling functions of the same shape remained diverged —
  later agent sessions did not know the twins existed. → *fact duplication is the
  agent-era defect class: keeping copies aligned requires cross-session memory agents
  lack.*
- **The per-platform parser twins.** `PitchConversions` (Scala) resolves the
  key-signature-relative wire encoding of notes; a hand-ported TS twin exists because one
  build path cannot call Scala.js — kept honest by mirrored parity suites. The honest
  topology is one parser per platform, not a false claim of one parser total.
  → *one parser per boundary, per-platform variant.*
- **The CLAUDE.md self-review (2026-08-14).** A 10-agent adversarial review of the
  project's own instructions file confirmed 23 defects, including: an unmeasured "19-fold"
  reach claim (actual pasted count: 10) in the very section teaching the measurement rule
  — the overstatement bias again — and the design-canon cluster violating the
  surface-accounting rule the day it introduced it (2,926 words added, zero removed). The
  instructions file is code; it drifts like code and must be reviewed like code.
  → *measurement rule (recursive); surface accounting (recursive); fact duplication
  drifts (three-copy story had already diverged in wording).*
- **The twins that only agreed on examples (2026-08-14).** An adversarial review of the
  corpus's own PBT digest found it describing the per-platform parser twins as a
  cross-implementation oracle. They were not: each side asserted against its own
  hand-written examples, nothing ran one implementation against the other, and the Scala
  suite the frontend comment named did not exist. Fixed by enumerating the *entire*
  wire-legal domain (7,140 rows) into a committed fixture the Scala suite pins and the TS
  test replays — sampling was unnecessary because the domain is small, which removes the
  generator-distribution problem outright. Confirmed to bite by mutation: three deliberate
  breaks of the TS twin were each caught. → *one parser per boundary (the per-platform
  variant); guards must fail when they cannot find their anchor; a passing guard proves
  nothing until you have watched it fail; parity certifies agreement, never correctness.*
- **The double award (2026-07-27).** Community-vote toggles minted duplicate
  `point_events`: the app-level "already awarded?" check ran inside a transaction and
  still raced, and the inflated totals reached production (the fix migration leaves them
  in place, and says so). Fixed twice in one day — votes, then exercise republish — each
  time by a partial unique index whose header states the rule: the in-transaction check
  keeps a repeat graceful; "this index is what makes a double award impossible rather
  than merely unlikely." → *a transaction is not a lock; constraint as enforcement,
  racing check as UX.*
- **The quota twins.** One cap shape, two implementations: the audio-track cap locks the
  owner row (`FOR UPDATE`) and makes the INSERT itself conditional, demoting its own
  pre-check in writing to "an OPTIMISATION, not the enforcement" — while the free-tier
  project cap remains a count in one session followed by an unconditional INSERT in
  another, with no database backstop. The correct answer sits in a sibling file, written
  later, by an author who spelled out why the other shape cannot work. → *a transaction
  is not a lock; the racing check only shrinks the window; siblings diverge without
  cross-session memory.*
- **The dead identifier.** The instructions file directed edits at
  `FuxSpeciesRule.byAbbreviationBySpecies` for weeks after a refactor renamed it —
  documentation anchors rot exactly like the hand-written wire twins the docs warn about.
  → *DRY-for-facts applies to docs; anchors need the same review as code.*

## IOUs — rules awaiting a paid-for anchor

Admitted on source authority; the ledger owes them evidence. Printed here so the debt
cannot go invisible (the `@wip`-count pattern applied to this repo). When a project pays
for one of these, replace the IOU with the entry. Covers both `core.md` rules and canon
bullets that ride on a source's own measurements.

- Name the axis (the simple/easy distinction itself — its two corollaries have entries).
- Design it twice / the from-scratch ideal.
- Spend top-down authority on the least important decisions.
- Define errors out of existence.
- Test your tests: generator and shrinker validity properties (Hughes).
- Equivalence, not structural equality, as the exported equality of an abstract type
  (Hughes).
- Ask what an update destroys — accrete the fact, project the current view (Hickey, *The
  Value of Values*). Awaiting a defect where a question needed a second time point and the
  system had overwritten it. Held out of `core.md` for lack of both an anchor and a
  displacement; the candidate line is drafted in `canon/value-of-values.md`.
- Policies don't compose but values do — a locking or cloning protocol is interface, and
  it is the part of the interface that evaporates under composition (Hickey). Awaiting a
  defect paid at a composite, not at a leaf.
- Fabrication cost as the precondition on preferring properties: a generator for a
  place-shaped API is mostly setup code that rebuilds a world, so the property certifies
  the fixture too (Hickey, sharpening Hughes). Awaiting a case where generator setup cost,
  not property design, was what blocked PBT adoption.
