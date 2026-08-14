# Parse, Don't Validate (Alexis King)

**Source:** Essay, 2019-11-05.
https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/

## The import

The boundary discipline — the in-memory form of two data rules ("make invalid states
unrepresentable" constrains shapes; "make broken data unreachable" constrains the DB): a
*validator* checks a property and throws away what it learned — its output is `Unit` or
`Boolean`; a *parser* performs the identical check but returns a refined type that carries
the proof, so the check can never need repeating. General form: turn less-structured input
into more-structured output at the boundary, where failure is explicit and expected —
after which the interior operates on types for which the failure case does not exist. This
is Rúnar's detonate-late rule run in reverse: gain structure as early as possible on the
way in, lose it as late as possible on the way out.

- **Given a partial function, strengthen the argument type rather than weaken the return
  type.** Returning `Option[A]` from `head` pushes a redundant check onto every caller
  forever; taking `NonEmptyList[A]` pushes one check to the creation site.
- **A defensive check deep in the interior is a diagnostic, not a fix.** It is evidence
  the boundary failed to parse. King's named antipattern is *shotgun parsing* — ad-hoc
  checks scattered through the code, which let partially-invalid data flow and corrupt
  state before any error surfaces, and force the whole program to assume failure can
  happen anywhere. The fix direction is always upward: move the check to the creation site
  and refine the type so downstream cannot re-ask. (The DB-side rule against compensating
  `WHERE`s on read paths is the same rule one layer down.)
- **One parser per boundary, and everything routes through it.** When a boundary spans
  platforms that cannot share code, the honest topology is one parser per *platform* —
  deliberate twins kept honest by mirrored parity suites — and anything *else* touching
  the raw wire form is shotgun parsing by definition.
- **When the full invariant won't fit in a type, reach for a smart constructor over an
  opaque type** — the only way to obtain the value is through the parse. Corollary smell:
  a function whose only job is error-signaling and whose only output is `Unit`/`Boolean`
  is a parser that discarded its result.

## Keep King's own caveats

Not every invariant merits type-level encoding, complex input can need multi-pass parsing,
and authorization checks may legitimately precede parsing. The principle ranks designs; it
does not replace judgment.

## Evidence

See `../case-studies.md` — Contrapunctus: `PitchConversions` + its parity-tested TS twin
(the per-platform topology), `Pulse.Atom(NonEmptyList[A])`, `Pitch` as an opaque `Long`.
