#!/bin/bash
# Runs `pana . --no-warning` and verifies that the package score is greater or
# equal to the desired score. By default the desired score is a perfect score
# but it can be overridden by passing the desired score as an argument.
#
# Ensure the package has a score of at least 130
# `./ensure_pana_score.sh 130`
#
# Ensure the package has a perfect score
# `./ensure_pana_score.sh`
set -euo pipefail

PANA=$(pana . --no-warning)
echo "$PANA"

PANA_SCORE=$(echo "$PANA" | sed -n "s/.*Points: \([0-9]*\)\/\([0-9]*\)./\1\/\2/p")
if [ -z "$PANA_SCORE" ]; then
  echo "could not determine the pana score!"
  exit 1
fi
echo "score: $PANA_SCORE"

SCORE=${PANA_SCORE%%/*}
TOTAL=${PANA_SCORE##*/}
MINIMUM_SCORE=${1:-$TOTAL}

if ((SCORE < MINIMUM_SCORE)); then
  echo "minimum score $MINIMUM_SCORE was not met!"
  exit 1
fi
