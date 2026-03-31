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
    claude -p "$(cat "$PROMPT_FILE")" \
        --allowedTools "Read,Write,Edit,Bash(git commit:*),Bash(git add:*),Bash(git status:*),Glob" \
        --output-format stream-json 2>&1 | \
        # Extract just the text content for display
        python3 -c "
import sys, json
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    try:
        obj = json.loads(line)
        if obj.get('type') == 'assistant' and 'content' in obj:
            for block in obj['content']:
                if block.get('type') == 'text':
                    print(block['text'])
    except (json.JSONDecodeError, KeyError):
        pass
"

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
