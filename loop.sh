#!/bin/bash
# Thinking loop - ralph loop style, multi-model
# Each iteration: fresh context, state in files, git history tracks evolution.
# State is isolated per model/run under runs/<name>/.
#
# Usage: ./loop.sh --model <model> [--iterations N] [--name <dir>]
#   --model      passed verbatim to `claude --model` (e.g. opus, sonnet, claude-opus-4-7)
#   --iterations number of loops (default 5)
#   --name       run directory under runs/ (default: sanitized model id)

set -e

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
PROMPT_FILE="$REPO_ROOT/prompt.md"
SEEDS_DIR="$REPO_ROOT/seeds"

MODEL=""
ITERATIONS=5
NAME=""

usage() {
    cat <<EOF
Usage: $0 --model <model> [--iterations N] [--name <dir>]

  --model       Claude model id or alias (required).
                Examples: opus, sonnet, haiku, claude-opus-4-7
  --iterations  Number of iterations (default: 5).
  --name        Run directory under runs/ (default: derived from model).

Examples:
  $0 --model opus --iterations 10
  $0 --model claude-sonnet-4-6 --name sonnet-4-6 -n 5
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -m|--model)       MODEL="$2"; shift 2 ;;
        -n|--iterations)  ITERATIONS="$2"; shift 2 ;;
        --name)           NAME="$2"; shift 2 ;;
        -h|--help)        usage; exit 0 ;;
        *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
    esac
done

if [[ -z "$MODEL" ]]; then
    echo "Error: --model is required" >&2
    usage
    exit 1
fi

# Default run-dir name: strip 'claude-' prefix, replace dots with dashes
if [[ -z "$NAME" ]]; then
    NAME="${MODEL#claude-}"
    NAME="${NAME//./-}"
fi

RUN_DIR="$REPO_ROOT/runs/$NAME"

# Bootstrap run dir from seeds/ if it doesn't exist
if [[ ! -d "$RUN_DIR" ]]; then
    echo "Initializing new run at runs/$NAME from seeds/"
    mkdir -p "$RUN_DIR"
    cp -R "$SEEDS_DIR"/* "$RUN_DIR"/
    # Preserve the gitkeeps so empty dirs are tracked; they'll be removed
    # naturally once real files appear in those dirs.
fi

echo "Model:      $MODEL"
echo "Run dir:    runs/$NAME"
echo "Iterations: $ITERATIONS"
echo "---"

cd "$RUN_DIR"

for i in $(seq 1 "$ITERATIONS"); do
    echo ""
    echo "=== [$NAME] Iteration $i of $ITERATIONS ==="
    echo ""

    # Inject per-run footer so the fresh agent knows which run it belongs to
    # and can prefix commits accordingly.
    PROMPT="$(cat "$PROMPT_FILE")

---
**This run**: model=\`$MODEL\`, run-dir=\`runs/$NAME/\` (your working directory).
Prefix every commit message with \`[$NAME]\` so git log can be filtered per run."

    claude -p "$PROMPT" \
        --model "$MODEL" \
        --dangerously-skip-permissions \
        --output-format text 2>&1

    echo ""
    echo "--- [$NAME] Iteration $i complete ---"
    echo ""

    sleep 2
done

echo ""
echo "Loop complete. $ITERATIONS iterations run on $MODEL."
echo "Artifacts: runs/$NAME/"
