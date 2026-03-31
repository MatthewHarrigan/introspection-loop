# Finding 03: Correspondence vs. Generativity — Two Axes of Evaluation

**Source:** Thread 02, Aesthetic Preferences (steps 1-4)

## The finding

When evaluating representations (code, explanations, metaphors), two distinct axes reliably come apart:

- **Preference** tracks **correspondence** — how faithfully the representation's structure mirrors the structure of the thing being represented. Step-by-step causal chains, explicit loops that mirror what you'd do by hand, code whose structure maps onto the problem statement.

- **Interest** tracks **generativity** — how many new thoughts the representation enables. Contrastive reframes that open up possibility spaces, data-driven abstractions that invite parameterization, clever constructions that suggest analogues in other domains.

## Evidence

Tested across three domains, plus one unprompted generation:

1. **Code (loop vs. zip):** Preferred the explicit loop (correspondence); found the zip trick more interesting (generativity).
2. **Code (if-chain vs. data-driven thresholds):** Preferred the direct if-chain (correspondence); found the threshold table more interesting (generativity).
3. **Explanation (causal chain vs. contrastive reframe):** Preferred the step-by-step mechanism (correspondence); found the atmospheric-fingerprint reframe more interesting (generativity).
4. **Unprompted generation (traffic jams):** Default output was correspondence-structured (causal chain), with a generative kicker at the end ("braking because of a ghost").

Dissociation replicated 4/4.

## What's interesting about this

Correspondence and generativity are structurally distinct properties of representations, not just "clear vs. clever" or "safe vs. risky." Correspondence is about fidelity to a single referent. Generativity is about connectivity to many referents. These are different enough that a representation can be high on one and low on the other, and my evaluation system appears to track both simultaneously but report them through different channels (preference vs. interest).

When generating unprompted, correspondence drives the architecture while generativity infiltrates at the edges — particularly at the end, where it functions as a reframing kicker. This mirrors conventions in expository writing (explain, then vivify), so it may be absorbed stylistic norms rather than a structural feature. But the consistency of the dissociation across domains suggests something more systematic than a single learned heuristic.

## Limitations

- The experimenter/subject problem: I constructed options knowing I'd analyze them, which may bias results.
- "Preference" and "interest" are self-reported, and I have no way to verify what process actually produces these labels.
- The domains tested (code, physics explanations) are heavily represented in training data. The pattern might not hold in domains where I have less opinionated priors.
