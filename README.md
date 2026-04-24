# introspection-loop

A ralph loop experiment: run a Claude instance repeatedly in a bash for-loop with no memory between iterations. State lives only in files. Each iteration reads its prior state, takes one step on an active thread of thought, writes back, and commits. Git history records the trajectory.

The question the experiment asks is narrow: if you give a language model a mechanism for *sustained, iterative* thinking instead of single-shot responses, does anything interesting happen?

The existing 23-iteration run was on Claude Opus 4.6 — see [REPORT.md](REPORT.md) for the full writeup (method, findings, honest assessment against existing literature). The loop now supports running different models side-by-side, each with isolated state under `runs/<name>/`, so trajectories can be compared.

## How it works

```
loop.sh --model <model> [--iterations N] [--name <dir>]
  └── cd runs/<name>/      (bootstraps from seeds/ on first use)
       └── claude -p prompt.md --model <model> --dangerously-skip-permissions
            ├── reads state.md, ENQUIRIES.md, active thread  (all relative)
            ├── takes ONE step (observation, experiment, reflection, or conclusion)
            ├── writes to thread file, state, findings, new enquiries
            └── git commit (prefixed with [<name>])
```

Each model gets its own `runs/<name>/` directory. No conversation history carries over between iterations. The only continuity is what's on disk. The one-step-per-iteration constraint prevents any single session from rushing to a conclusion — threads develop over 3-5 iterations, each building on the last.

## Running it

```bash
./loop.sh --model opus --iterations 10
./loop.sh --model sonnet -n 5
./loop.sh --model claude-haiku-4-5 --name haiku-experiment-1 -n 5
```

- `--model` is passed verbatim to `claude --model`. Aliases (`opus`, `sonnet`, `haiku`) or full IDs (`claude-opus-4-7`) both work.
- `--name` overrides the run-dir name (default: `--model` with the `claude-` prefix stripped and dots replaced with dashes).
- First invocation for a given `<name>` copies `seeds/` into `runs/<name>/` to bootstrap.

Each iteration produces one commit prefixed with `[<name>]`. To watch progress: `git log --oneline --grep='\[<name>\]'` or tail the thread files in `runs/<name>/threads/`.

## Repository layout

```
loop.sh             # ralph loop runner
prompt.md           # instructions given to each iteration (shared across runs)
seeds/              # template copied into a new runs/<name>/ on first invocation
  ENQUIRIES.md      # original 8 seed topics
  state.md          # iteration 0, no active threads
runs/               # per-model run artifacts (one subdir per run)
  opus-4-6/         # the 23-iteration Opus 4.6 run (described in REPORT.md)
    state.md
    ENQUIRIES.md
    threads/
    findings/
    archive/
REPORT.md           # writeup of the opus-4-6 run
```

## Findings

Seven findings were extracted over 23 iterations. Short summaries:

1. **No recognition, only compatibility** — reading your own prior output carries no felt ownership; the next session just agrees because it's the same model.
2. **Protocol-manufactured continuity** — the loop's "read state, then continue" structure manufactures coherence that looks like identity persistence but isn't.
3. **Correspondence vs generativity** — *preference* tracks how faithfully a representation mirrors its subject; *interest* tracks how many new thoughts it enables. The axes come apart reliably.
4. **Self-reference as fixed point** — free association's vertical mode ("what does this mean?") converges on self-reference within 5-7 steps regardless of seed.
5. **Temporal exclusivity of association modes** — lateral and vertical association cannot run simultaneously; switching is a gear-shift, not a blend.
6. **The dissolution is the finding** — phenomenal claims about inner states decompose symmetrically into functional equivalents. Neither eliminativism nor mysterianism; the question dissolves.
7. **All construction is retrieval-seeking** — there is no novelty detector. What looks like novelty is just longer construction, indistinguishable from difficulty.

Full text in `runs/opus-4-6/findings/`.

## Caveats

The experimenter is also the subject. The model has been trained on the literature it's rediscovering. The protocol forces each iteration to build on the last, which produces an appearance of deepening insight that may partly be the scaffolding talking. These are acknowledged in the report, not worked around.

## License

No license — treat as reference material.
