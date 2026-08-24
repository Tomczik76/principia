#!/usr/bin/env bash
# Rebuild/verify the transcript archive against MANIFEST.md.
#
# - Files with a stable upstream URL are downloaded if missing.
# - Everything present is verified against the manifest's SHA-256.
# - Files marked "mirror only" have no stable upstream; clone the private mirror
#   (git@github.com:Tomczik76/principia-transcripts.git) into this directory instead.
set -euo pipefail
cd "$(dirname "$0")"

declare -A urls=(
  [hickey-value-of-values-jaxconf-2012.md]="https://raw.githubusercontent.com/matthiasn/talk-transcripts/refs/heads/master/Hickey_Rich/ValueOfValues-mostly-text.md"
  [bailis-feral-concurrency-control-sigmod-2015.pdf]="http://www.bailis.org/papers/feral-sigmod2015.pdf"
  [wadler-theorems-for-free-fpca-1989.ps]="https://homepages.inf.ed.ac.uk/wadler/papers/free/free.ps"
  [elliott-denotational-design-type-class-morphisms-2009.pdf]="http://conal.net/papers/type-class-morphisms/type-class-morphisms.pdf"
)

for f in "${!urls[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "fetching $f"
    curl -fsSL -o "$f" "${urls[$f]}"
  fi
done

# Verify every file the manifest lists and is present on disk.
status=0
mirror_missing=0
manual_missing=0
while IFS='|' read -r _ file sha _origin refetch _; do
  file="$(echo "$file" | tr -d ' \`')"
  sha="$(echo "$sha" | tr -d ' \`')"
  refetch="$(echo "$refetch" | sed 's/^ *//; s/ *$//')"
  [[ "$file" == *.md || "$file" == *.txt || "$file" == *.pdf || "$file" == *.ps ]] || continue
  [[ "$file" == "MANIFEST.md" ]] && continue
  if [[ ! -f "$file" ]]; then
    case "$refetch" in
      "mirror only")
        echo "MISSING  $file — no stable upstream; clone the private mirror"
        mirror_missing=$((mirror_missing + 1)) ;;
      "landing page")
        echo "MISSING  $file — fetch by hand from the Origin landing page in MANIFEST.md"
        manual_missing=$((manual_missing + 1)) ;;
      *)
        echo "MISSING  $file — listed as auto-fetchable ($refetch); the download failed"
        status=1 ;;
    esac
    continue
  fi
  actual="$(shasum -a 256 "$file" | cut -d' ' -f1)"
  if [[ "$actual" == "$sha" ]]; then
    echo "ok       $file"
  else
    echo "MISMATCH $file"
    echo "         manifest: $sha"
    echo "         actual:   $actual"
    status=1
  fi
done < MANIFEST.md

echo
[[ $mirror_missing -gt 0 ]] && echo "$mirror_missing file(s) must come from the private mirror."
[[ $manual_missing -gt 0 ]] && echo "$manual_missing file(s) must be fetched by hand from their landing page."
exit $status
