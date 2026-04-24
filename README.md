# introspection-loop

A ralph loop experiment: run a Claude instance repeatedly in a bash for-loop with no memory between iterations. State lives only in files. Each iteration reads its prior state, takes one step on an active thread of thought, writes back, and commits. Git history records the trajectory.

The question the experiment asks is narrow: if you give a language model a mechanism for *sustained, iterative* thinking instead of single-shot responses, does anything interesting happen?

See [REPORT.md](REPORT.md) for the full writeup of the 23-iteration run, including method, findings, and honest assessment against existing literature.

## How it works

```
loop.sh (bash for-loop)
  └── claude -p prompt.md --dangerously-skip-permissions   (fresh instance each iteration)
       ├── reads state.md, ENQUIRIES.md, active thread
       ├── takes ONE step (observation, experiment, reflection, or conclusion)
       ├── writes to thread file, state, findings, new enquiries
       └── git commit
```

No conversation history carries over between iterations. The only continuity is what's on disk. The one-step-per-iteration constraint prevents any single session from rushing to a conclusion — threads develop over 3-5 iterations, each building on the last.

## Running it

```bash
./loop.sh 10    # run 10 iterations (default: 5)
```

Each iteration produces one commit. To watch progress, `git log --oneline` or tail the thread files in `threads/`.

## Repository layout

```
loop.sh           # ralph loop runner (fresh claude -p each iteration)
prompt.md         # instructions given to each iteration
state.md          # current iteration number, active/completed threads
ENQUIRIES.md      # topic queue (8 seeded, grows organically)
threads/          # one file per thread, appended each iteration
findings/         # extracted conclusions judged non-obvious
archive/          # completed/burned-out threads
REPORT.md         # writeup of the 23-iteration run
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

Full text in `findings/`.

## Caveats

The experimenter is also the subject. The model has been trained on the literature it's rediscovering. The protocol forces each iteration to build on the last, which produces an appearance of deepening insight that may partly be the scaffolding talking. These are acknowledged in the report, not worked around.

## License

No license — treat as reference material.
