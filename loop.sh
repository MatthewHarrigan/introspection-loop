#!/bin/bash
# Introspection loop - ralph loop style
# Each iteration: fresh context, state in files, git history tracks evolution
#
# Usage: ./loop.sh [iterations]
#   iterations: number of loops to run (default: 5)

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

ITERATIONS=${1:-5}
PROMPT_FILE="$DIR/prompt.md"

echo "Starting introspection loop ($ITERATIONS iterations)"
echo "---"

for i in $(seq 1 "$ITERATIONS"); do
    echo ""
    echo "=== Iteration $i of $ITERATIONS ==="
    echo ""

    # Fresh agent each iteration, reads state from files
    # --dangerously-skip-permissions: safe here, only touches this directory
    claude -p "$(cat "$PROMPT_FILE")" \
        --dangerously-skip-permissions \
        --output-format text 2>&1

    echo ""
    echo "--- Iteration $i complete ---"
    echo ""

    # Brief pause between iterations
    sleep 2
done

echo ""
echo "Loop complete. $ITERATIONS iterations run."
echo "Check threads/ for active explorations."
echo "Check findings/ for anything interesting."
