---
name: "highest-why"
description: "Top-of-chain WHY tests: 12 principles translated from the \"12 Laws of the Universe\", each with a check. Use when a lacan-split WHY chain hits a dead end (no written anchor, two written rules conflict, no Other survives the edge cases, or someone wants to change a written IS_AT_LEAST_NOT). Also use to set a task's anchor (2-4 top WHYs) at the start, or as the GOAL and glossary for a goal-alignment-audit after the work. Not for plain ambiguity: ask the user instead."
---

# Highest WHY

Companion to `lacan-split`. That skill tests a claim; this one tests the WHY chain above it. Every IS_AT_LEAST_NOT carries a WHY, each WHY points to a higher WHY, and the chain has to stop somewhere. This skill defines where it stops and how to check that it stopped honestly.

Keep it out of ordinary runs. It is loaded only in the three modes below, and in mode 1 only the tests listed for the dead end are run, never all twelve.

## The Universe (the highest WHY)

The written set of first principles where every WHY chain ends. It is chosen, not found: there is no guarantee above it (in Lacan's terms, there is no Other of the Other), so it is stated openly and can be challenged. Each principle comes with a test, a way to see from the work itself whether the principle was broken. A principle with no test is a metaphor, not an anchor, and is never used to justify a step.

## This skill, split

- **IS:** the written top of every WHY chain: twelve chosen principles, each with a test, used only at a dead end, at the start of a task, or in a final audit.
- **IS_AT_LEAST:** a point where asking "why?" stops by agreement, and is written down.
- **IS_NOT:** a description of how the physical universe works. The source list is popular spirituality, not science (the line blurs at #7, which overlaps real causality).
- **IS_AT_LEAST_NOT:** never an authority invoked to win an argument or to guess what the user meant. Danger: any breach can be justified from above, and ambiguity gets settled by fiat instead of by asking. Used that way it is a shortcut for dogma (the Other of the Other) or for mind-reading. WHY: lacan-split's rule that a WHY chain must end at a written, checkable anchor.

## The twelve top WHYs

| # | Source law (popular claim) | Top WHY | Test | Fit |
|---|---|---|---|---|
| 1 | Divine Oneness: everything is connected | Nothing is defined alone; every claim lives among other claims | Are the neighbour (IS_NOT) and the Other named? | loose |
| 2 | Vibration: everything moves | Meaning drifts with context and time | Was the split checked against the current context, not the one it was written in? | loose |
| 3 | Correspondence: as above, so below | Rules agree across levels | Does any lower rule contradict a WHY above it? | close |
| 4 | Attraction: like attracts like | Hazard, not a law: you find what you look for (confirmation bias) | Did you search for a counterexample, not only for support? | inverted |
| 5 | Inspired Action | A named commitment has to be acted on | Was each written IS_AT_LEAST_NOT actually checked at each step? | loose |
| 6 | Perpetual Transmutation | Rules can change, but only openly | Is every change stated together with its reason? | loose |
| 7 | Cause and Effect | Every step has a cause; every rule has a WHY | Can the step be traced to its root cause, and the rule up to its anchor? | close |
| 8 | Compensation: you reap what you sow | Every breach has a cost | Is the danger (the cost) stated? | loose |
| 9 | Relativity | Meaning depends on what it is compared against | Is the frame named: who reads it, against what? | close |
| 10 | Polarity: everything has its opposite | Opposites sit on one scale | Is the opposite named, and the gap measured rather than assumed? | close |
| 11 | Rhythm: everything swings | Failures come back | Is this a known failure returning? | close |
| 12 | Gender: masculine and feminine in everything | Metaphor as stated. Structural reading: Lacan's two logics of a whole, a closed set with one exception vs. "not-all" | Before reading the gap, did you decide which logic the concept follows (near-zero gap vs. wide gap)? | metaphor |

Fit says how far the top WHY is from the source claim: **close** keeps its meaning, **loose** is a reading, **inverted** only works turned into a warning, **metaphor** survives only as a structural analogy. Four of these already live inside lacan-split under other names: #1 is naming the Other, #7 is the WHY chain, #9 is context, #10 is the IS/IS_NOT axis and the gap diagnostic.

## Mode 1: escalation at a dead end (during the work)

Load this skill only on one of these four events, and run only the tests listed for it:

| Dead end in lacan-split | Tests | Decision rule |
|---|---|---|
| A WHY has no written anchor | #7 | State the anchor you are assuming in one line, marked "assumed", and say which top WHY it falls under. If the IS_AT_LEAST_NOT can't be traced to it step by step, it is a preference, not a rule: move it to IS_NOT. Ask the user to confirm the anchor when they are present. |
| Two written rules conflict | #3, #7 | Check the conflict is real in the same frame. Trace both chains up. The rule whose chain reaches a written anchor wins. If both reach anchors, the anchors conflict: stop and ask the user. Never resolve it silently. |
| No candidate Other survives the edge cases | #1, #9, #10 | Name the neighbours, then the frame, then the opposite on the same scale; the Other often appears only once the frame is named. If nothing survives, say plainly that no absolute exclusion was found in this frame. An honest "none found" beats an invented Other. |
| A request to change a written IS_AT_LEAST_NOT | #6, #8 | Name which WHY above it changed. If none did, it is not a change, it is a breach being renamed: flag it and keep the rule. If one did, change the rule openly and state what the old rule protected that is now unprotected. |

One optional spot check: if a split came out too easily and every piece confirms the first reading, run #4 once.

Report each escalation in this shape:

```
Dead end: [which of the four]
Tests run: [#numbers]
Finding: [one or two sentences]
Decision: [what changes in the split, or the question for the user]
```

## Mode 2: set the anchor once (at the start of a task)

For a multi-step task, a deliverable, or anything prone to drift, write one anchor line before the work starts:

```
Goal: [the task's stated goal]
Top WHYs: [2-4 numbers from the table], because [one short reason]
```

Pick the 2-4 that matter for this task, not all twelve. From then on, each IS_AT_LEAST_NOT's WHY can cite the goal and a number instead of a full chain. Skip this for one-off definitions; an anchor line nobody needs is ritual, not rigor.

## Mode 3: full audit (after the work)

Optional: this mode needs the `goal-alignment-audit` skill, which is not part of this repo. If it isn't installed, skip mode 3 and say so; modes 1 and 2 work without it.

The only mode where all twelve run, and only once, over the finished output. Use the `goal-alignment-audit` skill and pass in:

- **GOAL:** "The deliverable is consistent with the Highest WHY principles" (all twelve, or the ones chosen in mode 2).
- **Glossary:** the table above; each principle's Test column is the check.

That audit never critiques its GOAL, which is the right stance here: the audit checks the work, not the principles. Its 5-Whys runs down to a root cause while lacan-split's WHY chain runs up to the anchor; #7 covers both directions.

## Changing this list

The list is chosen, so it can change, but only by #6: state what is added, removed, or reworded and why, and keep the test for every principle. A principle that loses its test drops to metaphor and stops being an anchor.

## Provenance

The "12 Laws of the Universe" are a modern list from popular spirituality; versions differ between authors, and about seven of them come from The Kybalion (1908). They are used here as source material and translated into checkable principles, not cited as laws of nature.