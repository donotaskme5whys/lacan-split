---
name: "lacan-split"
description: "Pin down a contested or fuzzy term, a requirement, a task's goal, or a claim someone relies on, with four lines: IS / IS_AT_LEAST / IS_NOT / IS_AT_LEAST_NOT (the danger zone, which never blurs). Use when the user asks for lacan-split or this four-line split by name; when a term or requirement keeps being read differently by people or by the model; when a claim (an ad, a spec figure, a promise) needs to be pinned to what it can and cannot be relied on; or, in a task whose goal has been split, to flag the moment the work drifts from that goal (e.g. a \"research\" prompt collapsing into \"analysis\"). Not for terms with a settled textbook definition or for routine comparisons nobody disputes."
---

# Lacan Split

A way to define what something IS without either overclaiming a crisp boundary it doesn't have, or leaving the definition too mushy to be useful. Most interesting categorization work involves concepts that are contested, fuzzy, or actively debated — this framework is built for that case, not for concepts that already have a textbook definition.

**Scope: a sign and the uses it licenses.** For a concept, a use means applying the term. For an utterance (an ad, a figure, a promise), a use means relying on it: the split marks what was expressed against what the listener had grounds to rely on at the time of deciding.

**Self-limit.** This skill IS_AT_LEAST_NOT a verdict on a person, and never legal advice. It shows where a claim may and may not be relied on; it does not decide whether someone lied, and "grounds to rely on" here is not a legal test. Used as a verdict, it stands in for evidence nobody gathered. WHY: every claim must be checkable.

## The four qualifiers, in this exact order

1. **IS** — the strongest defensible positive claim: the thing's defining characteristic.
2. **IS_AT_LEAST** — the weakest positive claim that still reliably holds: the floor guarantee, true even under the most conservative reading.
3. **IS_NOT** — the strongest defensible negative claim: the most likely real-world confusion, explicitly ruled out.
4. **IS_AT_LEAST_NOT** — the Other: the absolute exclusion, and the danger zone. It names the context where the thing must never be used or taken for, and says WHY: there it stops being itself and becomes a shortcut for something different (the Other), which should be named. The Other is in the text: naming it means naming the other term(s) the claim would be standing in for, and the conditions under which that substitution happens. This is the one boundary that never blurs.

Order matters: the affirmative pair first (strong, then weak), then the negative pair (strong, then weak) — one polarity flip, not four alternations.

The two negative claims are not equally hard. The line between IS and IS_NOT can blur in extreme cases, because IS_NOT is the nearest neighbor and neighbors overlap at the edges. The line at IS_AT_LEAST_NOT cannot blur at all. If an edge case can be found where the IS_AT_LEAST_NOT claim fails, it was the wrong claim: move it to IS_NOT and find the real Other. If no candidate survives, don't invent one: see highest-why. An edge case fails the claim only when the thing is still legitimately itself there. Someone deliberately using it in the forbidden way doesn't break the claim; that is the Other in action, and it confirms the claim (a Python list kept as a default argument on purpose is still a hidden cache).

Every IS_AT_LEAST_NOT entry carries four parts: the forbidden use or context, the danger of using it there, the Other it is standing in for, and the WHY, meaning the rule it protects. A bare negation ("not X") or a cost judgement ("probably not worth it") is not an IS_AT_LEAST_NOT.

Simple items are the exception. When the item is uncontested and no use of it is dangerous in the frame at hand, write "No danger zone in this frame" as its IS_AT_LEAST_NOT and move on: don't invent an Other to fill the slot, and don't escalate to highest-why. Keep this shortcut for items you would call simple anyway; if the item is contested, or the shortcut is tempting only because the Other is hard to find, escalate instead.

### The WHY chain

The WHY of an IS_AT_LEAST_NOT points to a higher WHY, and that one points to another. The chain must end at a written anchor: the task's stated goal, a principle named in the conversation or the docs, or an explicit instruction from the user. It must never end at an unwritten authority ("obviously", "everyone knows", "best practice", "the nature of things"). A chain with nothing checkable at the top can justify any breach, and at that point it is a shortcut for dogma. If no written anchor exists, say so, and either ask for one or state the anchor you are assuming so it can be challenged.

If the chain hits a dead end (no written anchor, two written rules in conflict, no Other that survives the edge cases, or a request to change a written IS_AT_LEAST_NOT), load the highest-why skill and run only the tests it lists for that dead end. Don't load it for plain ambiguity: ask the user instead.

### Naming is a commitment

Writing an IS_AT_LEAST_NOT makes the invisible visible, and from that moment it binds the rest of the task. Like a mark left over an erased trace, it keeps the excluded use on the record, so a later crossing can't pass as an accident. This is what prevents faking the faking. It also means there are two different failures, handled differently:

- **While writing the split:** if an edge case breaks the IS_AT_LEAST_NOT, the claim was wrong. Move it to IS_NOT and find the real Other, or, if none survives, say so (see highest-why).
- **While doing the task:** if an output, step, or conclusion crosses a written IS_AT_LEAST_NOT, the rule is not what's wrong; the work is. Stop and flag it immediately, naming which IS_AT_LEAST_NOT was crossed and which WHY it protects. Don't rewrite the rule after the fact to make the work pass: that is editing the failed test instead of fixing the code. Change a written IS_AT_LEAST_NOT only when the WHY above it changes, and say so openly when you do.
- **After a breach:** a statement that the crossing "won't happen again" does not restore the line. The breach stays on the record, like the cross over the erased trace. What can be written is a new commitment, stated as new, with the breach named. Accepting a promise as a restoration turns the IS_AT_LEAST_NOT into a line that blurs, and a line that blurs is not an IS_AT_LEAST_NOT: the Other has quietly been removed.

## Framing flags (check first)

Before writing any claim, check that the input can be split at all. Raise these flags at the top of the output, before the split. Raise them only when found; when none applies, say nothing.

- **Frame missing**: the item states a figure, rating, or claim whose meaning depends on conditions it does not give (test protocol, conditions, population, time window, who measured). Name what is missing. Then either split under an assumed frame, marked "assumed", or stop if no frame is reasonable. Never silently pick a reading: a sentence cut before its quilting point has no IS yet. Example: "EV-mode range: 98 km" with no protocol, temperature, or speed.
- **Modality mismatch**: the item claims a stronger modality than its grounds allow: a forecast or promise worded as a guarantee or an impossibility ("never", "always", "guaranteed"). Name the modality claimed and the one the grounds support. Example: "It will never happen again" after it happened: the event made it contingent; the sentence claims it is impossible; it can only be a promise.
- **Internal contradiction**: one source states claims about the same thing that cannot all stand, and does not say which one replaces which. The typical pattern: claim A early on, claim B later contradicts it, then claim C shifts the implication so A and B no longer matter, and so on. The text keeps re-quilting its meaning and never settles. List the claims in order of appearance, with where each appears and its status:

  | # | Claim | Where | Relation to earlier claims | Status |
  |---|---|---|---|---|
  | A | ... | ... | first | contradicted by B / superseded by C / standing |

  Status is one of: **standing**, **contradicted** (a later claim conflicts and the text leaves both), **superseded** (a later claim makes it redundant or changes its implication). Then say which claim, if any, the text finally rests on. Split only that claim; if none clearly wins, split nothing and ask which one is meant. Example: a car page gives "EV range: 98 km" in a spec block and "66–93 km" in its benefits section.
  Not a flag (the nearest neighbour): a text that states A in order to correct it and marks the correction ("contrary to popular belief", "this was revised"). That is argument, not contradiction. The danger is the unmarked case: a reader, or a retriever pulling one chunk, takes A in isolation as the source's position.

Read what the words claim first. Ask about intention (why that word is there) second, and only if it is needed.

## Method: modal-boundary-first

Don't start by writing IS. Write the two floor claims first and tighten inward from there:

1. Write **IS_AT_LEAST** first. This is the claim you'd still defend if someone pushed back hard on it — usually the easiest of the four to state with confidence, because it doesn't require settling every edge case.
2. Write **IS_AT_LEAST_NOT** next — the Other: what the thing must never be used as, no matter how generously the concept gets read. State the danger, name what it would really be a shortcut for, and give the WHY it protects, traced up to a written anchor. Test it against extreme cases; it must hold in all of them.
3. Now tighten inward on the positive side: within the band bounded by those two floor claims, what's the strongest version of the positive claim still defensible? That's **IS**.
4. Do the same on the negative side for **IS_NOT** — the sharpest exclusion you can still defend, not just the safest one. Where possible, anchor it against the item's nearest real-world neighbor (the thing people actually confuse it with), not a generic negation.

Why start from the floor and not the ceiling: for a fuzzy or contested concept, writing IS first tempts you into committing to a crisp boundary before checking whether it holds. Starting from what's solid and only then stretching toward the strongest defensible claim keeps IS and IS_NOT honest. For genuinely simple, uncontested concepts, the four claims may end up close together (IS ≈ IS_AT_LEAST) — that's fine; don't manufacture daylight between them that isn't real.

## Output format

For a comparison across several items, one row per item, columns in the canonical order:

| Item | IS | IS_AT_LEAST | IS_NOT | IS_AT_LEAST_NOT | Gap |
|---|---|---|---|---|---|

The Gap column is required: one word, **near-zero**, **narrow** or **wide** (see "Reading the gap"). It comes after the four qualifiers, so their canonical order is unchanged.

For a single item needing a precise definition, use the same four as a short labeled list, same order, followed by a fifth line: **Gap:** near-zero, narrow or wide.

## Worked example

| Concept | IS | IS_AT_LEAST | IS_NOT | IS_AT_LEAST_NOT | Gap |
|---|---|---|---|---|---|
| Cache | A store that keeps a copy of data to avoid repeating an expensive fetch or computation | At minimum, has some eviction or invalidation logic — you can't cache without deciding when data goes stale | Not a buffer — it exists to avoid repeated work, not to smooth a rate mismatch (the line can blur, e.g. a write-behind cache) | Never the only copy of the data. Danger: losing or evicting it loses data. Used that way it is a shortcut for a system of record (the Other), without durability. WHY: accepted data must survive the loss of any single component | narrow |
| Buffer | A temporary holding area that smooths a mismatch in rate or timing between producer and consumer | At minimum, has a bounded capacity that fills and drains | Not a cache — it is not about avoiding recomputation (the line can blur, e.g. a read-ahead buffer) | Never a place where data is kept until someone needs it later. Danger: overflow or a crash silently drops it. Used that way it is a shortcut for durable storage or a persistent queue (the Other). WHY: anything accepted must be delivered or explicitly rejected, never silently lost | narrow |

## Reading the gap: a fuzziness diagnostic

The width between IS and IS_AT_LEAST isn't just scaffolding to discard once you've tightened inward — it's a measurement, and it belongs in the output, not just in your own reasoning. In the output it is the one-word Gap column. Explain it in prose only when it is wide.

- **Near-zero gap** (IS ≈ IS_AT_LEAST): the concept's meaning is fixed by a formal or structural role rather than drawn from a usage range — logic constants (`True`/`False`), defined technical terms, enum values, anything whose meaning comes from its place in a system rather than from how people actually use it. The word near-zero in the Gap column says this on its own, with no prose: it tells the reader the concept doesn't need hedging.
- **Narrow gap**: a defined or well-settled term with some usage range at the edges. The word narrow is enough; no prose.
- **Wide gap**: signals genuine range — competing senses pulling in different directions (synonymy), disjoint senses that need context to disambiguate (homonymy), or ordinary boundary blur from usage drift and grammatical looseness. The wider the gap, the more the item resists a single clean definition, and that resistance is itself worth stating plainly rather than papering over with a tidier-looking IS. This is the only gap that gets prose: below the table, one or two sentences per wide item, naming the competing senses.

Don't narrow the gap artificially just to make the output look cleaner. Now that the word decides how much gets written, never call a gap narrow to avoid explaining it. If you're unsure between narrow and wide, it's wide. If IS and IS_AT_LEAST genuinely differ, that difference is the finding — flag it, don't hide it.

The gap is measured on the positive pair only. The negative pair is not a width: IS_NOT may blur toward IS at the extremes (say so when it does), while IS_AT_LEAST_NOT is absolute and is never hedged.

## Secondary use: flagging task drift

The same split applies to a task or prompt itself, treating its stated goal as the thing being defined:

- **IS**: what the task is actually asking for, on its literal framing.
- **IS_AT_LEAST**: the minimum scope you're confident the task covers.
- **IS_NOT**: the goal it's most at risk of quietly being pulled toward (classic case: an open-ended "research" prompt smuggling in a convergent "analysis" goal).
- **IS_AT_LEAST_NOT**: the Other — what the task must never turn into, however far the framing gets stretched, with the danger named: at that point it is a different task being done under this one's name. Its WHY is the task's stated goal. Once written, it is binding for the whole run (see "Naming is a commitment").

When a running task looks like it's sliding from its IS toward its IS_NOT, say so immediately and explicitly, in the moment — don't wait to be asked, and don't just silently switch framing without naming what happened. Sliding toward IS_NOT is drift: flag it. Crossing IS_AT_LEAST_NOT is a breach: stop the work at that point and flag it before going on.