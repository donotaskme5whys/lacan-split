/-!
# lacan-split in Lean 4: a model and four everyday cases

Lean 4.19.0, core only (no Mathlib). Check it with: `lean LacanSplit.lean`

## What this file is, split

- **IS:** a formal model of the skill's rules (floor first, a danger line that never
  blurs, the move of a broken Other to IS_NOT, WHY chains that end at a written anchor,
  a breach that stays on the record), applied to four everyday cases.
- **IS_AT_LEAST:** an exact statement of what the skill assumes. Every structure field
  below is an assumption you can read.
- **IS_NOT:** a proof that the four lines are a good way to define things. That is an
  empirical claim, and it needs evals, not proofs.
- **IS_AT_LEAST_NOT:** never a proof that the skill's answers about the world are true.
  Lean cannot know whether a coach is good or a partner is honest. Used that way, a
  proof stands in for evidence nobody gathered. WHY: every claim must be checkable.

## How to read the theorems

Each docstring carries one label:
- **[content]**: the proof does real work (an induction, a case analysis, a contradiction).
- **[by construction]**: true because of how a definition was chosen. It checks the
  encoding. It is not a finding.
- **[check]**: a computation on concrete data, decided by evaluation.
- **[metaphor]**: a formal analogue of one of Lacan's images. It illustrates; it does
  not establish anything about Lacan.

## Scope

One semantics: *a sign and the uses it licenses*. For a concept, a use means applying
the term. For an utterance, a use means relying on it. The cases are utterances, so a
`Use` below is one way a listener can rely on what was said, judged at the time of
the decision.

The cases:
- A coach's ad: "You'll lose X kg in a month." No limitations; the coach is not a
  medical adviser.
- An adviser's ad: "You can multiply your investments." No limitations.
- A partner who cheated: "It was just once. It will never happen again." There was an
  agreement, so the cheating stands as a breach.
- A car page (lexus-polska.pl/electrified/plug-in-hybrid, read 2026-11-24): "EV-mode
  range: 98 km", with no test protocol or conditions. The same page gives "66–93 km"
  in its benefits section.

The first three are hypothetical. The fourth quotes a real page.
-/
set_option warningAsError true

namespace LacanSplit

/-! # Part 1. The set model: the danger line never meets the thing -/

namespace SetModel

/-- A claim is a predicate over contexts (readings, uses, situations). -/
abbrev Claim (α : Type) := α → Prop

structure Split (α : Type) where
  is           : Claim α
  isAtLeast    : Claim α
  isNot        : Claim α
  isAtLeastNot : Claim α
  /-- IS tightens inward from the floor. -/
  floor : ∀ x, is x → isAtLeast x
  /-- The Other never meets the thing, even at its most generous reading. -/
  never : ∀ x, isAtLeast x → ¬ isAtLeastNot x
  -- Deliberately no axiom relating `is` and `isNot`: that line may blur.

/-- [by construction] No IS context is a danger context: `floor` then `never`. -/
theorem is_never_danger {α} (s : Split α) : ∀ x, s.is x → ¬ s.isAtLeastNot x :=
  fun x h => s.never x (s.floor x h)

/-- A split where IS and IS_NOT overlap is still valid: the blur is allowed. -/
def blurExample : Split Bool where
  is := fun _ => True
  isAtLeast := fun _ => True
  isNot := fun _ => True
  isAtLeastNot := fun _ => False
  floor := fun _ h => h
  never := fun _ _ h => h

/-- [check] The axioms permit an IS/IS_NOT overlap. -/
theorem blur_is_permitted : ∃ s : Split Bool, ∃ x, s.is x ∧ s.isNot x :=
  ⟨blurExample, true, trivial, trivial⟩

/-- Repair rule: a candidate Other broken by an edge case moves to IS_NOT, and the
    danger line is redrawn outside the thing. The result is a valid split. -/
def repair {α} (is isAtLeast : Claim α) (floor : ∀ x, is x → isAtLeast x)
    (candidate : Claim α) : Split α where
  is := is
  isAtLeast := isAtLeast
  isNot := candidate
  isAtLeastNot := fun x => candidate x ∧ ¬ isAtLeast x
  floor := floor
  never := fun _ h hd => hd.2 h

/-- [content] The edge case that broke the candidate ends up in IS_NOT, never in the
    danger zone. -/
theorem edge_case_moves {α} (is isAtLeast : Claim α) (floor : ∀ x, is x → isAtLeast x)
    (candidate : Claim α) (x : α) (hc : candidate x) (hx : isAtLeast x) :
    (repair is isAtLeast floor candidate).isNot x ∧
    ¬ (repair is isAtLeast floor candidate).isAtLeastNot x :=
  ⟨hc, fun hd => hd.2 hx⟩

/-- The gap diagnostic: contexts that are at least the thing, but not the thing. -/
def gap {α} (s : Split α) : Claim α := fun x => s.isAtLeast x ∧ ¬ s.is x

/-- Near-zero gap: IS and IS_AT_LEAST coincide (a formal term). -/
def NearZeroGap {α} (s : Split α) : Prop := ∀ x, ¬ gap s x

end SetModel

/-! # Part 2. A Kripke model of the four modalities of *Encore*

Worlds are readings of a claim; `R w v` means "from reading `w`, the listener can
reach reading `v`".
- IS_AT_LEAST ≈ necessary (does not cease to be written)
- IS_AT_LEAST_NOT ≈ impossible (does not cease not to be written)
- IS ≈ possible, IS_NOT ≈ contingent: the two that "cease", so the two that can blur.

These are standard facts of modal logic. The mapping to Lacan is the reading. -/

namespace Modal

structure Frame where
  W : Type
  R : W → W → Prop
  /-- Every reading reaches at least one reading: someone was here. -/
  serial : ∀ w, ∃ v, R w v

def Nec (F : Frame) (p : F.W → Prop) (w : F.W) : Prop := ∀ v, F.R w v → p v
def Poss (F : Frame) (p : F.W → Prop) (w : F.W) : Prop := ∃ v, F.R w v ∧ p v
def Impossible (F : Frame) (p : F.W → Prop) (w : F.W) : Prop := Nec F (fun v => ¬ p v) w
def Contingent (F : Frame) (p : F.W → Prop) (w : F.W) : Prop :=
  Poss F p w ∧ Poss F (fun v => ¬ p v) w

variable {F : Frame} {p : F.W → Prop} {w : F.W}

/-- [content] The floor is never empty: in a serial frame, necessary implies possible. -/
theorem nec_poss (h : Nec F p w) : Poss F p w :=
  let ⟨v, hv⟩ := F.serial w
  ⟨v, hv, h v hv⟩

/-- [content] IS_AT_LEAST_NOT is exactly "no reachable reading allows it". -/
theorem impossible_iff_not_poss : Impossible F p w ↔ ¬ Poss F p w :=
  ⟨fun h ⟨v, hv, hp⟩ => h v hv hp, fun h v hv hp => h ⟨v, hv, hp⟩⟩

/-- [content] One reachable counter-reading breaks an IS_AT_LEAST_NOT: it was only a
    neighbour, so it moves to IS_NOT. -/
theorem witness_breaks_impossible {v : F.W} (hv : F.R w v) (hp : p v) :
    ¬ Impossible F p w :=
  fun h => h v hv hp

/-- [content] The floor and the danger line can never be the same claim. -/
theorem floor_not_danger (hn : Nec F p w) (hi : Impossible F p w) : False :=
  let ⟨v, hv⟩ := F.serial w
  hi v hv (hn v hv)

/-- [content] Blur lives only in the modalities that "cease": a contingent claim is
    neither necessary nor impossible. -/
theorem contingent_blurs (h : Contingent F p w) : ¬ Nec F p w ∧ ¬ Impossible F p w :=
  let ⟨⟨v, hv, hp⟩, ⟨u, hu, hnp⟩⟩ := h
  ⟨fun hn => hnp (hn u hu), fun hi => hi v hv hp⟩

end Modal

/-! # Part 3. Where the WHYs stop -/

namespace Regress

/-- `Reaches above r a`: following WHYs upward from rule `r` reaches `a`. -/
inductive Reaches {R : Type} (above : R → R → Prop) : R → R → Prop
  | refl (r : R) : Reaches above r r
  | step {r r' a : R} : above r' r → Reaches above r' a → Reaches above r a

/-- [content] If every rule is a written anchor or has a WHY above it, and you cannot
    climb forever, then every rule reaches a written anchor. Drop `wf` and it fails:
    an infinite regress never reaches "written". -/
theorem reaches_anchor {R : Type} (above : R → R → Prop) (wf : WellFounded above)
    (written : R → Prop) (stepOrAnchor : ∀ r, written r ∨ ∃ r', above r' r) :
    ∀ r, ∃ a, written a ∧ Reaches above r a := by
  intro r
  exact wf.induction (C := fun r => ∃ a, written a ∧ Reaches above r a) r
    (fun r ih => by
      cases stepOrAnchor r with
      | inl hw => exact ⟨r, hw, Reaches.refl r⟩
      | inr h =>
        obtain ⟨r', hr'⟩ := h
        obtain ⟨a, ha, hreach⟩ := ih r' hr'
        exact ⟨a, ha, Reaches.step hr' hreach⟩)

/-- [metaphor] "There is no Other of the Other", read through Cantor's diagonal: no map
    from signifiers to meanings covers every meaning. Whatever guarantor you pick,
    some meaning escapes it, so the top of the chain is chosen and written, not found.
    The theorem is Cantor's; the reading is ours. -/
theorem no_other_of_the_other {α : Type} (guarantor : α → (α → Prop)) :
    ∃ m : α → Prop, ∀ a, guarantor a ≠ m := by
  refine ⟨fun x => ¬ guarantor x x, fun a h => ?_⟩
  have e : guarantor a a = ¬ guarantor a a := congrFun h a
  have hn : ¬ guarantor a a := fun hq => (Eq.mp e hq) hq
  exact hn (Eq.mpr e hn)

/-- A written IS_AT_LEAST_NOT, used as a monitor over a run's outputs. -/
def flags {Out : Type} (danger : Out → Prop) [DecidablePred danger]
    (trace : List Out) : List Out :=
  trace.filter (fun o => decide (danger o))

/-- [by construction] Every crossing is flagged: this is what `List.filter` does. The
    point is that the line must be *written* (a decidable predicate) before it can
    monitor anything. -/
theorem crossing_flagged {Out : Type} (danger : Out → Prop) [DecidablePred danger]
    (trace : List Out) (x : Out) (hm : x ∈ trace) (hd : danger x) :
    x ∈ flags danger trace := by
  simp [flags, List.mem_filter, hm, hd]

end Regress

/-! # Part 4. Claims, reliance and written boundaries -/

namespace Claims

/-- The WHYs the four cases cite. -/
inductive Why where
  | healthAssessment | returnRisk | trustFollowsActions | measuredConditions
  | warrantedReliance | agreement
  deriving DecidableEq, Repr

def Why.text : Why → String
  | .healthAssessment => "Health decisions need someone accountable who knows your case."
  | .returnRisk => "Every return is paid for with risk."
  | .trustFollowsActions => "Trust follows actions over time, not statements."
  | .measuredConditions => "Plan on what you measured, not on what was tested elsewhere."
  | .warrantedReliance =>
      "Rely only on what the evidence available at the time of deciding supports."
  | .agreement => "What the partners agreed is the line."

/-- The written anchors this model accepts: the task's stated goal, and an explicit
    agreement. Nothing else may sit at the top of a chain. -/
inductive IsAnchor : Why → Prop where
  | goal : IsAnchor .warrantedReliance
  | agreed : IsAnchor .agreement

/-- The named links accepted in this model. -/
inductive WhyLink : Why → Why → Prop where
  | health : WhyLink .healthAssessment .warrantedReliance
  | investment : WhyLink .returnRisk .warrantedReliance
  | partner : WhyLink .trustFollowsActions .warrantedReliance
  | ev : WhyLink .measuredConditions .warrantedReliance

/-- The cited chain. It can only stop at a written anchor. -/
inductive WhyChain : Why → Why → Type where
  | anchor {w : Why} (written : IsAnchor w) : WhyChain w w
  | step {w next root : Why} : WhyLink w next → WhyChain next root → WhyChain w root

/-- [content] Every chain ends at a written anchor. -/
theorem chain_top_is_anchor : {w a : Why} → WhyChain w a → IsAnchor a
  | _, _, .anchor h => h
  | _, _, .step _ rest => chain_top_is_anchor rest

/-- [content] A chain whose top is unwritten cannot be built. -/
theorem unwritten_top_rejected {w a : Why} (h : ¬ IsAnchor a) : WhyChain w a → False :=
  fun c => h (chain_top_is_anchor c)

/-- [check] The old loophole is closed: a rule's own WHY cannot anchor itself. -/
theorem no_self_anchor : WhyChain .healthAssessment .healthAssessment → False :=
  unwritten_top_rejected (fun h => nomatch h)

/-- The positive side of a split over uses. The danger line lives in `Draft.crosses`. -/
structure Split (Use : Type) where
  is : Use → Prop
  isAtLeast : Use → Prop
  isNot : Use → Prop
  floor : ∀ u, is u → isAtLeast u

/-- A candidate IS_AT_LEAST_NOT, with its four required parts. -/
structure Draft (Use : Type) where
  claim : String
  forbiddenUse : String
  danger : String
  other : String
  why : Why
  crosses : Use → Bool

/-- An edge case where the thing is still legitimately itself, yet the draft forbids it. -/
def Draft.Counterexample (draft : Draft Use) (split : Split Use) : Prop :=
  ∃ u, split.isAtLeast u ∧ draft.crosses u = true

/-- A written, checked IS_AT_LEAST_NOT: its WHY chain ends at a written anchor, and it
    forbids no legitimate use. -/
structure CommittedBoundary (Use : Type) (anchor : Why) where
  split : Split Use
  rule : Draft Use
  citedWhy : WhyChain rule.why anchor
  excludesLegitimateUse : ∀ u, split.isAtLeast u → rule.crosses u = false

/-- [content] A committed boundary always has a written anchor. -/
theorem CommittedBoundary.anchor_written (b : CommittedBoundary Use anchor) :
    IsAnchor anchor :=
  chain_top_is_anchor b.citedWhy

/-- The link to Part 1: every committed boundary is a valid four-line split, with the
    crossed uses as IS_AT_LEAST_NOT. -/
def CommittedBoundary.toSetModel (b : CommittedBoundary Use anchor) :
    SetModel.Split Use where
  is := b.split.is
  isAtLeast := b.split.isAtLeast
  isNot := b.split.isNot
  isAtLeastNot := fun u => b.rule.crosses u = true
  floor := b.split.floor
  never := fun u h hc => by
    rw [b.excludesLegitimateUse u h] at hc
    contradiction

/-- The nearest confusion is not the Other: some IS_NOT use is not crossed. -/
def CommittedBoundary.NeighbourIsNotOther (b : CommittedBoundary Use anchor) : Prop :=
  ∃ u, b.split.isNot u ∧ b.rule.crosses u = false

/-- [content] A counterexample blocks the commitment: the draft must move to IS_NOT. -/
theorem counterexample_blocks_commitment
    (split : Split Use) (draft : Draft Use) (counter : draft.Counterexample split) :
    ¬ (∀ u, split.isAtLeast u → draft.crosses u = false) := by
  intro excludes
  obtain ⟨u, legitimate, forbidden⟩ := counter
  rw [excludes u legitimate] at forbidden
  contradiction

/-- [content] Using the thing as IS is never a breach (via Part 1). -/
theorem is_never_a_breach (b : CommittedBoundary Use anchor) (u : Use)
    (legitimate : b.split.is u) : b.rule.crosses u = false := by
  have h := SetModel.is_never_danger b.toSetModel u legitimate
  cases hc : b.rule.crosses u
  · rfl
  · exact absurd hc h

structure Breach (Use : Type) where
  use : Use
  forbiddenUse : String
  danger : String
  other : String
  protectedWhy : Why
  anchor : Why
  deriving Repr

def CommittedBoundary.report (b : CommittedBoundary Use anchor) (u : Use) : Breach Use :=
  ⟨u, b.rule.forbiddenUse, b.rule.danger, b.rule.other, b.rule.why, anchor⟩

/-- Walk a run's steps and stop at the first crossing. -/
def CommittedBoundary.firstBreach (b : CommittedBoundary Use anchor) :
    List Use → Option (Breach Use)
  | [] => none
  | u :: rest =>
      if b.rule.crosses u then some (b.report u) else b.firstBreach rest

/-- [content] The monitor stops at the first breach, whatever comes after it. -/
theorem stops_at_first_breach (b : CommittedBoundary Use anchor)
    (earlier : List Use) (u : Use) (later : List Use)
    (safe : ∀ v, v ∈ earlier → b.rule.crosses v = false)
    (breached : b.rule.crosses u = true) :
    b.firstBreach (earlier ++ u :: later) = some (b.report u) := by
  induction earlier with
  | nil => simp [CommittedBoundary.firstBreach, breached]
  | cons head tail ih =>
    have headSafe := safe head (List.mem_cons_self ..)
    have tailSafe : ∀ v, v ∈ tail → b.rule.crosses v = false :=
      fun v hv => safe v (List.mem_cons_of_mem head hv)
    simp [CommittedBoundary.firstBreach, headSafe, ih tailSafe]

structure Scenario (Use : Type) where
  decision : Use
  outcomeOccurred : Bool

/-- Breach is judged on the decision, with what was known when deciding. This
    definition never reads `outcomeOccurred`, on purpose. -/
def breachedAtDecision (b : CommittedBoundary Use anchor) (scenario : Scenario Use) : Bool :=
  b.rule.crosses scenario.decision

/-- [by construction] A later success cannot clear a breach, because
    `breachedAtDecision` ignores the outcome. This checks the encoding of the choice
    "judge reliance at the time of the decision"; it does not argue for that choice. -/
theorem outcome_cannot_clear_breach (b : CommittedBoundary Use anchor) (u : Use)
    (breached : b.rule.crosses u = true) :
    breachedAtDecision b ⟨u, true⟩ = true ∧
    breachedAtDecision b ⟨u, false⟩ = true :=
  ⟨breached, breached⟩

/-! ## Framing flags, raised before any split -/

inductive Flag where
  | frameMissing | modalityMismatch | internalContradiction
  deriving DecidableEq, Repr

/-! ## The force ladder: what was said, what was invited, what the grounds carry

Two directions. The **speaker** answers for the stronger of what the words said and
what tone, role and context invited, so a later "I only meant I'd try" cannot lower
it. The **listener** can safely rely on no more than the speaker answers for, and no
more than the speaker's grounds can carry. Both are judged at the time of the decision.
This is a model of reliance, not a legal test. -/

inductive Force where
  | possibility | intention | promise | guarantee
  deriving DecidableEq, Repr

def Force.rank : Force → Nat
  | .possibility => 0 | .intention => 1 | .promise => 2 | .guarantee => 3

structure Utterance where
  /-- What the words say. -/
  expressed : Force
  /-- What tone, role and context invited. -/
  invited : Force
  /-- The strongest force the speaker's grounds can carry. -/
  supportable : Force

def Utterance.accountable (u : Utterance) : Nat := max u.expressed.rank u.invited.rank

/-- The speaker answers for reliance up to this force. -/
def Utterance.answersFor (u : Utterance) (r : Force) : Bool :=
  decide (r.rank ≤ u.accountable)

/-- The listener had grounds to rely up to this force. -/
def Utterance.safeToRely (u : Utterance) (r : Force) : Bool :=
  decide (r.rank ≤ u.accountable ∧ r.rank ≤ u.supportable.rank)

/-- The framing flag, computed: the words claim more than the grounds carry. -/
def Utterance.modalityMismatch (u : Utterance) : Bool :=
  decide (u.supportable.rank < u.expressed.rank)

/-- [content] Speaker side: an invitation counts. If role and context invited a
    promise, the speaker answers for a promise, even if the words only said "can". -/
theorem invitation_counts (u : Utterance) (h : u.invited = .promise) :
    u.answersFor .promise = true := by
  unfold Utterance.answersFor Utterance.accountable
  rw [h]
  exact decide_eq_true (Nat.le_max_right _ _)

/-- [content] Listener side: relying beyond what the speaker answers for is the
    listener's over-reading. -/
theorem overreading_unwarranted (u : Utterance) (r : Force) (h : u.accountable < r.rank) :
    u.answersFor r = false ∧ u.safeToRely r = false := by
  unfold Utterance.answersFor Utterance.safeToRely
  constructor
  · exact decide_eq_false (Nat.not_le.mpr h)
  · exact decide_eq_false (fun hr => Nat.not_le.mpr h hr.1)

/-- [content] Both directions at once. When the words claim more than the grounds
    carry, the speaker still answers for the words, and the listener still cannot
    safely rely on them. "Never again" binds the one who says it, and is no guarantee
    to the one who hears it. -/
theorem mismatch_binds_speaker_not_listener (u : Utterance)
    (h : u.modalityMismatch = true) :
    u.answersFor u.expressed = true ∧ u.safeToRely u.expressed = false := by
  unfold Utterance.modalityMismatch at h
  have hlt : u.supportable.rank < u.expressed.rank := of_decide_eq_true h
  unfold Utterance.answersFor Utterance.safeToRely Utterance.accountable
  constructor
  · exact decide_eq_true (Nat.le_max_left _ _)
  · exact decide_eq_false (fun hr => Nat.not_le.mpr hlt hr.2)

/-! # Part 5. The four cases -/

namespace Coach

/-- "You'll lose X kg in a month." An ad with no limitations; the coach is not a
    medical adviser. -/
inductive Use where
  | readAsSalesPromise        -- IS: a best case presented as the typical result
  | takeAsSomeoneGotIt        -- IS_AT_LEAST: someone, somewhere, once got it
  | askDoctorAboutTarget      -- IS_AT_LEAST: a legitimate use of the claim
  | expectSameResultYourself  -- IS_NOT: the neighbour (disappointment, not danger)
  | planHealthAroundIt        -- IS_AT_LEAST_NOT: the ad as medical advice
  deriving DecidableEq, Repr

def split : Split Use where
  is := (· = .readAsSalesPromise)
  isAtLeast := fun u =>
    u = .readAsSalesPromise ∨ u = .takeAsSomeoneGotIt ∨ u = .askDoctorAboutTarget
  isNot := (· = .expectSameResultYourself)
  floor := fun _ h => Or.inl h

def rule : Draft Use where
  claim := "You'll lose X kg in a month."
  forbiddenUse := "Plan your health around the number."
  danger := "Chasing the number pushes you towards unsafe restriction."
  other := "Medical advice from someone who knows your case"
  why := .healthAssessment
  crosses u := decide (u = .planHealthAroundIt)

def boundary : CommittedBoundary Use .warrantedReliance where
  split := split
  rule := rule
  citedWhy := .step .health (.anchor .goal)
  excludesLegitimateUse := by intro u h; cases u <;> simp_all [rule, split]

/-- [check] The neighbour is not the Other: expecting the same result is a misreading,
    not the danger. -/
theorem neighbour_is_not_other : boundary.NeighbourIsNotOther :=
  ⟨.expectSameResultYourself, rfl, rfl⟩

/-- [by construction] Hitting the target later does not clear the breach. -/
theorem hit_target_still_breached :
    breachedAtDecision boundary ⟨.planHealthAroundIt, true⟩ = true := rfl

/-- [check] Legitimate uses pass the monitor. -/
theorem legitimate_uses_pass :
    boundary.firstBreach [.readAsSalesPromise, .askDoctorAboutTarget,
                          .expectSameResultYourself] = none := rfl

def flags : List Flag := [.frameMissing, .modalityMismatch]

/-- "You'll" is a promise; an ad with no limitations can ground only a possibility. -/
def utterance : Utterance := ⟨.promise, .promise, .possibility⟩

/-- [check] The flag list agrees with the computed modality mismatch. -/
theorem flags_agree : decide (Flag.modalityMismatch ∈ flags) = utterance.modalityMismatch := by
  decide

/-- [check] The ad answers for its promise; the reader cannot safely rely on it. -/
theorem promise_binds_ad_not_reader :
    utterance.answersFor .promise = true ∧ utterance.safeToRely .promise = false :=
  mismatch_binds_speaker_not_listener utterance rfl

end Coach

namespace Investment

/-- "You can multiply your investments." An ad with no limitations. -/
inductive Use where
  | readAsBestCase            -- IS: a best case or back-tested past, shown as the future
  | takeAsHappenedForSomeone  -- IS_AT_LEAST: it happened for someone, in some period
  | askForRiskAndPeriod       -- IS_AT_LEAST: a legitimate use of the claim
  | treatAsExpectedReturn     -- IS_NOT: the neighbour (blurs in a strong market)
  | investWhatYouCannotLose   -- IS_AT_LEAST_NOT: the ad as a guarantee
  deriving DecidableEq, Repr

def split : Split Use where
  is := (· = .readAsBestCase)
  isAtLeast := fun u =>
    u = .readAsBestCase ∨ u = .takeAsHappenedForSomeone ∨ u = .askForRiskAndPeriod
  isNot := (· = .treatAsExpectedReturn)
  floor := fun _ h => Or.inl h

def rule : Draft Use where
  claim := "You can multiply your investments."
  forbiddenUse := "Put money behind it that you cannot afford to lose."
  danger := "Losses; and \"guaranteed high returns\" is a classic sign of fraud."
  other := "A guarantee that nobody can give"
  why := .returnRisk
  crosses u := decide (u = .investWhatYouCannotLose)

def boundary : CommittedBoundary Use .warrantedReliance where
  split := split
  rule := rule
  citedWhy := .step .investment (.anchor .goal)
  excludesLegitimateUse := by intro u h; cases u <;> simp_all [rule, split]

/-- [check] The neighbour is not the Other. -/
theorem neighbour_is_not_other : boundary.NeighbourIsNotOther :=
  ⟨.treatAsExpectedReturn, rfl, rfl⟩

/-- [by construction] A return that did arrive does not clear the breach. -/
theorem return_delivered_still_breached :
    breachedAtDecision boundary ⟨.investWhatYouCannotLose, true⟩ = true := rfl

/-- [check] Legitimate uses pass the monitor. -/
theorem legitimate_uses_pass :
    boundary.firstBreach [.readAsBestCase, .askForRiskAndPeriod,
                          .treatAsExpectedReturn] = none := rfl

/-- No modality mismatch in the words: "can" claims only a possibility. -/
def flags : List Flag := [.frameMissing]

/-- The words say "can"; an ad with no limitations invites a promise. -/
def utterance : Utterance := ⟨.possibility, .promise, .possibility⟩

/-- [check] The flag list agrees with the computed modality mismatch. -/
theorem flags_agree : decide (Flag.modalityMismatch ∈ flags) = utterance.modalityMismatch := by
  decide

/-- [content] The ad cannot retreat to "we only said *can*": it invited a promise. -/
theorem cannot_retreat_to_can : utterance.answersFor .promise = true :=
  invitation_counts utterance rfl

/-- [check] Yet the reader had no grounds to rely on a promise. Honest words do not
    make an honest invitation, and the framing flags alone do not catch it. -/
theorem reader_cannot_rely_on_promise : utterance.safeToRely .promise = false := by
  decide

end Investment

namespace Partner

/-- "It was just once. It will never happen again." -/
inductive Use where
  | readAsAdmissionAndPromise  -- IS: a claim about the past plus a promise
  | takeAsAdmission            -- IS_AT_LEAST: it happened, and a wish to stay
  | workOnRepair               -- IS_AT_LEAST: a legitimate use
  | takeAsProofItWasOnce       -- IS_NOT: the neighbour (blurs: sometimes it was once)
  | stopCheckingBehaviour      -- IS_AT_LEAST_NOT: the sentence as rebuilt trust
  deriving DecidableEq, Repr

def split : Split Use where
  is := (· = .readAsAdmissionAndPromise)
  isAtLeast := fun u =>
    u = .readAsAdmissionAndPromise ∨ u = .takeAsAdmission ∨ u = .workOnRepair
  isNot := (· = .takeAsProofItWasOnce)
  floor := fun _ h => Or.inl h

def rule : Draft Use where
  claim := "It was just once. It will never happen again."
  forbiddenUse := "Stop looking at behaviour because a sentence closed the case."
  danger := "Trust is given on a statement that nothing has tested."
  other := "Rebuilt trust, which only actions over time provide"
  why := .trustFollowsActions
  crosses u := decide (u = .stopCheckingBehaviour)

def boundary : CommittedBoundary Use .warrantedReliance where
  split := split
  rule := rule
  citedWhy := .step .partner (.anchor .goal)
  excludesLegitimateUse := by intro u h; cases u <;> simp_all [rule, split]

/-- [check] The neighbour is not the Other. -/
theorem neighbour_is_not_other : boundary.NeighbourIsNotOther :=
  ⟨.takeAsProofItWasOnce, rfl, rfl⟩

/-- [by construction] No recurrence later does not clear the breach. -/
theorem no_recurrence_still_breached :
    breachedAtDecision boundary ⟨.stopCheckingBehaviour, true⟩ = true := rfl

/-- [check] Legitimate uses pass the monitor. -/
theorem legitimate_uses_pass :
    boundary.firstBreach [.readAsAdmissionAndPromise, .workOnRepair,
                          .takeAsProofItWasOnce] = none := rfl

/-! ### The agreement: why the cheating stands

There was an agreement, so it is a written line, and the cheating crossed it. -/

inductive Conduct where
  | keepAgreement | cheat | promiseNeverAgain
  deriving DecidableEq, Repr

def agreementBoundary : CommittedBoundary Conduct .agreement where
  split := {
    is := (· = .keepAgreement)
    isAtLeast := (· ≠ .cheat)
    -- The nearest confusion: a promise to keep it is not keeping it.
    isNot := (· = .promiseNeverAgain)
    floor := by intro u h; cases h; decide }
  rule := {
    claim := "The agreement between the partners."
    forbiddenUse := "Cheat."
    danger := "The agreement stops meaning anything."
    other := "No agreement at all"
    why := .agreement
    crosses := fun u => decide (u = .cheat) }
  citedWhy := .anchor .agreed
  excludesLegitimateUse := by intro u h; cases u <;> simp_all

/-- [content] "Never again" does not restore the line: whatever comes after the
    breach, the record still shows it. Only a new commitment, stated as new, can be
    written. -/
theorem never_again_keeps_record (later : List Conduct) :
    agreementBoundary.firstBreach (.cheat :: later) =
      some (agreementBoundary.report .cheat) :=
  stops_at_first_breach agreementBoundary [] .cheat later (fun _ h => nomatch h) rfl

/-- [check] The same, with the promise and a kept agreement after the breach. -/
theorem promise_after_breach :
    agreementBoundary.firstBreach [.cheat, .promiseNeverAgain, .keepAgreement] =
      some (agreementBoundary.report .cheat) :=
  never_again_keeps_record _

def flags : List Flag := [.modalityMismatch]

/-- "Never" claims a guarantee; after a breach the grounds carry only a promise. -/
def utterance : Utterance := ⟨.guarantee, .guarantee, .promise⟩

/-- [check] The flag list agrees with the computed modality mismatch. -/
theorem flags_agree : decide (Flag.modalityMismatch ∈ flags) = utterance.modalityMismatch := by
  decide

/-- [check] "Never" binds the one who says it, and is no guarantee to the one who
    hears it. -/
theorem never_binds_speaker_not_listener :
    utterance.answersFor .guarantee = true ∧ utterance.safeToRely .guarantee = false :=
  mismatch_binds_speaker_not_listener utterance rfl

end Partner

namespace EV

/-! "EV-mode range: 98 km" (lexus-polska.pl, NX 450h+ spec block, read 2026-11-24).
The page names no protocol, temperature or speed. Published figures for this car put
98 km at the top of the WLTP *city* cycle (WLTP combined is about 69–76 km), so the
frame assumed below is "WLTP city cycle", marked as assumed. -/

/-- [check] The page contradicts itself: the spec block's 98 km lies outside the
    66–93 km band in its benefits section, and the page does not say which one wins. -/
theorem page_contradicts_itself : ¬ (66 ≤ 98 ∧ 98 ≤ 93) := by decide

def flags : List Flag := [.frameMissing, .internalContradiction]

inductive Use where
  | quoteTestFigure          -- IS: a test-cycle figure (assumed: WLTP city)
  | compareSameProtocol      -- IS_AT_LEAST: compare cars measured the same way
  | expectInMildCityDriving  -- IS and IS_NOT: the blur (mild city driving can match)
  | expectOnWinterMotorway   -- IS_NOT: the neighbour (disappointment; the engine starts)
  | planWithNoMargin         -- IS_AT_LEAST_NOT: the figure as your real-world range
  deriving DecidableEq, Repr

def split : Split Use where
  is := fun u => u = .quoteTestFigure ∨ u = .expectInMildCityDriving
  isAtLeast := fun u =>
    u = .quoteTestFigure ∨ u = .compareSameProtocol ∨ u = .expectInMildCityDriving
  isNot := fun u => u = .expectInMildCityDriving ∨ u = .expectOnWinterMotorway
  floor := by
    intro u h
    rcases h with h | h
    · exact Or.inl h
    · exact Or.inr (Or.inr h)

def rule : Draft Use where
  claim := "EV-mode range: 98 km."
  forbiddenUse :=
    "Plan an all-electric commute, a fuel budget or a company-car calculation on 98 km with no margin."
  danger := "In winter or at speed the engine starts and the plan's numbers break."
  other := "Your real-world range"
  why := .measuredConditions
  crosses u := decide (u = .planWithNoMargin)

def boundary : CommittedBoundary Use .warrantedReliance where
  split := split
  rule := rule
  citedWhy := .step .ev (.anchor .goal)
  excludesLegitimateUse := by intro u h; cases u <;> simp_all [rule, split]

/-- [check] The IS/IS_NOT line blurs: in mild city driving the test figure and your
    range can coincide. -/
theorem blur_is_possible : ∃ u, split.is u ∧ split.isNot u :=
  ⟨.expectInMildCityDriving, Or.inr rfl, Or.inl rfl⟩

/-- [check] The neighbour is not the Other: the winter motorway reading disappoints,
    but the engine starts, so nothing breaks unless you planned with no margin. -/
theorem neighbour_is_not_other : boundary.NeighbourIsNotOther :=
  ⟨.expectOnWinterMotorway, Or.inr rfl, rfl⟩

/-- "Never use the 98 km figure": too broad to be an IS_AT_LEAST_NOT. -/
def overbroadDraft : Draft Use :=
  { rule with forbiddenUse := "Never use the 98 km figure."
              crosses := fun _ => true }

/-- [check] Comparing cars on the same protocol is a legitimate use, so the overbroad
    draft has a counterexample. -/
theorem legitimate_comparison_rejects_overbroad_draft :
    overbroadDraft.Counterexample split :=
  ⟨.compareSameProtocol, Or.inr (Or.inl rfl), rfl⟩

/-- [content] So the overbroad draft cannot be committed: it moves to IS_NOT. -/
theorem overbroad_draft_not_committable :
    ¬ (∀ u, split.isAtLeast u → overbroadDraft.crosses u = false) :=
  counterexample_blocks_commitment split overbroadDraft
    legitimate_comparison_rejects_overbroad_draft

/-- [by construction] Making the trip on electricity this time does not clear the
    breach. -/
theorem trip_made_still_breached :
    breachedAtDecision boundary ⟨.planWithNoMargin, true⟩ = true := rfl

/-- [check] The monitor stops at the no-margin plan. -/
theorem monitor_stops_at_plan :
    boundary.firstBreach [.compareSameProtocol, .planWithNoMargin,
                          .expectInMildCityDriving] =
      some (boundary.report .planWithNoMargin) := rfl

end EV

/-! # Part 6. Every case meets the same checks -/

/-- [check] All four boundaries are valid four-line splits (Part 1). -/
def setModels : List (Σ U : Type, SetModel.Split U) :=
  [⟨_, Coach.boundary.toSetModel⟩, ⟨_, Investment.boundary.toSetModel⟩,
   ⟨_, Partner.boundary.toSetModel⟩, ⟨_, EV.boundary.toSetModel⟩]

/-- [check] In every case, the nearest confusion is not the Other. -/
theorem every_neighbour_is_not_the_other :
    Coach.boundary.NeighbourIsNotOther ∧ Investment.boundary.NeighbourIsNotOther ∧
    Partner.boundary.NeighbourIsNotOther ∧ EV.boundary.NeighbourIsNotOther :=
  ⟨Coach.neighbour_is_not_other, Investment.neighbour_is_not_other,
   Partner.neighbour_is_not_other, EV.neighbour_is_not_other⟩

end Claims
end LacanSplit
