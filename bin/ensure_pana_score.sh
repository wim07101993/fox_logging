#!/bin/bash
# Runs `pana . --no-warning` and verifies that the package score
# is greater or equal to the desired score. By default the desired score is
# a perfect score but it can be overridden by passing the desired score as an argument.
#
# Ensure the package has a score of at least a 100
# `./ensure_pana_score.sh 100`
#
# Ensure the package has a perfect score
# `./ensure_pana_score.sh`

PANA=$(pana . --no-warning)
echo "$PANA"
PANA_SCORE=$(echo "$PANA" | sed -n "s/.*Points: \([0-9]*\)\/\([0-9]*\)./\1\/\2/p")
echo "score: $PANA_SCORE"
IFS='/'
read -r -a SCORE_ARR <<<"$PANA_SCORE"
SCORE=SCORE_ARR[0]
TOTAL=SCORE_ARR[1]

# For this package we only need a score of 110 since isolates are not available for web
MINIMUM_SCORE=130
if ((SCORE < MINIMUM_SCORE)); then
  echo "minimum score $MINIMUM_SCORE was not met!"
  exit 1
fi
