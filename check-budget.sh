#!/usr/bin/env bash
# The core budget, retired from prose into a mechanism (METHOD.md, "The core budget").
#
# core.md is the always-on layer: it is imported into every consuming project's
# CLAUDE.md and pays context cost in every session, forever. The law is that a new
# line enters only by displacing one. Prose could not enforce it — between
# 2026-08-14 and 2026-08-20 the file grew 111 -> 163 lines across nine commits, two
# of which displaced and none of which shrank it, while the law was cited as a
# refusal ground. So the ceiling lives here instead.
#
# To grow core.md you must raise CEILING_LINES/CEILING_WORDS in the same commit.
# That edit IS the decision: it appears in the diff, it needs a reason in the commit
# message, and it cannot happen by accident. Lowering it after a displacement pass
# is always welcome and never needs one.
set -euo pipefail
cd "$(dirname "$0")"

CEILING_LINES=158
CEILING_WORDS=1869

if [[ ! -f core.md ]]; then
  # A guard that cannot find its anchor must fail, not pass.
  echo "FAIL  core.md not found — the guard has lost its anchor, not passed."
  exit 2
fi

lines=$(wc -l < core.md | tr -d ' ')
words=$(wc -w < core.md | tr -d ' ')
status=0

report() { # name current ceiling
  if (( $2 > $3 )); then
    echo "OVER  core.md $1: $2 against a ceiling of $3 (+$(($2 - $3)))"
    status=1
  else
    echo "ok    core.md $1: $2 / $3 ($(($3 - $2)) of headroom)"
  fi
}

report lines "$lines" "$CEILING_LINES"
report words "$words" "$CEILING_WORDS"

if (( status != 0 )); then
  cat <<'MSG'

core.md grew without displacing. Two honest exits:
  - displace: cut a line of equal weight and re-run, or
  - raise the ceiling in check-budget.sh in THIS commit, and say in the message
    what the always-on layer bought for the context it now costs.
The one thing not on the list is growing it quietly.
MSG
fi
exit $status
