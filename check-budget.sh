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
# The word ceiling covers everything always in context, not just core.md: a skill in
# skills/ without `disable-model-invocation: true` puts its description (and
# when_to_use) in every session that has it installed — symlinked into
# ~/.claude/skills, that is every project on the machine, not just the importers. A
# user-invoked skill costs nothing until called. Without this, a skill would be a
# second door for the same quiet growth.
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

# Prints "user" for a user-invoked skill, the always-on word count otherwise, and
# "NOANCHOR" when the frontmatter or its description cannot be found.
frontmatter_words() {
  awk '
    NR == 1 { if ($0 != "---") { bad = 1; exit } next }
    $0 == "---" { closed = 1; exit }
    /^[A-Za-z_-]+:/ { key = $0; sub(/:.*/, "", key); val = $0; sub(/^[^:]*:[ \t]*/, "", val) }
    !/^[A-Za-z_-]+:/ { val = $0 }
    key == "disable-model-invocation" && val ~ /^true/ { user = 1 }
    key == "description" { has = 1 }
    key == "description" || key == "when_to_use" { sub(/^[>|][-+]?$/, "", val); n += split(val, w) }
    END {
      if (bad || !closed || !has) print "NOANCHOR"
      else if (user) print "user"
      else print n
    }' "$1"
}

skill_words=0
for skill in skills/*/SKILL.md; do
  [[ -e "$skill" ]] || continue # no skills at all is a legitimate state, not a lost anchor
  r=$(frontmatter_words "$skill")
  case "$r" in
    NOANCHOR)
      echo "FAIL  $skill: no frontmatter description — the guard has lost its anchor, not passed."
      exit 2 ;;
    user) echo "      $skill: user-invoked, 0 words in context" ;;
    *)    echo "      $skill: model-invocable, $r description words always in context"
          skill_words=$((skill_words + r)) ;;
  esac
done

report() { # name current ceiling
  if (( $2 > $3 )); then
    echo "OVER  $1: $2 against a ceiling of $3 (+$(($2 - $3)))"
    status=1
  else
    echo "ok    $1: $2 / $3 ($(($3 - $2)) of headroom)"
  fi
}

report "core.md lines" "$lines" "$CEILING_LINES"
if (( skill_words == 0 )); then
  report "core.md words" "$words" "$CEILING_WORDS"
else
  report "always-on words (core.md $words + skills $skill_words)" "$((words + skill_words))" "$CEILING_WORDS"
fi

if (( status != 0 )); then
  cat <<'MSG'

The always-on layer grew without displacing. Two honest exits:
  - displace: cut a line of equal weight and re-run, or
  - raise the ceiling in check-budget.sh in THIS commit, and say in the message
    what the always-on layer bought for the context it now costs.
The one thing not on the list is growing it quietly.
MSG
fi
exit $status
