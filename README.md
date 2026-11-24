# lacan-split

Two Claude Skills for pinning down things that don't define cleanly: contested terms, requirements that people and models read differently, claims someone relies on, and the goal of a task that keeps drifting.

- **`lacan-split`** splits a sign into four claims: **IS / IS_AT_LEAST / IS_NOT / IS_AT_LEAST_NOT**.
- **`highest-why`** (companion) says where the chain of "why?" behind each rule has to stop, and how to check that it stopped honestly.

## Scope: a sign and the uses it licenses

One semantics covers everything the skill does.

- For a **concept** ("cache", "research"), a use means *applying the term*.
- For an **utterance** (an ad, a spec figure, a promise), a use means *relying on it*. The split marks what was expressed against what the listener had grounds to rely on at the time of deciding.

## The four claims

| Claim | Meaning | Can it blur? |
|---|---|---|
| **IS** | The strongest positive claim you can defend | — |
| **IS_AT_LEAST** | The floor: true under the most conservative reading | — |
| **IS_NOT** | The nearest real confusion, ruled out | Yes, at the edges (neighbours overlap) |
| **IS_AT_LEAST_NOT** | **The Other**: where the thing must never be used, the danger, what it would stand in for there, and WHY | **Never** |

**Method: floor first.** Write IS_AT_LEAST, then IS_AT_LEAST_NOT, then tighten inward to IS and IS_NOT. Starting from IS tempts you to commit to a crisp boundary before checking that it holds.

## Framing flags: checked before any split

Some inputs can't be split as they stand. The skill raises these flags at the top of its output, only when it finds them.

| Flag | What it catches | Example |
|---|---|---|
| **Frame missing** | A figure or claim whose meaning depends on conditions it doesn't give: protocol, conditions, population, time window, who measured | "EV-mode range: 98 km" with no test cycle, temperature or speed. The skill names what's missing and splits under an assumed frame, marked *assumed*, or stops |
| **Modality mismatch** | A forecast or promise worded as a guarantee or an impossibility ("never", "always", "guaranteed") | "It will never happen again", after it happened: the event made it contingent, the sentence claims it is impossible, and it can only be a promise |
| **Internal contradiction** | One source states claims about the same thing that can't all stand, and doesn't say which replaces which | A car page gives "EV range: 98 km" in its spec block and "66–93 km" in its benefits section. The skill lists the claims in order, with a status for each, and splits only the one the text rests on, or asks |

A text that states a claim in order to correct it, and marks the correction ("contrary to popular belief"), is argument, not contradiction.

## Three rules that do the work

1. **The danger line never blurs.** If an edge case breaks an IS_AT_LEAST_NOT while the thing is still legitimately itself, it was only a neighbour: move it to IS_NOT and find the real Other. If nothing survives, say so. Don't invent one. Someone deliberately using the thing in the forbidden way doesn't break the line; that is the Other in action.
2. **Every danger line has four parts:** the forbidden use, the danger, the Other it stands in for, and the WHY it protects. "Not X" on its own doesn't count.
3. **Naming is a commitment.** Once written, an IS_AT_LEAST_NOT binds the rest of the task. If a later output crosses it, the work is wrong, not the rule: stop and flag it. It works like a failing test: you fix the code, not the assertion.

**After a breach**, a promise that it "won't happen again" doesn't restore the line. The breach stays on the record. What can be written is a new commitment, stated as new, with the breach named.

Two more uses come with it:
- **Gap diagnostic.** The distance between IS and IS_AT_LEAST is reported as *near-zero* (a formal term), *narrow* (a settled term) or *wide* (real polysemy, explained in a sentence). If you're unsure, it's wide.
- **Drift flagging.** The same split applied to a task's own goal. When a "research" prompt starts collapsing into "analysis", the skill says so on the spot.

## Examples

A concept:

| Concept | IS | IS_AT_LEAST | IS_NOT | IS_AT_LEAST_NOT | Gap |
|---|---|---|---|---|---|
| Cache | A copy of data kept to avoid repeating an expensive fetch | Has some eviction or invalidation logic | Not a buffer: it avoids repeated work rather than smoothing rate (blurs at write-behind) | Never the only copy. Danger: eviction loses data. There it stands in for a **system of record**, without durability. WHY: accepted data must survive the loss of any one component | narrow |

Four everyday claims (utterances, so a use means relying on them):

| Claim | IS | IS_AT_LEAST | IS_NOT | IS_AT_LEAST_NOT | Gap |
|---|---|---|---|---|---|
| A coach's ad: "You'll lose X kg in a month" | A sales promise: a best case presented as the typical result | Someone, somewhere, once got that result | What will happen to *you* (blurs: some people do get it) | Never a target to plan your health around. Danger: chasing the number pushes you towards unsafe restriction. There it stands in for **medical advice** from someone who knows your case. WHY: health decisions need someone accountable | wide |
| An adviser's ad: "You can multiply your investments" | A best case or a back-tested past, presented as the future | It happened for someone, in some period | An expected return (blurs: in a strong market it can come true for a while) | Never a guarantee to put money behind that you can't afford to lose. Danger: losses, and "guaranteed high returns" is a classic sign of fraud. There it stands in for a **guarantee** nobody can give. WHY: every return is paid for with risk | wide |
| A partner who broke an agreement: "It was just once. It will never happen again" | A claim about the past plus a promise about the future | An admission that it happened, and a wish to stay | Proof that it was once (blurs: sometimes it really was once) | Never a substitute for trust you can check over time. Danger: you stop looking at behaviour because a sentence closed the case. There it stands in for **rebuilt trust**, which only actions over time provide. WHY: trust follows actions, not statements | wide |
| A car page: "EV-mode range: 98 km" | A test-cycle figure. Assumed frame: the WLTP *city* cycle, which the page doesn't name (the car's WLTP combined figure is about 69–76 km) | A fair way to compare cars measured the same way | The distance you'll drive on a cold motorway (blurs: mild city driving can match it) | Never a plan with no margin: an all-electric commute, a fuel budget, a company-car calculation. Danger: in winter or at speed the engine starts and the plan's numbers break. There it stands in for **your real-world range**. WHY: plan on what you measured, not on what was tested elsewhere | narrow |

Framing flags raised first: the coach (frame missing, modality mismatch), the adviser (frame missing), the partner (modality mismatch), the car page (frame missing, internal contradiction).

None of these rows says the claim is false. Each says where acting on it *as if it were true* would cost you, and what you'd really be relying on there.

## What it will not do

lacan-split IS_AT_LEAST_NOT a verdict on a person, and never legal advice. It shows where a claim may and may not be relied on. It doesn't know whether your partner is lying or whether your coach is good, and "grounds to rely on" here is not a legal test. Used as a verdict, it stands in for evidence nobody gathered. It shows you where to look; you still have to do the looking.

## highest-why: where the WHYs stop

Each WHY points to a higher WHY. In `lacan-split` the chain must end at a **written anchor** (the task's goal, a stated principle, an instruction, an explicit agreement), never at "obviously", "best practice" or "everyone knows". A chain with an unchecked top can justify any breach.

`highest-why` is that written top: twelve chosen principles, each with a **test** you can run on the work. A principle with no test counts as a metaphor and is never used to justify a step. It loads only in three cases:

1. **Dead end** (no anchor, two rules in conflict, no Other survives, or a request to change a written rule). It runs only the tests for that case.
2. **Anchor at the start.** It picks 2–4 top WHYs for a long task.
3. **Final audit** (optional). All twelve run once over the finished output. This mode needs a `goal-alignment-audit` skill, which is not in this repo; without it, modes 1 and 2 still work.

*Provenance:* the twelve are translated from the popular "12 Laws of the Universe" list (about seven trace to *The Kybalion*, 1908). They are source material, not science, and each translation is labelled *close*, *loose*, *inverted* or *metaphor*.

## The Lean model (`examples/LacanSplit.lean`)

A Lean 4 file (core only, no Mathlib) that formalizes the skill's rules and runs them on the four everyday claims above.

- **IS:** a formal model of the rules: floor first, a danger line that never blurs, the move of a broken Other to IS_NOT, WHY chains that can only end at a written anchor, a monitor that stops at the first breach, and the two directions of reliance (the speaker answers for what they said *and* what they invited; the listener can safely rely on no more than the speaker's grounds carry).
- **IS_NOT:** a proof that the skill is useful. That is an empirical claim and needs evals.
- **IS_AT_LEAST_NOT:** never a proof that the skill's answers about the world are true. Lean can't know whether a coach is good.

Every theorem is labelled in its docstring, so you can see what kind of claim it is. Of the 48: **19** *content* (the proof does real work), **21** *check* (a computation on the case data), **7** *by construction* (true because of how a definition was chosen; they check the encoding, not a finding) and **1** *metaphor* (Cantor's diagonal read as "no Other of the Other").

To check it, install [elan](https://github.com/leanprover/elan), then run from `examples/`:

```
lean LacanSplit.lean
```

The `lean-toolchain` file pins Lean 4.19.0. No output means every proof checked.

## Why "Lacan"

The structure borrows from Jacques Lacan. It is not a summary of his work.
- **The footprint.** A trace proves *someone* was here, not what they meant. Animals can lay false tracks. Only a subject erases a trace and marks the erasure. The written IS_AT_LEAST_NOT is that mark.
- **The quilting point.** Meaning gets pinned after the fact, so the method fixes the two outer boundaries first. A sentence cut before its quilting point (a figure with no frame) has no IS yet.
- **The modal formulas (*Encore*).** IS_AT_LEAST ≈ the necessary, IS_AT_LEAST_NOT ≈ the impossible, IS ≈ the possible, IS_NOT ≈ the contingent.
- **"There is no Other of the Other."** Nothing in discourse can guarantee discourse, so the top of the WHY chain is *chosen and written*, not found.

These are deliberate departures. Lacan's Other is the place of language, not one excluded meaning, and his bar splits the subject, not the statement. You don't need any Lacan to use the skill.

## lacan-split, split

- **IS:** a four-claim template and method for pinning down contested concepts, relied-on claims and task goals, with framing flags first and a binding danger line.
- **IS_AT_LEAST:** a checklist that makes you name the nearest confusion and one forbidden use.
- **IS_NOT:** an exposition of Lacan (this blurs: it borrows his images on purpose).
- **IS_AT_LEAST_NOT:** never a way to make a definition *look* rigorous, and never a verdict. Danger: four tidy columns as decoration, with no WHY traced to a written anchor. There it stands in for **authority-by-format**, which is dogma. WHY: every claim must be checkable.
- **Gap:** narrow.

## Install

- **Claude Code:** copy `lacan-split/` and `highest-why/` into `~/.claude/skills/`.
- **Claude apps:** zip each folder and upload it as a custom skill.

`lacan-split` works on its own.

## Repo layout

```
lacan-split/SKILL.md     the skill
highest-why/SKILL.md     the companion skill
examples/LacanSplit.lean the Lean model and the four cases
examples/lean-toolchain  pins Lean 4.19.0
README.md
LICENSE                  MIT
```

## License

MIT. See `LICENSE`.
